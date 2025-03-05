import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/comment_model.dart';
import 'comment_screen.dart';

class CommentListScreen extends StatelessWidget {
  final String reviewId;

  const CommentListScreen({
    Key? key,
    required this.reviewId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yorumlar'),
      ),
      body: StreamBuilder<List<CommentModel>>(
        stream: CommentService.getComments(reviewId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Bir hata oluştu: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final comments = snapshot.data!;
          if (comments.isEmpty) {
            return Center(
              child: Text('Henüz yorum yapılmamış'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return _CommentCard(
                comment: comment,
                onReply: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        reviewId: reviewId,
                        parentCommentId: comment.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommentScreen(reviewId: reviewId),
            ),
          );
        },
        child: Icon(Icons.add_comment),
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback onReply;

  const _CommentCard({
    Key? key,
    required this.comment,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: comment.userPhotoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(comment.userPhotoUrl!),
                  )
                : CircleAvatar(
                    child: Text(comment.userName[0]),
                  ),
            title: Text(comment.userName),
            subtitle: Text(
              '${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year}',
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user?.uid == comment.userId) {
                    await CommentService.deleteComment(comment.id);
                  }
                }
              },
              itemBuilder: (context) {
                final user = FirebaseAuth.instance.currentUser;
                final items = <PopupMenuEntry<String>>[];

                items.add(
                  PopupMenuItem(
                    value: 'reply',
                    child: Row(
                      children: [
                        Icon(Icons.reply, size: 20),
                        SizedBox(width: 8),
                        Text('Yanıtla'),
                      ],
                    ),
                  ),
                );

                if (user?.uid == comment.userId) {
                  items.add(
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
                  );
                }

                return items;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.text),
                if (comment.photos != null && comment.photos!.isNotEmpty) ...[
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: comment.photos!.map((url) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Fotoğrafı tam ekran göster
                            },
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
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                SizedBox(height: 8),
                Row(
                  children: [
                    StreamBuilder<bool>(
                      stream: Stream.fromFuture(
                        CommentService.isLiked(
                          commentId: comment.id,
                          userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                        ),
                      ),
                      builder: (context, snapshot) {
                        final isLiked = snapshot.data ?? false;
                        return IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : null,
                          ),
                          onPressed: () {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Lütfen giriş yapın')),
                              );
                              return;
                            }
                            CommentService.toggleLike(
                              commentId: comment.id,
                              userId: user.uid,
                            );
                          },
                        );
                      },
                    ),
                    Text(
                      comment.likeCount.toString(),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 16),
                    TextButton.icon(
                      icon: Icon(Icons.reply),
                      label: Text('Yanıtla'),
                      onPressed: onReply,
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder<List<CommentModel>>(
            stream: CommentService.getReplies(comment.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SizedBox();
              }

              final replies = snapshot.data!;
              return Container(
                margin: EdgeInsets.only(left: 32),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  itemCount: replies.length,
                  itemBuilder: (context, index) {
                    final reply = replies[index];
                    return _CommentCard(
                      comment: reply,
                      onReply: onReply,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 