import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/appointment_model.dart';
import 'appointment_details_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  final bool isMechanic;

  const AppointmentListScreen({Key? key, this.isMechanic = false}) : super(key: key);

  @override
  _AppointmentListScreenState createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Stream<List<AppointmentModel>> _getAppointments(List<String> statusList) {
    if (_user == null) return Stream.value([]);

    Query query = FirebaseFirestore.instance.collection('appointments');

    if (widget.isMechanic) {
      query = query.where('mechanicId', isEqualTo: _user!.uid);
    } else {
      query = query.where('userId', isEqualTo: _user!.uid);
    }

    return query
        .where('status', whereIn: statusList)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AppointmentModel.fromMap({...doc.data(), 'id': doc.id});
          }).toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Randevularım')),
        body: Center(
          child: Text('Lütfen giriş yapın'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Randevularım'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Aktif'),
            Tab(text: 'Geçmiş'),
            Tab(text: 'İptal'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aktif randevular
          _buildAppointmentList([
            AppointmentStatus.pending,
            AppointmentStatus.confirmed,
            AppointmentStatus.inProgress,
          ]),
          // Geçmiş randevular
          _buildAppointmentList([
            AppointmentStatus.completed,
          ]),
          // İptal edilen randevular
          _buildAppointmentList([
            AppointmentStatus.cancelled,
            AppointmentStatus.rejected,
          ]),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(List<String> statusList) {
    return StreamBuilder<List<AppointmentModel>>(
      stream: _getAppointments(statusList),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Bir hata oluştu: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data!;

        if (appointments.isEmpty) {
          return Center(
            child: Text('Randevu bulunamadı'),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return _buildAppointmentCard(appointment);
          },
        );
      },
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    Color statusColor;
    String statusText;

    switch (appointment.status) {
      case AppointmentStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Onay Bekliyor';
        break;
      case AppointmentStatus.confirmed:
        statusColor = Colors.blue;
        statusText = 'Onaylandı';
        break;
      case AppointmentStatus.inProgress:
        statusColor = Colors.purple;
        statusText = 'İşlemde';
        break;
      case AppointmentStatus.completed:
        statusColor = Colors.green;
        statusText = 'Tamamlandı';
        break;
      case AppointmentStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'İptal Edildi';
        break;
      case AppointmentStatus.rejected:
        statusColor = Colors.red;
        statusText = 'Reddedildi';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Bilinmiyor';
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentDetailsScreen(
                appointmentId: appointment.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${appointment.date.day}/${appointment.date.month}/${appointment.date.year}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Saat: ${appointment.timeSlot}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                'Hizmetler: ${appointment.services.join(", ")}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              if (appointment.estimatedCost != null) ...[
                SizedBox(height: 4),
                Text(
                  'Tahmini Ücret: ${appointment.estimatedCost!.toStringAsFixed(2)} TL',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
              if (appointment.finalCost != null) ...[
                SizedBox(height: 4),
                Text(
                  'Final Ücret: ${appointment.finalCost!.toStringAsFixed(2)} TL',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
              SizedBox(height: 8),
              Text(
                appointment.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 