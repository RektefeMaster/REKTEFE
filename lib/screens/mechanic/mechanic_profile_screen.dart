import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/mechanic_model.dart';
import '../../models/appointment_model.dart';
import '../appointment/create_appointment_screen.dart';

class MechanicProfileScreen extends StatefulWidget {
  final String mechanicId;

  const MechanicProfileScreen({Key? key, required this.mechanicId}) : super(key: key);

  @override
  _MechanicProfileScreenState createState() => _MechanicProfileScreenState();
}

class _MechanicProfileScreenState extends State<MechanicProfileScreen> {
  MechanicModel? _mechanic;
  List<AppointmentModel> _completedAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMechanicData();
  }

  Future<void> _loadMechanicData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('mechanics')
          .doc(widget.mechanicId)
          .get();

      if (doc.exists) {
        setState(() {
          _mechanic = MechanicModel.fromMap(doc.data()!);
        });

        await _loadCompletedAppointments();
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

  Future<void> _loadCompletedAppointments() async {
    try {
      final appointments = await FirebaseFirestore.instance
          .collection('appointments')
          .where('mechanicId', isEqualTo: widget.mechanicId)
          .where('status', isEqualTo: AppointmentStatus.completed)
          .where('review', isNull: false)
          .orderBy('completedAt', descending: true)
          .limit(10)
          .get();

      setState(() {
        _completedAppointments = appointments.docs
            .map((doc) => AppointmentModel.fromMap({...doc.data(), 'id': doc.id}))
            .toList();
      });
    } catch (e) {
      print('Değerlendirmeleri yükleme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Usta Profili')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_mechanic == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Usta Profili')),
        body: Center(child: Text('Usta bulunamadı')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Usta Profili'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildStats(),
            _buildSpecialties(),
            _buildExpertise(),
            _buildServices(),
            _buildWorkingHours(),
            _buildReviews(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateAppointmentScreen(
                mechanicId: widget.mechanicId,
              ),
            ),
          );
        },
        icon: Icon(Icons.calendar_today),
        label: Text('Randevu Al'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_mechanic!.photoUrl),
          ),
          SizedBox(height: 16),
          Text(
            _mechanic!.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 4),
              Text(
                _mechanic!.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' (${_mechanic!.completedJobs} iş)',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            _mechanic!.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            'Tamamlanan İşler',
            _mechanic!.completedJobs.toString(),
            Icons.check_circle,
          ),
          _buildStatItem(
            'Aktif İşler',
            _mechanic!.activeJobs.toString(),
            Icons.build,
          ),
          _buildStatItem(
            'Durum',
            _mechanic!.isAvailable ? 'Müsait' : 'Meşgul',
            _mechanic!.isAvailable ? Icons.check : Icons.close,
            color: _mechanic!.isAvailable ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.blue, size: 30),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialties() {
    return Card(
      margin: EdgeInsets.all(16),
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
              children: _mechanic!.specialties.map((specialty) {
                return Chip(
                  label: Text(specialty),
                  backgroundColor: Colors.blue[50],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertise() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
            ..._mechanic!.expertiseByBrand.entries.map((entry) {
              return Column(
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
                    children: entry.value.map((engine) {
                      return Chip(
                        label: Text(engine),
                        backgroundColor: Colors.grey[200],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildServices() {
    return Card(
      margin: EdgeInsets.all(16),
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
              children: _mechanic!.services.map((service) {
                return Chip(
                  label: Text(service),
                  backgroundColor: Colors.green[50],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHours() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
            ..._mechanic!.workingHours.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(
                      entry.value.isEmpty
                          ? 'Kapalı'
                          : '${entry.value[0]} - ${entry.value[1]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviews() {
    if (_completedAppointments.isEmpty) {
      return SizedBox();
    }

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Değerlendirmeler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ..._completedAppointments.map((appointment) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < (appointment.rating ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                      SizedBox(width: 8),
                      Text(
                        appointment.completedAt != null
                            ? '${appointment.completedAt!.day}/${appointment.completedAt!.month}/${appointment.completedAt!.year}'
                            : '',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(appointment.review ?? ''),
                  Divider(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
} 