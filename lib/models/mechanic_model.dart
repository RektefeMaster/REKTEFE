import 'package:cloud_firestore/cloud_firestore.dart';

class MechanicModel {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final String address;
  final List<String> specialties;
  final Map<String, List<String>> expertiseByBrand;
  final Map<String, List<String>> workingHours;
  final List<String> services;
  final String about;
  final double rating;
  final int completedJobs;
  final int activeJobs;
  final bool isAvailable;
  final GeoPoint? location;
  final DateTime? lastActive;
  final String status;

  MechanicModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.address,
    required this.specialties,
    required this.expertiseByBrand,
    required this.workingHours,
    required this.services,
    required this.about,
    this.rating = 0.0,
    this.completedJobs = 0,
    this.activeJobs = 0,
    this.isAvailable = true,
    this.location,
    this.lastActive,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'address': address,
      'specialties': specialties,
      'expertiseByBrand': expertiseByBrand,
      'workingHours': workingHours,
      'services': services,
      'about': about,
      'rating': rating,
      'completedJobs': completedJobs,
      'activeJobs': activeJobs,
      'isAvailable': isAvailable,
      'location': location,
      'lastActive': lastActive,
      'status': status,
    };
  }

  factory MechanicModel.fromMap(Map<String, dynamic> map) {
    return MechanicModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      address: map['address'] ?? '',
      specialties: List<String>.from(map['specialties'] ?? []),
      expertiseByBrand: Map<String, List<String>>.from(
        (map['expertiseByBrand'] ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      ),
      workingHours: Map<String, List<String>>.from(
        (map['workingHours'] ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      ),
      services: List<String>.from(map['services'] ?? []),
      about: map['about'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      completedJobs: map['completedJobs'] ?? 0,
      activeJobs: map['activeJobs'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
      location: map['location'],
      lastActive: map['lastActive']?.toDate(),
      status: map['status'] ?? 'pending',
    );
  }

  MechanicModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? address,
    List<String>? specialties,
    Map<String, List<String>>? expertiseByBrand,
    Map<String, List<String>>? workingHours,
    List<String>? services,
    String? about,
    double? rating,
    int? completedJobs,
    int? activeJobs,
    bool? isAvailable,
    GeoPoint? location,
    DateTime? lastActive,
    String? status,
  }) {
    return MechanicModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      address: address ?? this.address,
      specialties: specialties ?? this.specialties,
      expertiseByBrand: expertiseByBrand ?? this.expertiseByBrand,
      workingHours: workingHours ?? this.workingHours,
      services: services ?? this.services,
      about: about ?? this.about,
      rating: rating ?? this.rating,
      completedJobs: completedJobs ?? this.completedJobs,
      activeJobs: activeJobs ?? this.activeJobs,
      isAvailable: isAvailable ?? this.isAvailable,
      location: location ?? this.location,
      lastActive: lastActive ?? this.lastActive,
      status: status ?? this.status,
    );
  }
}

// Usta uzmanlık alanları için sabit veriler
class MechanicSpecialties {
  static const List<String> specialties = [
    'Motor',
    'Şanzıman',
    'Fren Sistemi',
    'Süspansiyon',
    'Elektrik',
    'Klima',
    'Kaporta',
    'Boya',
    'Lastik',
    'Egzoz',
    'Diagnostik',
    'Periyodik Bakım',
  ];

  static const List<String> services = [
    'Yerinde Servis',
    'Çekici Hizmeti',
    'Acil Servis',
    'Randevulu Servis',
    'Parça Tedarik',
    'Ekspertiz',
    'Sigorta İşlemleri',
  ];

  static final Map<String, List<String>> workingHours = {
    'Pazartesi': ['09:00', '18:00'],
    'Salı': ['09:00', '18:00'],
    'Çarşamba': ['09:00', '18:00'],
    'Perşembe': ['09:00', '18:00'],
    'Cuma': ['09:00', '18:00'],
    'Cumartesi': ['09:00', '14:00'],
    'Pazar': [], // Kapalı
  };
} 