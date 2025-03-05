import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String reviewId;
  final String reporterId;
  final String reporterName;
  final String reason;
  final String? description;
  final DateTime createdAt;
  final String status; // 'pending', 'accepted', 'rejected'
  final String? moderatorNote;
  final DateTime? resolvedAt;

  ReportModel({
    required this.id,
    required this.reviewId,
    required this.reporterId,
    required this.reporterName,
    required this.reason,
    this.description,
    required this.createdAt,
    this.status = 'pending',
    this.moderatorNote,
    this.resolvedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reviewId': reviewId,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'reason': reason,
      'description': description,
      'createdAt': createdAt,
      'status': status,
      'moderatorNote': moderatorNote,
      'resolvedAt': resolvedAt,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] ?? '',
      reviewId: map['reviewId'] ?? '',
      reporterId: map['reporterId'] ?? '',
      reporterName: map['reporterName'] ?? '',
      reason: map['reason'] ?? '',
      description: map['description'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
      moderatorNote: map['moderatorNote'],
      resolvedAt: map['resolvedAt'] != null 
          ? (map['resolvedAt'] as Timestamp).toDate() 
          : null,
    );
  }
}

class ReportService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> createReport(ReportModel report) async {
    await _firestore.collection('reports').doc(report.id).set(report.toMap());
  }

  static Future<void> updateReportStatus({
    required String reportId,
    required String status,
    String? moderatorNote,
  }) async {
    await _firestore.collection('reports').doc(reportId).update({
      'status': status,
      'moderatorNote': moderatorNote,
      'resolvedAt': DateTime.now(),
    });

    if (status == 'accepted') {
      final report = await _firestore.collection('reports').doc(reportId).get();
      final reviewId = report.data()?['reviewId'];
      
      if (reviewId != null) {
        await ReviewService.deleteReview(reviewId);
      }
    }
  }

  static Stream<List<ReportModel>> getReports({
    String? status,
    int limit = 20,
  }) {
    Query query = _firestore.collection('reports')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ReportModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  static Stream<List<ReportModel>> getUserReports(String userId) {
    return _firestore.collection('reports')
        .where('reporterId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ReportModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }
} 