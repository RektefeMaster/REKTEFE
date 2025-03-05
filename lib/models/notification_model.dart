import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'comment', 'like', 'reply', 'review'
  final String targetId; // reviewId veya commentId
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.targetId,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'targetId': targetId,
      'createdAt': createdAt,
      'isRead': isRead,
      'data': data,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? '',
      targetId: map['targetId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
      data: map['data'],
    );
  }
}

class NotificationService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    required String targetId,
    Map<String, dynamic>? data,
  }) async {
    final notificationRef = _firestore.collection('notifications').doc();
    final notification = NotificationModel(
      id: notificationRef.id,
      userId: userId,
      title: title,
      message: message,
      type: type,
      targetId: targetId,
      createdAt: DateTime.now(),
      data: data,
    );

    await notificationRef.set(notification.toMap());
  }

  static Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }

  static Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final notifications = await _firestore.collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in notifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  static Future<void> deleteNotification(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).delete();
  }

  static Stream<List<NotificationModel>> getNotifications(String userId) {
    return _firestore.collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => NotificationModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  static Stream<int> getUnreadCount(String userId) {
    return _firestore.collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
} 