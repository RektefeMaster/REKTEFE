import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../models/mechanic_model.dart';
import '../../models/car_model.dart';

class MechanicApplicationScreen extends StatefulWidget {
  @override
  _MechanicApplicationScreenState createState() => _MechanicApplicationScreenState();
}

class _MechanicApplicationScreenState extends State<MechanicApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _aboutController = TextEditingController();
  bool _isLoading = false;
  File? _selectedImage;
  final _imagePicker = ImagePicker();

  List<String> _selectedSpecialties = [];
  Map<String, List<String>> _selectedExpertise = {};
  Map<String, List<String>> _workingHours = MechanicSpecialties.workingHours;
  List<String> _selectedServices = [];

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(String userId) async {
    if (_selectedImage == null) return null;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('mechanic_photos')
          .child('$userId.jpg');

      await ref.putFile(_selectedImage!);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Fotoğraf yükleme hatası: $e');
      return null;
    }
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception('Kullanıcı oturumu bulunamadı');

        // Fotoğrafı yükle
        final photoUrl = await _uploadImage(user.uid);

        // Usta profilini oluştur
        final mechanicProfile = MechanicModel(
          userId: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          photoUrl: photoUrl ?? '',
          address: _addressController.text,
          specialties: _selectedSpecialties,
          expertiseByBrand: _selectedExpertise,
          workingHours: _workingHours,
          services: _selectedServices,
          about: _aboutController.text,
        ).toMap();

        // Firestore'a kaydet
        await FirebaseFirestore.instance
            .collection('mechanic_applications')
            .doc(user.uid)
            .set({
          ...mechanicProfile,
          'status': 'pending',
          'applied_at': FieldValue.serverTimestamp(),
        });

        // Kullanıcı rolünü güncelle
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'role': 'pending_mechanic',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Başvurunuz alındı. İnceleme sonrası size bilgi vereceğiz.')),
        );

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usta Başvurusu'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildImagePicker(),
            SizedBox(height: 24),
            _buildAddressField(),
            SizedBox(height: 16),
            _buildSpecialtiesSection(),
            SizedBox(height: 16),
            _buildExpertiseSection(),
            SizedBox(height: 16),
            _buildWorkingHoursSection(),
            SizedBox(height: 16),
            _buildServicesSection(),
            SizedBox(height: 16),
            _buildAboutField(),
            SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: _selectedImage != null
                ? ClipOval(
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.person, size: 60, color: Colors.grey),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 18,
              child: IconButton(
                icon: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(
        labelText: 'İşyeri Adresi',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen adres girin';
        }
        return null;
      },
    );
  }

  Widget _buildSpecialtiesSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Uzmanlık Alanları',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MechanicSpecialties.specialties.map((specialty) {
                return FilterChip(
                  label: Text(specialty),
                  selected: _selectedSpecialties.contains(specialty),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSpecialties.add(specialty);
                      } else {
                        _selectedSpecialties.remove(specialty);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertiseSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Marka Uzmanlığı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...CarBrands.brands.keys.map((brand) {
              return ExpansionTile(
                title: Text(brand),
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...CarBrands.engineTypes[brand]?.map((engine) {
                        return FilterChip(
                          label: Text(engine),
                          selected: _selectedExpertise[brand]?.contains(engine) ?? false,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedExpertise[brand] = [
                                  ...(_selectedExpertise[brand] ?? []),
                                  engine,
                                ];
                              } else {
                                _selectedExpertise[brand]?.remove(engine);
                                if (_selectedExpertise[brand]?.isEmpty ?? false) {
                                  _selectedExpertise.remove(brand);
                                }
                              }
                            });
                          },
                        );
                      }) ?? [],
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHoursSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Çalışma Saatleri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...MechanicSpecialties.workingHours.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                trailing: entry.value.isEmpty
                    ? Text('Kapalı')
                    : Text('${entry.value[0]} - ${entry.value[1]}'),
                onTap: () {
                  // Çalışma saati düzenleme modalı açılabilir
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sunulan Hizmetler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MechanicSpecialties.services.map((service) {
                return FilterChip(
                  label: Text(service),
                  selected: _selectedServices.contains(service),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedServices.add(service);
                      } else {
                        _selectedServices.remove(service);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutField() {
    return TextFormField(
      controller: _aboutController,
      decoration: InputDecoration(
        labelText: 'Hakkınızda',
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen kendinizi tanıtın';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitApplication,
      child: _isLoading
          ? CircularProgressIndicator()
          : Text('Başvuruyu Gönder'),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _aboutController.dispose();
    super.dispose();
  }
} 