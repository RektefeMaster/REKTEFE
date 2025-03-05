import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/review_model.dart';
import 'package:uuid/uuid.dart';

class CreateReviewScreen extends StatefulWidget {
  final String targetId;
  final String targetType;
  final String? referenceId;
  final bool isVerified;

  const CreateReviewScreen({
    Key? key,
    required this.targetId,
    required this.targetType,
    this.referenceId,
    this.isVerified = false,
  }) : super(key: key);

  @override
  _CreateReviewScreenState createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final _commentController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _uuid = Uuid();
  double _rating = 5.0;
  List<File> _selectedPhotos = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    final pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedPhotos.addAll(pickedFiles.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<List<String>> _uploadPhotos(String reviewId) async {
    final urls = <String>[];
    
    for (var i = 0; i < _selectedPhotos.length; i++) {
      final file = _selectedPhotos[i];
      final ref = FirebaseStorage.instance
          .ref()
          .child('review_photos')
          .child(reviewId)
          .child('photo_$i.jpg');

      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  Future<void> _submitReview() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir yorum yazın')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Kullanıcı oturumu bulunamadı');

      final reviewId = _uuid.v4();
      final photoUrls = await _uploadPhotos(reviewId);

      final review = ReviewModel(
        id: reviewId,
        userId: user.uid,
        userName: user.displayName ?? 'İsimsiz Kullanıcı',
        userPhotoUrl: user.photoURL,
        targetId: widget.targetId,
        targetType: widget.targetType,
        rating: _rating,
        comment: _commentController.text,
        photos: photoUrls,
        createdAt: DateTime.now(),
        isVerified: widget.isVerified,
        referenceId: widget.referenceId,
      );

      await ReviewService.addReview(review);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Değerlendirmeniz başarıyla kaydedildi')),
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
        title: Text('Değerlendirme Yap'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Puanınız',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 24),
            Text(
              'Yorumunuz',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Deneyiminizi paylaşın...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 24),
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
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitReview,
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text('Değerlendirmeyi Gönder'),
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