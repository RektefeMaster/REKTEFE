import 'car_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final int tefeCoins;
  final String role;
  final List<CarModel> cars;
  final DateTime createdAt;
  final Map<String, dynamic>? mechanicProfile;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl = '',
    this.tefeCoins = 0,
    this.role = 'user',
    this.cars = const [],
    required this.createdAt,
    this.mechanicProfile,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'tefe_coins': tefeCoins,
      'role': role,
      'cars': cars.map((car) => car.toMap()).toList(),
      'created_at': createdAt.toIso8601String(),
      'mechanic_profile': mechanicProfile,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      tefeCoins: map['tefe_coins']?.toInt() ?? 0,
      role: map['role'] ?? 'user',
      cars: (map['cars'] as List<dynamic>?)
              ?.map((car) => CarModel.fromMap(car as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
      mechanicProfile: map['mechanic_profile'],
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    int? tefeCoins,
    String? role,
    List<CarModel>? cars,
    DateTime? createdAt,
    Map<String, dynamic>? mechanicProfile,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      tefeCoins: tefeCoins ?? this.tefeCoins,
      role: role ?? this.role,
      cars: cars ?? this.cars,
      createdAt: createdAt ?? this.createdAt,
      mechanicProfile: mechanicProfile ?? this.mechanicProfile,
    );
  }
} 