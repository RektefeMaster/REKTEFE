import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/spare_part_model.dart';

class SparePartFormScreen extends StatefulWidget {
  final String? partId;

  const SparePartFormScreen({Key? key, this.partId}) : super(key: key);

  @override
  _SparePartFormScreenState createState() => _SparePartFormScreenState();
}

class _SparePartFormScreenState extends State<SparePartFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _stockController = TextEditingController();
  final _compatibilityBrandController = TextEditingController();
  final _compatibilityModelController = TextEditingController();

  String _selectedCategory = SparePartCategory.values.first;
  String _selectedCondition = SparePartCondition.newPart;
  List<String> _photos = [];
  List<File> _newPhotos = [];
  Map<String, List<String>> _compatibility = {};
  bool _isLoading = false;
  SparePartModel? _existingPart;

  @override
  void initState() {
    super.initState();
    if (widget.partId != null) {
      _loadExistingPart();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _stockController.dispose();
    _compatibilityBrandController.dispose();
    _compatibilityModelController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingPart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final doc = await FirebaseFirestore.instance
          .collection('spare_parts')
          .doc(widget.partId)
          .get();

      if (doc.exists) {
        _existingPart = SparePartModel.fromMap({...doc.data()!, 'id': doc.id});
        _nameController.text = _existingPart!.name;
        _descriptionController.text = _existingPart!.description;
        _priceController.text = _existingPart!.price.toString();
        _brandController.text = _existingPart!.brand;
        _modelController.text = _existingPart!.model;
        _stockController.text = _existingPart!.stock.toString();
        _selectedCategory = _existingPart!.category;
        _selectedCondition = _existingPart!.condition;
        _photos = List.from(_existingPart!.photos);
        _compatibility = Map.from(_existingPart!.compatibility);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _newPhotos.addAll(
          pickedFiles.map((file) => File(file.path)),
        );
      });
    }
  }

  Future<List<String>> _uploadPhotos() async {
    final uploadedUrls = <String>[];

    for (final photo in _newPhotos) {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance
          .ref()
          .child('spare_parts')
          .child(fileName);

      final uploadTask = ref.putFile(photo);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      uploadedUrls.add(url);
    }

    return uploadedUrls;
  }

  void _addCompatibility() {
    final brand = _compatibilityBrandController.text.trim();
    final model = _compatibilityModelController.text.trim();

    if (brand.isEmpty || model.isEmpty) return;

    setState(() {
      if (!_compatibility.containsKey(brand)) {
        _compatibility[brand] = [];
      }
      if (!_compatibility[brand]!.contains(model)) {
        _compatibility[brand]!.add(model);
      }
    });

    _compatibilityBrandController.clear();
    _compatibilityModelController.clear();
  }

  void _removeCompatibility(String brand, String model) {
    setState(() {
      _compatibility[brand]!.remove(model);
      if (_compatibility[brand]!.isEmpty) {
        _compatibility.remove(brand);
      }
    });
  }

  Future<void> _savePart() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Kullanıcı girişi yapılmamış');

      final uploadedUrls = await _uploadPhotos();
      final allPhotos = [..._photos, ...uploadedUrls];

      final data = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.parse(_priceController.text),
        'category': _selectedCategory,
        'brand': _brandController.text,
        'model': _modelController.text,
        'condition': _selectedCondition,
        'sellerId': user.uid,
        'sellerName': user.displayName ?? 'İsimsiz Satıcı',
        'photos': allPhotos,
        'compatibility': _compatibility,
        'stock': int.parse(_stockController.text),
        'isAvailable': true,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.partId != null) {
        await FirebaseFirestore.instance
            .collection('spare_parts')
            .doc(widget.partId)
            .update(data);
      } else {
        data['createdAt'] = FieldValue.serverTimestamp();
        data['rating'] = null;
        data['reviewCount'] = 0;
        await FirebaseFirestore.instance
            .collection('spare_parts')
            .add(data);
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.partId != null && _existingPart == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Yükleniyor...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.partId != null ? 'Parça Düzenle' : 'Yeni Parça Ekle'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildPhotoSection(),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Parça Adı',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Parça adı gerekli';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Açıklama gerekli';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Fiyat (₺)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fiyat gerekli';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Geçerli bir fiyat girin';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    decoration: InputDecoration(
                      labelText: 'Stok',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Stok gerekli';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Geçerli bir sayı girin';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: SparePartCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(SparePartCategory.getLocalizedName(category)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _brandController,
                    decoration: InputDecoration(
                      labelText: 'Marka',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Marka gerekli';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      labelText: 'Model',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Model gerekli';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              decoration: InputDecoration(
                labelText: 'Durum',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: SparePartCondition.newPart,
                  child: Text(SparePartCondition.getLocalizedName(SparePartCondition.newPart)),
                ),
                DropdownMenuItem(
                  value: SparePartCondition.used,
                  child: Text(SparePartCondition.getLocalizedName(SparePartCondition.used)),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCondition = value;
                  });
                }
              },
            ),
            SizedBox(height: 24),
            Text(
              'Uyumluluk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _compatibilityBrandController,
                    decoration: InputDecoration(
                      labelText: 'Araç Markası',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _compatibilityModelController,
                    decoration: InputDecoration(
                      labelText: 'Araç Modeli',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _addCompatibility,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildCompatibilityList(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _savePart,
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('Kaydet'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fotoğraflar',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._photos.map((url) => _buildPhotoItem(url: url)),
              ..._newPhotos.map((file) => _buildPhotoItem(file: file)),
              Container(
                width: 120,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: _pickImage,
                  icon: Icon(Icons.add_photo_alternate),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoItem({String? url, File? file}) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: url != null
                  ? NetworkImage(url) as ImageProvider
                  : FileImage(file!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.close, size: 20),
              onPressed: () {
                setState(() {
                  if (url != null) {
                    _photos.remove(url);
                  } else {
                    _newPhotos.remove(file);
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompatibilityList() {
    return Column(
      children: _compatibility.entries.map((entry) {
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: entry.value.map((model) {
                    return Chip(
                      label: Text(model),
                      onDeleted: () => _removeCompatibility(entry.key, model),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
} 