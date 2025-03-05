import 'package:cloud_firestore/cloud_firestore.dart';

class SparePartModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String brand;
  final String model;
  final String condition; // new, used
  final String sellerId;
  final String sellerName;
  final List<String> photos;
  final Map<String, List<String>> compatibility;
  final int stock;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double? rating;
  final int reviewCount;
  final List<String>? tags;

  SparePartModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.brand,
    required this.model,
    required this.condition,
    required this.sellerId,
    required this.sellerName,
    required this.photos,
    required this.compatibility,
    required this.stock,
    this.isAvailable = true,
    required this.createdAt,
    this.updatedAt,
    this.rating,
    this.reviewCount = 0,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'brand': brand,
      'model': model,
      'condition': condition,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'photos': photos,
      'compatibility': compatibility,
      'stock': stock,
      'isAvailable': isAvailable,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
    };
  }

  factory SparePartModel.fromMap(Map<String, dynamic> map) {
    return SparePartModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      condition: map['condition'] ?? '',
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      photos: List<String>.from(map['photos'] ?? []),
      compatibility: Map<String, List<String>>.from(
        (map['compatibility'] ?? {}).map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      ),
      stock: map['stock'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      tags: map['tags'] != null ? List<String>.from(map['tags']) : null,
    );
  }

  SparePartModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? brand,
    String? model,
    String? condition,
    String? sellerId,
    String? sellerName,
    List<String>? photos,
    Map<String, List<String>>? compatibility,
    int? stock,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? rating,
    int? reviewCount,
    List<String>? tags,
  }) {
    return SparePartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      condition: condition ?? this.condition,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      photos: photos ?? this.photos,
      compatibility: compatibility ?? this.compatibility,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
    );
  }
}

class SparePartCategory {
  static const String engine = 'engine';
  static const String transmission = 'transmission';
  static const String brakes = 'brakes';
  static const String suspension = 'suspension';
  static const String electrical = 'electrical';
  static const String body = 'body';
  static const String interior = 'interior';
  static const String exhaust = 'exhaust';
  static const String cooling = 'cooling';
  static const String fuel = 'fuel';
  static const String steering = 'steering';
  static const String accessories = 'accessories';

  static String getLocalizedName(String category) {
    switch (category) {
      case engine:
        return 'Motor';
      case transmission:
        return 'Şanzıman';
      case brakes:
        return 'Fren';
      case suspension:
        return 'Süspansiyon';
      case electrical:
        return 'Elektrik';
      case body:
        return 'Kaporta';
      case interior:
        return 'İç Mekan';
      case exhaust:
        return 'Egzoz';
      case cooling:
        return 'Soğutma';
      case fuel:
        return 'Yakıt';
      case steering:
        return 'Direksiyon';
      case accessories:
        return 'Aksesuarlar';
      default:
        return 'Diğer';
    }
  }
}

class SparePartCondition {
  static const String newPart = 'new';
  static const String used = 'used';

  static String getLocalizedName(String condition) {
    switch (condition) {
      case newPart:
        return 'Yeni';
      case used:
        return 'Kullanılmış';
      default:
        return 'Bilinmiyor';
    }
  }
} 