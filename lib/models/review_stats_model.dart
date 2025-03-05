import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewStats {
  final String targetId;
  final String targetType;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // 1-5 yıldız dağılımı
  final int verifiedReviews;
  final int photosCount;
  final int totalLikes;
  final DateTime lastUpdated;

  ReviewStats({
    required this.targetId,
    required this.targetType,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.verifiedReviews,
    required this.photosCount,
    required this.totalLikes,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'targetId': targetId,
      'targetType': targetType,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
      'ratingDistribution': ratingDistribution,
      'verifiedReviews': verifiedReviews,
      'photosCount': photosCount,
      'totalLikes': totalLikes,
      'lastUpdated': lastUpdated,
    };
  }

  factory ReviewStats.fromMap(Map<String, dynamic> map) {
    return ReviewStats(
      targetId: map['targetId'] ?? '',
      targetType: map['targetType'] ?? '',
      averageRating: (map['averageRating'] ?? 0.0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      ratingDistribution: Map<int, int>.from(map['ratingDistribution'] ?? {}),
      verifiedReviews: map['verifiedReviews'] ?? 0,
      photosCount: map['photosCount'] ?? 0,
      totalLikes: map['totalLikes'] ?? 0,
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }
}

class ReviewStatsService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> updateStats({
    required String targetId,
    required String targetType,
  }) async {
    final reviewsRef = _firestore.collection('reviews');
    final likesRef = _firestore.collection('review_likes');

    // Tüm değerlendirmeleri getir
    final reviewsSnapshot = await reviewsRef
        .where('targetId', isEqualTo: targetId)
        .where('targetType', isEqualTo: targetType)
        .get();

    if (reviewsSnapshot.docs.isEmpty) {
      await _firestore.collection('review_stats').doc('${targetType}_$targetId').delete();
      return;
    }

    // İstatistikleri hesapla
    int totalReviews = reviewsSnapshot.docs.length;
    int verifiedReviews = 0;
    int photosCount = 0;
    double totalRating = 0;
    Map<int, int> ratingDistribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    int totalLikes = 0;

    for (var doc in reviewsSnapshot.docs) {
      final data = doc.data();
      final rating = (data['rating'] as num).toInt();
      
      totalRating += rating;
      ratingDistribution[rating] = (ratingDistribution[rating] ?? 0) + 1;
      
      if (data['isVerified'] == true) verifiedReviews++;
      if (data['photos'] != null) {
        photosCount += (data['photos'] as List).length;
      }
      if (data['likeCount'] != null) {
        totalLikes += data['likeCount'] as int;
      }
    }

    final stats = ReviewStats(
      targetId: targetId,
      targetType: targetType,
      averageRating: totalRating / totalReviews,
      totalReviews: totalReviews,
      ratingDistribution: ratingDistribution,
      verifiedReviews: verifiedReviews,
      photosCount: photosCount,
      totalLikes: totalLikes,
      lastUpdated: DateTime.now(),
    );

    await _firestore.collection('review_stats')
        .doc('${targetType}_$targetId')
        .set(stats.toMap());
  }

  static Stream<ReviewStats?> getStats({
    required String targetId,
    required String targetType,
  }) {
    return _firestore.collection('review_stats')
        .doc('${targetType}_$targetId')
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return ReviewStats.fromMap(doc.data()!);
        });
  }

  static Future<Map<String, dynamic>> getMonthlyStats({
    required String targetId,
    required String targetType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final reviewsSnapshot = await _firestore.collection('reviews')
        .where('targetId', isEqualTo: targetId)
        .where('targetType', isEqualTo: targetType)
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThan: endDate)
        .get();

    Map<String, int> reviewsByDay = {};
    Map<String, double> ratingsByDay = {};
    int totalReviews = 0;
    double totalRating = 0;

    for (var doc in reviewsSnapshot.docs) {
      final data = doc.data();
      final date = (data['createdAt'] as Timestamp).toDate();
      final dateKey = '${date.year}-${date.month}-${date.day}';
      final rating = (data['rating'] as num).toDouble();

      reviewsByDay[dateKey] = (reviewsByDay[dateKey] ?? 0) + 1;
      ratingsByDay[dateKey] = ((ratingsByDay[dateKey] ?? 0) + rating);
      
      totalReviews++;
      totalRating += rating;
    }

    // Günlük ortalama puanları hesapla
    ratingsByDay.forEach((key, value) {
      ratingsByDay[key] = value / (reviewsByDay[key] ?? 1);
    });

    return {
      'reviewsByDay': reviewsByDay,
      'ratingsByDay': ratingsByDay,
      'totalReviews': totalReviews,
      'averageRating': totalReviews > 0 ? totalRating / totalReviews : 0,
    };
  }
} 