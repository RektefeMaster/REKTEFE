import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/car_model.dart';

class CarFormScreen extends StatefulWidget {
  final CarModel? car;

  const CarFormScreen({Key? key, this.car}) : super(key: key);

  @override
  _CarFormScreenState createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedBrand = '';
  String _selectedModel = '';
  String _selectedYear = '';
  String _selectedEngineType = '';
  String _selectedEngineSize = '';
  String _selectedTransmission = '';
  String _selectedFuelType = '';
  final _plateController = TextEditingController();
  bool _isLoading = false;

  List<String> _availableModels = [];
  List<String> _availableEngineTypes = [];

  @override
  void initState() {
    super.initState();
    if (widget.car != null) {
      _selectedBrand = widget.car!.brand;
      _selectedModel = widget.car!.model;
      _selectedYear = widget.car!.year;
      _selectedEngineType = widget.car!.engineType;
      _selectedEngineSize = widget.car!.engineSize;
      _selectedTransmission = widget.car!.transmission;
      _selectedFuelType = widget.car!.fuelType;
      _plateController.text = widget.car!.plateNumber;
      _updateAvailableModels();
      _updateAvailableEngineTypes();
    }
  }

  void _updateAvailableModels() {
    if (_selectedBrand.isNotEmpty) {
      _availableModels = CarBrands.brands[_selectedBrand] ?? [];
      if (!_availableModels.contains(_selectedModel)) {
        _selectedModel = '';
      }
    } else {
      _availableModels = [];
      _selectedModel = '';
    }
  }

  void _updateAvailableEngineTypes() {
    if (_selectedBrand.isNotEmpty) {
      _availableEngineTypes = CarBrands.engineTypes[_selectedBrand] ?? [];
      if (!_availableEngineTypes.contains(_selectedEngineType)) {
        _selectedEngineType = '';
      }
    } else {
      _availableEngineTypes = [];
      _selectedEngineType = '';
    }
  }

  Future<void> _saveCar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception('Kullanıcı oturumu bulunamadı');

        final carData = CarModel(
          brand: _selectedBrand,
          model: _selectedModel,
          year: _selectedYear,
          engineType: _selectedEngineType,
          engineSize: _selectedEngineSize,
          transmission: _selectedTransmission,
          fuelType: _selectedFuelType,
          plateNumber: _plateController.text.trim(),
        ).toMap();

        if (widget.car != null) {
          // Mevcut aracı güncelle
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'cars': FieldValue.arrayRemove([widget.car!.toMap()]),
          });
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'cars': FieldValue.arrayUnion([carData]),
        });

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
        title: Text(widget.car == null ? 'Araç Ekle' : 'Aracı Düzenle'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildDropdownField(
              label: 'Marka',
              value: _selectedBrand,
              items: CarBrands.brands.keys.toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBrand = value ?? '';
                  _updateAvailableModels();
                  _updateAvailableEngineTypes();
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdownField(
              label: 'Model',
              value: _selectedModel,
              items: _availableModels,
              onChanged: (value) {
                setState(() {
                  _selectedModel = value ?? '';
                });
              },
              enabled: _selectedBrand.isNotEmpty,
            ),
            SizedBox(height: 16),
            _buildDropdownField(
              label: 'Yıl',
              value: _selectedYear,
              items: List.generate(30, (index) => (2024 - index).toString()),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value ?? '';
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdownField(
              label: 'Motor Tipi',
              value: _selectedEngineType,
              items: _availableEngineTypes,
              onChanged: (value) {
                setState(() {
                  _selectedEngineType = value ?? '';
                });
              },
              enabled: _selectedBrand.isNotEmpty,
            ),
            SizedBox(height: 16),
            _buildDropdownField(
              label: 'Motor Hacmi',
              value: _selectedEngineSize,
              items: CarBrands.engineSizes,
              onChanged: (value) {
                setState(() {
                  _selectedEngineSize = value ?? '';
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdownField(
              label: 'Şanzıman',
              value: _selectedTransmission,
              items: CarBrands.transmissionTypes,
              onChanged: (value) {
                setState(() {
                  _selectedTransmission = value ?? '';
                });
              },
            ),
            SizedBox(height: 16),
            _buildDropdownField(
              label: 'Yakıt Tipi',
              value: _selectedFuelType,
              items: CarBrands.fuelTypes,
              onChanged: (value) {
                setState(() {
                  _selectedFuelType = value ?? '';
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _plateController,
              decoration: InputDecoration(
                labelText: 'Plaka',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen plaka numarasını girin';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveCar,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Kaydet'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    bool enabled = true,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isNotEmpty ? value : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen $label seçin';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }
} 