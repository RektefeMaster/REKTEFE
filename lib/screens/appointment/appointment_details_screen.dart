import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/appointment_model.dart';
import '../../models/mechanic_model.dart';
import '../../models/car_model.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetailsScreen({Key? key, required this.appointmentId}) : super(key: key);

  @override
  _AppointmentDetailsScreenState createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  AppointmentModel? _appointment;
  MechanicModel? _mechanic;
  Map<String, dynamic>? _car;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAppointmentData();
  }

  Future<void> _loadAppointmentData() async {
    final doc = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(widget.appointmentId)
        .get();
    
    if (doc.exists) {
      setState(() {
        _appointment = AppointmentModel.fromMap({...doc.data()!, 'id': doc.id});
      });

      await Future.wait([
        _loadMechanicData(),
        _loadCarData(),
      ]);
    }
  }

  Future<void> _loadMechanicData() async {
    if (_appointment == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('mechanics')
        .doc(_appointment!.mechanicId)
        .get();
    
    if (doc.exists) {
      setState(() {
        _mechanic = MechanicModel.fromMap(doc.data()!);
      });
    }
  }

  Future<void> _loadCarData() async {
    if (_appointment == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_appointment!.userId)
        .collection('cars')
        .doc(_appointment!.carId)
        .get();
    
    if (doc.exists) {
      setState(() {
        _car = doc.data();
      });
    }
  }

  Future<void> _updateAppointmentStatus(String status) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentId)
          .update({
        'status': status,
        if (status == AppointmentStatus.completed)
          'completedAt': FieldValue.serverTimestamp(),
      });

      if (status == AppointmentStatus.completed) {
        // Ustanın tamamlanan iş sayısını güncelle
        await FirebaseFirestore.instance
            .collection('mechanics')
            .doc(_appointment!.mechanicId)
            .update({
          'completedJobs': FieldValue.increment(1),
          'activeJobs': FieldValue.increment(-1),
        });
      } else if (status == AppointmentStatus.inProgress) {
        // Ustanın aktif iş sayısını güncelle
        await FirebaseFirestore.instance
            .collection('mechanics')
            .doc(_appointment!.mechanicId)
            .update({
          'activeJobs': FieldValue.increment(1),
        });
      }

      await _loadAppointmentData();
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

  Future<void> _cancelAppointment(String reason) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentId)
          .update({
        'status': AppointmentStatus.cancelled,
        'cancelReason': reason,
      });

      await _loadAppointmentData();
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

  Future<void> _submitReview(String review, double rating) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentId)
          .update({
        'review': review,
        'rating': rating,
      });

      // Ustanın ortalama puanını güncelle
      final mechanicRef = FirebaseFirestore.instance
          .collection('mechanics')
          .doc(_appointment!.mechanicId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final mechanicDoc = await transaction.get(mechanicRef);
        if (!mechanicDoc.exists) return;

        final currentRating = mechanicDoc.data()!['rating'] ?? 0.0;
        final completedJobs = mechanicDoc.data()!['completedJobs'] ?? 0;
        
        final newRating = ((currentRating * completedJobs) + rating) / (completedJobs + 1);
        
        transaction.update(mechanicRef, {'rating': newRating});
      });

      await _loadAppointmentData();
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

  void _showReviewDialog() {
    final reviewController = TextEditingController();
    double selectedRating = 5.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Değerlendirme Yap'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < selectedRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                labelText: 'Yorumunuz',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitReview(reviewController.text, selectedRating);
            },
            child: Text('Gönder'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Randevuyu İptal Et'),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            labelText: 'İptal Nedeni',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelAppointment(reasonController.text);
            },
            child: Text('İptal Et'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_appointment == null || _mechanic == null || _car == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Randevu Detayları')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Randevu Detayları'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildStatusCard(),
          SizedBox(height: 16),
          _buildMechanicCard(),
          SizedBox(height: 16),
          _buildCarCard(),
          SizedBox(height: 16),
          _buildDetailsCard(),
          SizedBox(height: 16),
          _buildPhotosSection(),
          SizedBox(height: 16),
          if (_appointment!.status == AppointmentStatus.completed &&
              _appointment!.review == null)
            _buildReviewButton(),
          if (_appointment!.review != null)
            _buildReviewCard(),
          SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor;
    String statusText;

    switch (_appointment!.status) {
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
      default:
        statusColor = Colors.grey;
        statusText = 'Bilinmiyor';
    }

    return Card(
      child: ListTile(
        leading: Icon(Icons.info_outline, color: statusColor),
        title: Text('Durum: $statusText'),
        subtitle: _appointment!.cancelReason != null
            ? Text('İptal Nedeni: ${_appointment!.cancelReason}')
            : null,
      ),
    );
  }

  Widget _buildMechanicCard() {
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

  Widget _buildCarCard() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.directions_car),
        title: Text('${_car!['brand']} ${_car!['model']}'),
        subtitle: Text('${_car!['year']} - ${_car!['plate']}'),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Randevu Detayları',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Tarih', '${_appointment!.date.day}/${_appointment!.date.month}/${_appointment!.date.year}'),
            _buildDetailRow('Saat', _appointment!.timeSlot),
            _buildDetailRow('Hizmetler', _appointment!.services.join(', ')),
            _buildDetailRow('Açıklama', _appointment!.description),
            if (_appointment!.estimatedCost != null)
              _buildDetailRow('Tahmini Ücret', '${_appointment!.estimatedCost!.toStringAsFixed(2)} TL'),
            if (_appointment!.finalCost != null)
              _buildDetailRow('Final Ücret', '${_appointment!.finalCost!.toStringAsFixed(2)} TL'),
            if (_appointment!.paymentStatus != null)
              _buildDetailRow('Ödeme Durumu', _appointment!.paymentStatus!),
            if (_appointment!.paymentMethod != null)
              _buildDetailRow('Ödeme Yöntemi', _appointment!.paymentMethod!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection() {
    if (_appointment!.photos.isEmpty) return SizedBox();

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
            children: _appointment!.photos.map((url) {
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewButton() {
    return ElevatedButton(
      onPressed: _showReviewDialog,
      child: Text('Değerlendirme Yap'),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }

  Widget _buildReviewCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Değerlendirme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < (_appointment!.rating ?? 0)
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                );
              }),
            ),
            SizedBox(height: 8),
            Text(_appointment!.review ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return SizedBox();

    // Kullanıcı randevunun sahibi
    if (user.uid == _appointment!.userId) {
      if (_appointment!.status == AppointmentStatus.pending) {
        return ElevatedButton(
          onPressed: _showCancelDialog,
          child: Text('Randevuyu İptal Et'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: Size(double.infinity, 50),
          ),
        );
      }
      return SizedBox();
    }

    // Kullanıcı usta
    if (user.uid == _appointment!.mechanicId) {
      switch (_appointment!.status) {
        case AppointmentStatus.pending:
          return Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateAppointmentStatus(AppointmentStatus.confirmed),
                  child: Text('Onayla'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateAppointmentStatus(AppointmentStatus.rejected),
                  child: Text('Reddet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          );
        case AppointmentStatus.confirmed:
          return ElevatedButton(
            onPressed: () => _updateAppointmentStatus(AppointmentStatus.inProgress),
            child: Text('İşleme Başla'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          );
        case AppointmentStatus.inProgress:
          return ElevatedButton(
            onPressed: () => _updateAppointmentStatus(AppointmentStatus.completed),
            child: Text('İşi Tamamla'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          );
        default:
          return SizedBox();
      }
    }

    return SizedBox();
  }
} 