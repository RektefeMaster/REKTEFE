import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String userId;
  final String mechanicId;
  final String carId;
  final DateTime date;
  final String timeSlot;
  final String status;
  final String description;
  final List<String> services;
  final List<String> photos;
  final double? estimatedCost;
  final double? finalCost;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? cancelReason;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? review;
  final double? rating;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.mechanicId,
    required this.carId,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.description,
    required this.services,
    required this.photos,
    this.estimatedCost,
    this.finalCost,
    this.paymentStatus,
    this.paymentMethod,
    this.cancelReason,
    required this.createdAt,
    this.completedAt,
    this.review,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'mechanicId': mechanicId,
      'carId': carId,
      'date': date,
      'timeSlot': timeSlot,
      'status': status,
      'description': description,
      'services': services,
      'photos': photos,
      'estimatedCost': estimatedCost,
      'finalCost': finalCost,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'cancelReason': cancelReason,
      'createdAt': createdAt,
      'completedAt': completedAt,
      'review': review,
      'rating': rating,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      mechanicId: map['mechanicId'] ?? '',
      carId: map['carId'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      timeSlot: map['timeSlot'] ?? '',
      status: map['status'] ?? '',
      description: map['description'] ?? '',
      services: List<String>.from(map['services'] ?? []),
      photos: List<String>.from(map['photos'] ?? []),
      estimatedCost: map['estimatedCost']?.toDouble(),
      finalCost: map['finalCost']?.toDouble(),
      paymentStatus: map['paymentStatus'],
      paymentMethod: map['paymentMethod'],
      cancelReason: map['cancelReason'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
      review: map['review'],
      rating: map['rating']?.toDouble(),
    );
  }

  AppointmentModel copyWith({
    String? id,
    String? userId,
    String? mechanicId,
    String? carId,
    DateTime? date,
    String? timeSlot,
    String? status,
    String? description,
    List<String>? services,
    List<String>? photos,
    double? estimatedCost,
    double? finalCost,
    String? paymentStatus,
    String? paymentMethod,
    String? cancelReason,
    DateTime? createdAt,
    DateTime? completedAt,
    String? review,
    double? rating,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mechanicId: mechanicId ?? this.mechanicId,
      carId: carId ?? this.carId,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      description: description ?? this.description,
      services: services ?? this.services,
      photos: photos ?? this.photos,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      finalCost: finalCost ?? this.finalCost,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cancelReason: cancelReason ?? this.cancelReason,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      review: review ?? this.review,
      rating: rating ?? this.rating,
    );
  }
}

class AppointmentStatus {
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
  static const String rejected = 'rejected';
}

class PaymentStatus {
  static const String pending = 'pending';
  static const String paid = 'paid';
  static const String refunded = 'refunded';
  static const String failed = 'failed';
}

class PaymentMethod {
  static const String cash = 'cash';
  static const String creditCard = 'credit_card';
  static const String tefeCoins = 'tefe_coins';
  static const String transfer = 'transfer';
} 