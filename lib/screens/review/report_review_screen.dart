import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/report_model.dart';
import 'package:uuid/uuid.dart';

class ReportReviewScreen extends StatefulWidget {
  final String reviewId;

  const ReportReviewScreen({
    Key? key,
    required this.reviewId,
  }) : super(key: key);

  @override
  _ReportReviewScreenState createState() => _ReportReviewScreenState();
}

class _ReportReviewScreenState extends State<ReportReviewScreen> {
  final _descriptionController = TextEditingController();
  final _uuid = Uuid();
  String _selectedReason = 'spam';
  bool _isLoading = false;

  final _reasons = {
    'spam': 'Spam veya Yanıltıcı İçerik',
    'inappropriate': 'Uygunsuz İçerik',
    'offensive': 'Hakaret veya Saldırgan İfade',
    'fake': 'Sahte Değerlendirme',
    'other': 'Diğer',
  };

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_selectedReason == 'other' && _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen açıklama yazın')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Kullanıcı oturumu bulunamadı');

      final report = ReportModel(
        id: _uuid.v4(),
        reviewId: widget.reviewId,
        reporterId: user.uid,
        reporterName: user.displayName ?? 'İsimsiz Kullanıcı',
        reason: _selectedReason,
        description: _descriptionController.text.isNotEmpty 
            ? _descriptionController.text 
            : null,
        createdAt: DateTime.now(),
      );

      await ReportService.createReport(report);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Raporunuz başarıyla gönderildi')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Değerlendirmeyi Raporla'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Raporlama Nedeni',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ..._reasons.entries.map((entry) {
              return RadioListTile<String>(
                title: Text(entry.value),
                value: entry.key,
                groupValue: _selectedReason,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value!;
                  });
                },
              );
            }),
            SizedBox(height: 24),
            Text(
              'Açıklama (İsteğe Bağlı)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Ek açıklama ekleyin...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReport,
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text('Raporu Gönder'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 