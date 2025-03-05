import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String targetId; // Değerlendirilen şeyin ID'si (usta, parça vb.)
  final String targetType; // 'mechanic', 'spare_part' gibi
  final double rating;
  final String? comment;
  final List<String>? photos;
  final DateTime createdAt;
  final bool isVerified; // Satın alma veya randevu sonrası yapılan bir değerlendirme mi?
  final String? referenceId; // Randevu veya satın alma ID'si

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.targetId,
    required this.targetType,
    required this.rating,
    this.comment,
    this.photos,
    required this.createdAt,
    this.isVerified = false,
    this.referenceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'targetId': targetId,
      'targetType': targetType,
      'rating': rating,
      'comment': comment,
      'photos': photos,
      'createdAt': createdAt,
      'isVerified': isVerified,
      'referenceId': referenceId,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhotoUrl: map['userPhotoUrl'],
      targetId: map['targetId'] ?? '',
      targetType: map['targetType'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'],
      photos: map['photos'] != null ? List<String>.from(map['photos']) : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isVerified: map['isVerified'] ?? false,
      referenceId: map['referenceId'],
    );
  }

  ReviewModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? targetId,
    String? targetType,
    double? rating,
    String? comment,
    List<String>? photos,
    DateTime? createdAt,
    bool? isVerified,
    String? referenceId,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      referenceId: referenceId ?? this.referenceId,
    );
  }
}

class ReviewService {
  static final _firestore = FirebaseFirestore.instance;

  // Yeni değerlendirme ekle
  static Future<void> addReview(ReviewModel review) async {
    final batch = _firestore.batch();

    // Değerlendirmeyi kaydet
    batch.set(
      _firestore.collection('reviews').doc(review.id),
      review.toMap(),
    );

    // Hedefin ortalama puanını güncelle
    final targetRef = _firestore.collection(review.targetType + 's').doc(review.targetId);
    final targetDoc = await targetRef.get();

    if (targetDoc.exists) {
      final currentRating = targetDoc.data()?['rating'] ?? 0.0;
      final currentCount = targetDoc.data()?['reviewCount'] ?? 0;
      
      final newCount = currentCount + 1;
      final newRating = ((currentRating * currentCount) + review.rating) / newCount;

      batch.update(targetRef, {
        'rating': newRating,
        'reviewCount': newCount,
      });
    }

    await batch.commit();
  }

  // Değerlendirmeleri getir
  static Stream<List<ReviewModel>> getReviews({
    required String targetId,
    required String targetType,
    int limit = 10,
    bool onlyVerified = false,
  }) {
    Query query = _firestore.collection('reviews')
        .where('targetId', isEqualTo: targetId)
        .where('targetType', isEqualTo: targetType)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (onlyVerified) {
      query = query.where('isVerified', isEqualTo: true);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ReviewModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  // Kullanıcının değerlendirmelerini getir
  static Stream<List<ReviewModel>> getUserReviews(String userId) {
    return _firestore.collection('reviews')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ReviewModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  // Değerlendirme sil
  static Future<void> deleteReview(ReviewModel review) async {
    final batch = _firestore.batch();

    // Değerlendirmeyi sil
    batch.delete(
      _firestore.collection('reviews').doc(review.id),
    );

    // Hedefin ortalama puanını güncelle
    final targetRef = _firestore.collection(review.targetType + 's').doc(review.targetId);
    final targetDoc = await targetRef.get();

    if (targetDoc.exists) {
      final currentRating = targetDoc.data()?['rating'] ?? 0.0;
      final currentCount = targetDoc.data()?['reviewCount'] ?? 0;
      
      if (currentCount > 1) {
        final newCount = currentCount - 1;
        final newRating = ((currentRating * currentCount) - review.rating) / newCount;

        batch.update(targetRef, {
          'rating': newRating,
          'reviewCount': newCount,
        });
      } else {
        batch.update(targetRef, {
          'rating': null,
          'reviewCount': 0,
        });
      }
    }

    await batch.commit();
  }

  // Değerlendirme güncelle
  static Future<void> updateReview(ReviewModel oldReview, ReviewModel newReview) async {
    final batch = _firestore.batch();

    // Değerlendirmeyi güncelle
    batch.update(
      _firestore.collection('reviews').doc(newReview.id),
      newReview.toMap(),
    );

    // Hedefin ortalama puanını güncelle
    final targetRef = _firestore.collection(newReview.targetType + 's').doc(newReview.targetId);
    final targetDoc = await targetRef.get();

    if (targetDoc.exists) {
      final currentRating = targetDoc.data()?['rating'] ?? 0.0;
      final currentCount = targetDoc.data()?['reviewCount'] ?? 0;
      
      final newRating = ((currentRating * currentCount) - oldReview.rating + newReview.rating) / currentCount;

      batch.update(targetRef, {
        'rating': newRating,
      });
    }

    await batch.commit();
  }
} 