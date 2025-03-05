import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  final String id;
  final String userId;
  final String type; // 'mechanic' veya 'user'
  final GeoPoint location;
  final String address;
  final bool isAvailable;
  final DateTime lastUpdated;

  LocationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.location,
    required this.address,
    this.isAvailable = true,
    required this.lastUpdated,
  });

  LatLng get latLng => LatLng(location.latitude, location.longitude);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'location': location,
      'address': address,
      'isAvailable': isAvailable,
      'lastUpdated': lastUpdated,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      location: map['location'] ?? GeoPoint(0, 0),
      address: map['address'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }

  LocationModel copyWith({
    String? id,
    String? userId,
    String? type,
    GeoPoint? location,
    String? address,
    bool? isAvailable,
    DateTime? lastUpdated,
  }) {
    return LocationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      location: location ?? this.location,
      address: address ?? this.address,
      isAvailable: isAvailable ?? this.isAvailable,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class LocationType {
  static const String mechanic = 'mechanic';
  static const String user = 'user';
} 