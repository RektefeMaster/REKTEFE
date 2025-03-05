class CarModel {
  final String brand;
  final String model;
  final String year;
  final String engineType;
  final String engineSize;
  final String transmission;
  final String fuelType;
  final String plateNumber;

  CarModel({
    required this.brand,
    required this.model,
    required this.year,
    required this.engineType,
    required this.engineSize,
    required this.transmission,
    required this.fuelType,
    required this.plateNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'year': year,
      'engineType': engineType,
      'engineSize': engineSize,
      'transmission': transmission,
      'fuelType': fuelType,
      'plateNumber': plateNumber,
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? '',
      engineType: map['engineType'] ?? '',
      engineSize: map['engineSize'] ?? '',
      transmission: map['transmission'] ?? '',
      fuelType: map['fuelType'] ?? '',
      plateNumber: map['plateNumber'] ?? '',
    );
  }
}

// Araç markaları ve modelleri için sabit veriler
class CarBrands {
  static const Map<String, List<String>> brands = {
    'BMW': [
      '116i',
      '118i',
      '320i',
      '520i',
      'X1',
      'X3',
      'X5',
    ],
    'Mercedes': [
      'A180',
      'C200',
      'E250',
      'GLA200',
      'GLC300',
      'S400',
    ],
    'Audi': [
      'A3',
      'A4',
      'A6',
      'Q3',
      'Q5',
      'Q7',
    ],
    'Volkswagen': [
      'Golf',
      'Passat',
      'Tiguan',
      'T-Roc',
      'Arteon',
      'Touareg',
    ],
    'Toyota': [
      'Corolla',
      'Yaris',
      'RAV4',
      'C-HR',
      'Camry',
      'Land Cruiser',
    ],
  };

  static const Map<String, List<String>> engineTypes = {
    'BMW': ['N20', 'B48', 'N55', 'B58', 'S55'],
    'Mercedes': ['M264', 'M256', 'OM654', 'M139'],
    'Audi': ['TFSI', 'TDI', 'FSI', 'TSI'],
    'Volkswagen': ['TSI', 'TDI', 'FSI', 'GTI'],
    'Toyota': ['1ZR-FE', '2ZR-FXE', 'A25A-FXS', '2GR-FE'],
  };

  static const List<String> transmissionTypes = [
    'Manuel',
    'Otomatik',
    'Yarı Otomatik',
    'DCT',
    'CVT',
  ];

  static const List<String> fuelTypes = [
    'Benzin',
    'Dizel',
    'Hibrit',
    'Elektrik',
    'LPG',
  ];

  static const List<String> engineSizes = [
    '1.0',
    '1.2',
    '1.4',
    '1.6',
    '1.8',
    '2.0',
    '2.5',
    '3.0',
    '4.0',
    '5.0',
  ];
} 