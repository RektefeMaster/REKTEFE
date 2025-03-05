import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String reviewId;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String text;
  final DateTime createdAt;
  final int likeCount;
  final List<String>? photos;
  final String? parentCommentId;
  final bool isEdited;

  CommentModel({
    required this.id,
    required this.reviewId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.text,
    required this.createdAt,
    this.likeCount = 0,
    this.photos,
    this.parentCommentId,
    this.isEdited = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reviewId': reviewId,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'text': text,
      'createdAt': createdAt,
      'likeCount': likeCount,
      'photos': photos,
      'parentCommentId': parentCommentId,
      'isEdited': isEdited,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      reviewId: map['reviewId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhotoUrl: map['userPhotoUrl'],
      text: map['text'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likeCount: map['likeCount'] ?? 0,
      photos: map['photos'] != null ? List<String>.from(map['photos']) : null,
      parentCommentId: map['parentCommentId'],
      isEdited: map['isEdited'] ?? false,
    );
  }

  CommentModel copyWith({
    String? id,
    String? reviewId,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? text,
    DateTime? createdAt,
    int? likeCount,
    List<String>? photos,
    String? parentCommentId,
    bool? isEdited,
  }) {
    return CommentModel(
      id: id ?? this.id,
      reviewId: reviewId ?? this.reviewId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      photos: photos ?? this.photos,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

class CommentService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> addComment({
    required String reviewId,
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String text,
    List<String>? photos,
    String? parentCommentId,
  }) async {
    final commentRef = _firestore.collection('comments').doc();
    final comment = CommentModel(
      id: commentRef.id,
      reviewId: reviewId,
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      text: text,
      createdAt: DateTime.now(),
      photos: photos,
      parentCommentId: parentCommentId,
    );

    await commentRef.set(comment.toMap());

    // Değerlendirmenin yorum sayısını güncelle
    await _firestore.collection('reviews').doc(reviewId).update({
      'commentCount': FieldValue.increment(1),
    });
  }

  static Future<void> updateComment({
    required String commentId,
    required String text,
    List<String>? photos,
  }) async {
    await _firestore.collection('comments').doc(commentId).update({
      'text': text,
      'photos': photos,
      'isEdited': true,
    });
  }

  static Future<void> deleteComment(String commentId) async {
    final commentDoc = await _firestore.collection('comments').doc(commentId).get();
    if (!commentDoc.exists) return;

    final comment = CommentModel.fromMap({...commentDoc.data()!, 'id': commentDoc.id});
    
    // Alt yorumları sil
    final childComments = await _firestore.collection('comments')
        .where('parentCommentId', isEqualTo: commentId)
        .get();
    
    final batch = _firestore.batch();
    
    // Ana yorumu sil
    batch.delete(commentDoc.reference);
    
    // Alt yorumları sil
    for (var doc in childComments.docs) {
      batch.delete(doc.reference);
    }

    // Değerlendirmenin yorum sayısını güncelle
    batch.update(
      _firestore.collection('reviews').doc(comment.reviewId),
      {
        'commentCount': FieldValue.increment(-(childComments.docs.length + 1)),
      },
    );

    await batch.commit();
  }

  static Stream<List<CommentModel>> getComments(String reviewId) {
    return _firestore.collection('comments')
        .where('reviewId', isEqualTo: reviewId)
        .where('parentCommentId', isNull: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CommentModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  static Stream<List<CommentModel>> getReplies(String parentCommentId) {
    return _firestore.collection('comments')
        .where('parentCommentId', isEqualTo: parentCommentId)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CommentModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  static Future<void> toggleLike({
    required String commentId,
    required String userId,
  }) async {
    final likeRef = _firestore.collection('comment_likes')
        .doc('${commentId}_${userId}');
    final commentRef = _firestore.collection('comments').doc(commentId);

    final batch = _firestore.batch();
    final likeDoc = await likeRef.get();

    if (likeDoc.exists) {
      batch.delete(likeRef);
      batch.update(commentRef, {
        'likeCount': FieldValue.increment(-1),
      });
    } else {
      batch.set(likeRef, {
        'commentId': commentId,
        'userId': userId,
        'createdAt': DateTime.now(),
      });
      batch.update(commentRef, {
        'likeCount': FieldValue.increment(1),
      });
    }

    await batch.commit();
  }

  static Future<bool> isLiked({
    required String commentId,
    required String userId,
  }) async {
    final doc = await _firestore.collection('comment_likes')
        .doc('${commentId}_${userId}')
        .get();
    return doc.exists;
  }
} 