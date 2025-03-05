import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/review_model.dart';
import '../../models/review_like_model.dart';
import 'photo_view_screen.dart';
import 'report_review_screen.dart';

class ReviewListScreen extends StatefulWidget {
  final String targetId;
  final String targetType;
  final bool onlyVerified;

  const ReviewListScreen({
    Key? key,
    required this.targetId,
    required this.targetType,
    this.onlyVerified = false,
  }) : super(key: key);

  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  List<ReviewModel> _reviews = [];
  DocumentSnapshot? _lastDocument;
  final int _limit = 20;

  String _sortBy = 'date'; // 'date', 'rating', 'likes'
  bool _sortDesc = true;
  double? _ratingFilter; // null = tümü, 1-5 arası
  bool _withPhotos = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMore) {
        _loadReviews();
      }
    }
  }

  Future<void> _loadReviews() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Query query = FirebaseFirestore.instance.collection('reviews')
          .where('targetId', isEqualTo: widget.targetId)
          .where('targetType', isEqualTo: widget.targetType);

      if (widget.onlyVerified) {
        query = query.where('isVerified', isEqualTo: true);
      }

      if (_ratingFilter != null) {
        query = query.where('rating', isEqualTo: _ratingFilter);
      }

      if (_withPhotos) {
        query = query.where('hasPhotos', isEqualTo: true);
      }

      switch (_sortBy) {
        case 'date':
          query = query.orderBy('createdAt', descending: _sortDesc);
          break;
        case 'rating':
          query = query.orderBy('rating', descending: _sortDesc)
              .orderBy('createdAt', descending: true);
          break;
        case 'likes':
          query = query.orderBy('likeCount', descending: _sortDesc)
              .orderBy('createdAt', descending: true);
          break;
      }

      query = query.limit(_limit);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      final reviews = snapshot.docs.map((doc) {
        return ReviewModel.fromMap({...doc.data(), 'id': doc.id});
      }).toList();

      setState(() {
        _reviews.addAll(reviews);
        _lastDocument = snapshot.docs.last;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  void _resetList() {
    setState(() {
      _reviews = [];
      _lastDocument = null;
      _hasMore = true;
    });
    _loadReviews();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Filtreleme ve Sıralama'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sıralama',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: Text('Tarihe Göre'),
                    leading: Radio<String>(
                      value: 'date',
                      groupValue: _sortBy,
                      onChanged: (value) {
                        setDialogState(() {
                          _sortBy = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Puana Göre'),
                    leading: Radio<String>(
                      value: 'rating',
                      groupValue: _sortBy,
                      onChanged: (value) {
                        setDialogState(() {
                          _sortBy = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Beğeniye Göre'),
                    leading: Radio<String>(
                      value: 'likes',
                      groupValue: _sortBy,
                      onChanged: (value) {
                        setDialogState(() {
                          _sortBy = value!;
                        });
                      },
                    ),
                  ),
                  SwitchListTile(
                    title: Text('Azalan Sıralama'),
                    value: _sortDesc,
                    onChanged: (value) {
                      setDialogState(() {
                        _sortDesc = value;
                      });
                    },
                  ),
                  Divider(),
                  Text(
                    'Filtreler',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButtonFormField<double?>(
                    value: _ratingFilter,
                    decoration: InputDecoration(
                      labelText: 'Puan Filtresi',
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Tümü'),
                      ),
                      ...List.generate(5, (index) {
                        final rating = index + 1.0;
                        return DropdownMenuItem(
                          value: rating,
                          child: Row(
                            children: [
                              Text('$rating'),
                              Icon(Icons.star, size: 16, color: Colors.amber),
                            ],
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        _ratingFilter = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text('Sadece Fotoğraflılar'),
                    value: _withPhotos,
                    onChanged: (value) {
                      setDialogState(() {
                        _withPhotos = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _resetList();
                  },
                  child: Text('Uygula'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Değerlendirmeler'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _reviews.isEmpty && !_isLoading
          ? Center(
              child: Text('Henüz değerlendirme yapılmamış'),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _resetList();
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: _reviews.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _reviews.length) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final review = _reviews[index];
                  return _buildReviewCard(review);
                },
              ),
            ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (review.userPhotoUrl != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(review.userPhotoUrl!),
                    radius: 20,
                  )
                else
                  CircleAvatar(
                    child: Text(review.userName[0]),
                    radius: 20,
                  ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (review.isVerified)
                  Tooltip(
                    message: 'Doğrulanmış Değerlendirme',
                    child: Icon(Icons.verified, color: Colors.blue),
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'report') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportReviewScreen(
                            reviewId: review.id,
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'report',
                      child: Row(
                        children: [
                          Icon(Icons.flag_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('Raporla'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
                SizedBox(width: 8),
                Text(
                  review.rating.toString(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if (review.comment != null) ...[
              SizedBox(height: 12),
              Text(review.comment!),
            ],
            if (review.photos != null && review.photos!.isNotEmpty) ...[
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: review.photos!.map((url) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoViewScreen(
                                photoUrls: review.photos!,
                                initialIndex: review.photos!.indexOf(url),
                              ),
                            ),
                          );
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
            SizedBox(height: 12),
            Row(
              children: [
                StreamBuilder<bool>(
                  stream: Stream.fromFuture(
                    ReviewLikeService.isLiked(
                      reviewId: review.id,
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
                        ReviewLikeService.toggleLike(
                          reviewId: review.id,
                          userId: user.uid,
                          userName: user.displayName ?? 'İsimsiz Kullanıcı',
                        );
                      },
                    );
                  },
                ),
                StreamBuilder<int>(
                  stream: ReviewLikeService.getLikeCount(review.id),
                  builder: (context, snapshot) {
                    final likeCount = snapshot.data ?? 0;
                    return Text(
                      likeCount.toString(),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 