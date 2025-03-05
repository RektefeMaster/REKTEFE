import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/notification_model.dart';
import '../review/review_list_screen.dart';
import '../review/comment_list_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Bildirimler'),
        ),
        body: Center(
          child: Text('Lütfen giriş yapın'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler'),
        actions: [
          IconButton(
            icon: Icon(Icons.done_all),
            onPressed: () {
              NotificationService.markAllAsRead(user.uid);
            },
            tooltip: 'Tümünü Okundu İşaretle',
          ),
        ],
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: NotificationService.getNotifications(user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Bir hata oluştu: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!;
          if (notifications.isEmpty) {
            return Center(
              child: Text('Bildirim bulunmuyor'),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationCard(notification: notification);
            },
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: notification.isRead ? null : Colors.blue.shade50,
      child: InkWell(
        onTap: () {
          _handleNotificationTap(context);
          if (!notification.isRead) {
            NotificationService.markAsRead(notification.id);
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(notification.message),
                    SizedBox(height: 4),
                    Text(
                      _formatDate(notification.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    NotificationService.deleteNotification(notification.id);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20),
                        SizedBox(width: 8),
                        Text('Sil'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'comment':
        iconData = Icons.comment;
        iconColor = Colors.blue;
        break;
      case 'like':
        iconData = Icons.favorite;
        iconColor = Colors.red;
        break;
      case 'reply':
        iconData = Icons.reply;
        iconColor = Colors.green;
        break;
      case 'review':
        iconData = Icons.star;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Az önce';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} saat önce';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _handleNotificationTap(BuildContext context) {
    switch (notification.type) {
      case 'comment':
      case 'reply':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentListScreen(
              reviewId: notification.targetId,
            ),
          ),
        );
        break;
      case 'review':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewListScreen(
              targetId: notification.data?['targetId'] ?? '',
              targetType: notification.data?['targetType'] ?? '',
            ),
          ),
        );
        break;
    }
  }
} 