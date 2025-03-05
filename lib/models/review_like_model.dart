import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewLikeModel {
  final String id;
  final String reviewId;
  final String userId;
  final String userName;
  final DateTime createdAt;

  ReviewLikeModel({
    required this.id,
    required this.reviewId,
    required this.userId,
    required this.userName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reviewId': reviewId,
      'userId': userId,
      'userName': userName,
      'createdAt': createdAt,
    };
  }

  factory ReviewLikeModel.fromMap(Map<String, dynamic> map) {
    return ReviewLikeModel(
      id: map['id'] ?? '',
      reviewId: map['reviewId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}

class ReviewLikeService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> toggleLike({
    required String reviewId,
    required String userId,
    required String userName,
  }) async {
    final likeId = '${reviewId}_${userId}';
    final likeRef = _firestore.collection('review_likes').doc(likeId);
    final reviewRef = _firestore.collection('reviews').doc(reviewId);

    final batch = _firestore.batch();
    final likeDoc = await likeRef.get();

    if (likeDoc.exists) {
      // Beğeniyi kaldır
      batch.delete(likeRef);
      batch.update(reviewRef, {
        'likeCount': FieldValue.increment(-1),
      });
    } else {
      // Beğeni ekle
      final like = ReviewLikeModel(
        id: likeId,
        reviewId: reviewId,
        userId: userId,
        userName: userName,
        createdAt: DateTime.now(),
      );
      batch.set(likeRef, like.toMap());
      batch.update(reviewRef, {
        'likeCount': FieldValue.increment(1),
      });
    }

    await batch.commit();
  }

  static Future<bool> isLiked({
    required String reviewId,
    required String userId,
  }) async {
    final likeId = '${reviewId}_${userId}';
    final doc = await _firestore.collection('review_likes').doc(likeId).get();
    return doc.exists;
  }

  static Stream<List<ReviewLikeModel>> getLikes(String reviewId) {
    return _firestore.collection('review_likes')
        .where('reviewId', isEqualTo: reviewId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ReviewLikeModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  static Stream<int> getLikeCount(String reviewId) {
    return _firestore.collection('reviews')
        .doc(reviewId)
        .snapshots()
        .map((doc) => doc.data()?['likeCount'] ?? 0);
  }
} 