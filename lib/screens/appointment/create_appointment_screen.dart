import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../models/appointment_model.dart';
import '../../models/mechanic_model.dart';
import 'package:uuid/uuid.dart';

class CreateAppointmentScreen extends StatefulWidget {
  final String mechanicId;

  const CreateAppointmentScreen({Key? key, required this.mechanicId}) : super(key: key);

  @override
  _CreateAppointmentScreenState createState() => _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String? _selectedCarId;
  List<String> _selectedServices = [];
  List<File> _selectedPhotos = [];
  bool _isLoading = false;
  final _imagePicker = ImagePicker();
  final _uuid = Uuid();

  MechanicModel? _mechanic;
  Map<String, dynamic>? _userCars;
  List<String> _availableTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _loadMechanicData();
    _loadUserCars();
  }

  Future<void> _loadMechanicData() async {
    final doc = await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(widget.mechanicId)
        .get();
    
    if (doc.exists) {
      setState(() {
        _mechanic = MechanicModel.fromMap(doc.data()!);
      });
    }
  }

  Future<void> _loadUserCars() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cars')
          .get();
      
      setState(() {
        _userCars = {
          for (var car in doc.docs)
            car.id: car.data()['brand'] + ' ' + car.data()['model']
        };
      });
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _selectedTimeSlot = null;
      });
      _loadAvailableTimeSlots(date);
    }
  }

  Future<void> _loadAvailableTimeSlots(DateTime date) async {
    // Ustanın çalışma saatlerini kontrol et
    final dayName = _getDayName(date.weekday);
    final workingHours = _mechanic?.workingHours[dayName] ?? [];
    
    if (workingHours.isEmpty) {
      setState(() {
        _availableTimeSlots = [];
      });
      return;
    }

    // Mevcut randevuları getir
    final appointments = await FirebaseFirestore.instance
        .collection('appointments')
        .where('mechanicId', isEqualTo: widget.mechanicId)
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .get();

    final bookedSlots = appointments.docs.map((doc) => doc['timeSlot'] as String).toList();

    // Müsait zaman dilimlerini hesapla
    final slots = _generateTimeSlots(workingHours[0], workingHours[1]);
    
    setState(() {
      _availableTimeSlots = slots.where((slot) => !bookedSlots.contains(slot)).toList();
    });
  }

  List<String> _generateTimeSlots(String start, String end) {
    final slots = <String>[];
    final startTime = _parseTime(start);
    final endTime = _parseTime(end);
    
    var currentSlot = startTime;
    while (currentSlot.isBefore(endTime)) {
      slots.add(_formatTime(currentSlot));
      currentSlot = currentSlot.add(Duration(minutes: 30));
    }
    
    return slots;
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Pazartesi';
      case 2: return 'Salı';
      case 3: return 'Çarşamba';
      case 4: return 'Perşembe';
      case 5: return 'Cuma';
      case 6: return 'Cumartesi';
      case 7: return 'Pazar';
      default: return '';
    }
  }

  Future<void> _pickPhotos() async {
    final pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedPhotos.addAll(pickedFiles.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<List<String>> _uploadPhotos(String appointmentId) async {
    final urls = <String>[];
    
    for (var i = 0; i < _selectedPhotos.length; i++) {
      final file = _selectedPhotos[i];
      final ref = FirebaseStorage.instance
          .ref()
          .child('appointment_photos')
          .child(appointmentId)
          .child('photo_$i.jpg');

      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  Future<void> _createAppointment() async {
    if (!_formKey.currentState!.validate() || 
        _selectedDate == null || 
        _selectedTimeSlot == null ||
        _selectedCarId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Kullanıcı oturumu bulunamadı');

      final appointmentId = _uuid.v4();
      final photoUrls = await _uploadPhotos(appointmentId);

      final appointment = AppointmentModel(
        id: appointmentId,
        userId: user.uid,
        mechanicId: widget.mechanicId,
        carId: _selectedCarId!,
        date: _selectedDate!,
        timeSlot: _selectedTimeSlot!,
        status: AppointmentStatus.pending,
        description: _descriptionController.text,
        services: _selectedServices,
        photos: photoUrls,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .set(appointment.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Randevunuz başarıyla oluşturuldu')),
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

  @override
  Widget build(BuildContext context) {
    if (_mechanic == null || _userCars == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Randevu Oluştur')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Randevu Oluştur'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildMechanicInfo(),
            SizedBox(height: 24),
            _buildCarSelection(),
            SizedBox(height: 16),
            _buildDateSelection(),
            SizedBox(height: 16),
            _buildTimeSelection(),
            SizedBox(height: 16),
            _buildServicesSection(),
            SizedBox(height: 16),
            _buildDescriptionField(),
            SizedBox(height: 16),
            _buildPhotoSection(),
            SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMechanicInfo() {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_mechanic!.photoUrl),
        ),
        title: Text(_mechanic!.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Değerlendirme: ${_mechanic!.rating.toStringAsFixed(1)}'),
            Text('Tamamlanan İşler: ${_mechanic!.completedJobs}'),
          ],
        ),
      ),
    );
  }

  Widget _buildCarSelection() {
    return DropdownButtonFormField<String>(
      value: _selectedCarId,
      decoration: InputDecoration(
        labelText: 'Araç Seçin',
        border: OutlineInputBorder(),
      ),
      items: _userCars!.entries.map((entry) {
        return DropdownMenuItem(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCarId = value;
        });
      },
    );
  }

  Widget _buildDateSelection() {
    return ListTile(
      title: Text(_selectedDate == null
          ? 'Tarih Seçin'
          : 'Seçilen Tarih: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
      trailing: Icon(Icons.calendar_today),
      onTap: _pickDate,
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Randevu Saati',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        if (_selectedDate == null)
          Text('Önce tarih seçin')
        else if (_availableTimeSlots.isEmpty)
          Text('Bu tarihte müsait zaman dilimi bulunmuyor')
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTimeSlots.map((slot) {
              return ChoiceChip(
                label: Text(slot),
                selected: _selectedTimeSlot == slot,
                onSelected: (selected) {
                  setState(() {
                    _selectedTimeSlot = selected ? slot : null;
                  });
                },
              );
            }).toList(),
          ),
      ],
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
              'Hizmetler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _mechanic!.services.map((service) {
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

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Sorun Açıklaması',
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen sorunu açıklayın';
        }
        return null;
      },
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(_selectedPhotos.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(_selectedPhotos[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPhotos.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (_selectedPhotos.length < 5)
                GestureDetector(
                  onTap: _pickPhotos,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add_photo_alternate, size: 40),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _createAppointment,
      child: _isLoading
          ? CircularProgressIndicator()
          : Text('Randevu Oluştur'),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
} 