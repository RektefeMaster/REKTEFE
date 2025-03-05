import 'package:cloud_firestore/cloud_firestore.dart';

class TefeCoinModel {
  final String id;
  final String userId;
  final double amount;
  final String type;
  final String? referenceId;
  final String? description;
  final DateTime createdAt;

  TefeCoinModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.referenceId,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type,
      'referenceId': referenceId,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory TefeCoinModel.fromMap(Map<String, dynamic> map) {
    return TefeCoinModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      type: map['type'] ?? '',
      referenceId: map['referenceId'],
      description: map['description'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  TefeCoinModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? type,
    String? referenceId,
    String? description,
    DateTime? createdAt,
  }) {
    return TefeCoinModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TefeCoinType {
  static const String credit = 'credit'; // Bakiye yükleme
  static const String debit = 'debit'; // Bakiye kullanma
  static const String reward = 'reward'; // Ödül kazanma
  static const String refund = 'refund'; // İade
  static const String transfer = 'transfer'; // Transfer
}

class TefeCoinService {
  static final _firestore = FirebaseFirestore.instance;

  // Kullanıcının bakiyesini getir
  static Future<double> getBalance(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return (doc.data()?['tefeCoins'] ?? 0.0).toDouble();
  }

  // Bakiye güncelle
  static Future<void> updateBalance(String userId, double amount) async {
    await _firestore.collection('users').doc(userId).update({
      'tefeCoins': FieldValue.increment(amount),
    });
  }

  // İşlem kaydı oluştur
  static Future<void> createTransaction({
    required String userId,
    required double amount,
    required String type,
    String? referenceId,
    String? description,
  }) async {
    final transaction = TefeCoinModel(
      id: _firestore.collection('tefe_coin_transactions').doc().id,
      userId: userId,
      amount: amount,
      type: type,
      referenceId: referenceId,
      description: description,
      createdAt: DateTime.now(),
    );

    await Future.wait([
      _firestore
          .collection('tefe_coin_transactions')
          .doc(transaction.id)
          .set(transaction.toMap()),
      updateBalance(userId, amount),
    ]);
  }

  // Bakiye yükle
  static Future<void> addCredit(String userId, double amount) async {
    await createTransaction(
      userId: userId,
      amount: amount,
      type: TefeCoinType.credit,
      description: 'Bakiye yükleme',
    );
  }

  // Bakiye kullan
  static Future<void> debit(String userId, double amount, {String? referenceId, String? description}) async {
    final balance = await getBalance(userId);
    if (balance < amount) {
      throw Exception('Yetersiz bakiye');
    }

    await createTransaction(
      userId: userId,
      amount: -amount,
      type: TefeCoinType.debit,
      referenceId: referenceId,
      description: description,
    );
  }

  // İade yap
  static Future<void> refund(String userId, double amount, String referenceId) async {
    await createTransaction(
      userId: userId,
      amount: amount,
      type: TefeCoinType.refund,
      referenceId: referenceId,
      description: 'İade işlemi',
    );
  }

  // Ödül ver
  static Future<void> reward(String userId, double amount, String description) async {
    await createTransaction(
      userId: userId,
      amount: amount,
      type: TefeCoinType.reward,
      description: description,
    );
  }

  // Transfer yap
  static Future<void> transfer(String fromUserId, String toUserId, double amount, String description) async {
    final batch = _firestore.batch();
    final transactionId = _firestore.collection('tefe_coin_transactions').doc().id;

    // Gönderen için işlem
    final fromTransaction = TefeCoinModel(
      id: '${transactionId}_from',
      userId: fromUserId,
      amount: -amount,
      type: TefeCoinType.transfer,
      referenceId: transactionId,
      description: 'Transfer: $description',
      createdAt: DateTime.now(),
    );

    // Alan için işlem
    final toTransaction = TefeCoinModel(
      id: '${transactionId}_to',
      userId: toUserId,
      amount: amount,
      type: TefeCoinType.transfer,
      referenceId: transactionId,
      description: 'Transfer alındı: $description',
      createdAt: DateTime.now(),
    );

    batch.set(
      _firestore.collection('tefe_coin_transactions').doc(fromTransaction.id),
      fromTransaction.toMap(),
    );

    batch.set(
      _firestore.collection('tefe_coin_transactions').doc(toTransaction.id),
      toTransaction.toMap(),
    );

    batch.update(
      _firestore.collection('users').doc(fromUserId),
      {'tefeCoins': FieldValue.increment(-amount)},
    );

    batch.update(
      _firestore.collection('users').doc(toUserId),
      {'tefeCoins': FieldValue.increment(amount)},
    );

    await batch.commit();
  }

  // İşlem geçmişini getir
  static Stream<List<TefeCoinModel>> getTransactionHistory(String userId) {
    return _firestore
        .collection('tefe_coin_transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TefeCoinModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }
} 