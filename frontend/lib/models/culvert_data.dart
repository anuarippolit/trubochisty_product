import 'user.dart';

class CulvertData {
  final String id;

  final List<User> users;

  final String address;
  final String? coordinates;
  final String? road;
  final String? serialNumber;

  final String? pipeType;
  final String? material;
  final String? diameter;
  final String? length;
  final String? headType;
  final String? foundationType;
  final String? workType;

  final DateTime? constructionDate;
  final DateTime? lastRepairDate;
  final DateTime? lastInspectionDate;

  final double? strengthRating;
  final double? safetyRating;
  final double? maintainabilityRating;
  final double? generalConditionRating;

  final List<String> defects;
  final List<String> photos;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  CulvertData({
    required this.id,
    required this.users,
    required this.address,
    this.coordinates,
    this.road,
    this.serialNumber,
    this.pipeType,
    this.material,
    this.diameter,
    this.length,
    this.headType,
    this.foundationType,
    this.workType,
    this.constructionDate,
    this.lastRepairDate,
    this.lastInspectionDate,
    this.strengthRating,
    this.safetyRating,
    this.maintainabilityRating,
    this.generalConditionRating,
    this.defects = const [],
    this.photos = const [],
    this.createdAt,
    this.updatedAt,
  });

  String get displayTitle => serialNumber?.isNotEmpty == true ? serialNumber! : address;

  factory CulvertData.fromJson(Map<String, dynamic> json) {
    return CulvertData(
      id: json['id'] ?? '',
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e))
              .toList() ??
          [],
      address: json['address'] ?? '',
      coordinates: json['coordinates'],
      road: json['road'],
      serialNumber: json['serialNumber'],
      pipeType: json['pipeType'],
      material: json['material'],
      diameter: json['diameter'],
      length: json['length'],
      headType: json['headType'],
      foundationType: json['foundationType'],
      workType: json['workType'],
      constructionDate: json['constructionDate'] != null
          ? DateTime.tryParse(json['constructionDate'])
          : null,
      lastRepairDate: json['lastRepairDate'] != null
          ? DateTime.tryParse(json['lastRepairDate'])
          : null,
      lastInspectionDate: json['lastInspectionDate'] != null
          ? DateTime.tryParse(json['lastInspectionDate'])
          : null,
      strengthRating:
          (json['strengthRating'] as num?)?.toDouble(),
      safetyRating:
          (json['safetyRating'] as num?)?.toDouble(),
      maintainabilityRating:
          (json['maintainabilityRating'] as num?)?.toDouble(),
      generalConditionRating:
          (json['generalConditionRating'] as num?)?.toDouble(),
      defects: (json['defects'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'users': users.map((u) => u.toJson()).toList(),
      'address': address,
      'coordinates': coordinates,
      'road': road,
      'serialNumber': serialNumber,
      'pipeType': pipeType,
      'material': material,
      'diameter': diameter,
      'length': length,
      'headType': headType,
      'foundationType': foundationType,
      'workType': workType,
      'constructionDate': constructionDate?.toIso8601String(),
      'lastRepairDate': lastRepairDate?.toIso8601String(),
      'lastInspectionDate': lastInspectionDate?.toIso8601String(),
      'strengthRating': strengthRating,
      'safetyRating': safetyRating,
      'maintainabilityRating': maintainabilityRating,
      'generalConditionRating': generalConditionRating,
      'defects': defects,
      'photos': photos,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory CulvertData.empty(User user) {
    return CulvertData(
      id: '',
      users: [user],
      address: '',
      coordinates: '',
      road: '',
      serialNumber: '',
      pipeType: '',
      material: '',
      diameter: '',
      length: '',
      headType: '',
      foundationType: '',
      workType: '',
      defects: [],
      photos: [],
    );
  }
}



// class CulvertData {
//   // Identifying information
//   String address;
//   String coordinates;
//   String road;
//   String serialNumber;

//   // Technical parameters
//   String pipeType;
//   String material;
//   String diameter;
//   String length;
//   String headType;
//   String foundationType;
//   String workType;

//   // Additional information
//   String constructionYear;
//   DateTime? lastRepairDate;
//   DateTime? lastInspectionDate;

//   // Condition ratings
//   double strengthRating;
//   double safetyRating;
//   double maintainabilityRating;
//   double generalConditionRating;

//   // Defects and photos
//   List<String> defects;
//   List<String> photos;

//   CulvertData({
//     this.address = '',
//     this.coordinates = '',
//     this.road = '',
//     this.serialNumber = '',
//     this.pipeType = 'Круглая',
//     this.material = 'Бетон',
//     this.diameter = '',
//     this.length = '',
//     this.headType = 'Стандартная',
//     this.foundationType = 'Стандартный',
//     this.workType = 'Обследование',
//     this.constructionYear = '',
//     this.lastRepairDate,
//     this.lastInspectionDate,
//     this.strengthRating = 3.0,
//     this.safetyRating = 3.0,
//     this.maintainabilityRating = 3.0,
//     this.generalConditionRating = 3.0,
//     this.defects = const [],
//     this.photos = const [],
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'address': address,
//       'coordinates': coordinates,
//       'road': road,
//       'serialNumber': serialNumber,
//       'pipeType': pipeType,
//       'material': material,
//       'diameter': diameter,
//       'length': length,
//       'headType': headType,
//       'foundationType': foundationType,
//       'workType': workType,
//       'constructionYear': constructionYear,
//       'lastRepairDate': lastRepairDate?.toIso8601String(),
//       'lastInspectionDate': lastInspectionDate?.toIso8601String(),
//       'strengthRating': strengthRating,
//       'safetyRating': safetyRating,
//       'maintainabilityRating': maintainabilityRating,
//       'generalConditionRating': generalConditionRating,
//       'defects': defects,
//       'photos': photos,
//     };
//   }

//   factory CulvertData.fromJson(Map<String, dynamic> json) {
//     return CulvertData(
//       address: json['address'] ?? '',
//       coordinates: json['coordinates'] ?? '',
//       road: json['road'] ?? '',
//       serialNumber: json['serialNumber'] ?? '',
//       pipeType: json['pipeType'] ?? 'Круглая',
//       material: json['material'] ?? 'Бетон',
//       diameter: json['diameter'] ?? '',
//       length: json['length'] ?? '',
//       headType: json['headType'] ?? 'Стандартная',
//       foundationType: json['foundationType'] ?? 'Стандартный',
//       workType: json['workType'] ?? 'Обследование',
//       constructionYear: json['constructionYear'] ?? '',
//       lastRepairDate: json['lastRepairDate'] != null ? DateTime.parse(json['lastRepairDate']) : null,
//       lastInspectionDate: json['lastInspectionDate'] != null ? DateTime.parse(json['lastInspectionDate']) : null,
//       strengthRating: (json['strengthRating'] ?? 3.0).toDouble(),
//       safetyRating: (json['safetyRating'] ?? 3.0).toDouble(),
//       maintainabilityRating: (json['maintainabilityRating'] ?? 3.0).toDouble(),
//       generalConditionRating: (json['generalConditionRating'] ?? 3.0).toDouble(),
//       defects: List<String>.from(json['defects'] ?? []),
//       photos: List<String>.from(json['photos'] ?? []),
//     );
//   }

//   String get displayTitle {
//     if (address.isNotEmpty) return address;
//     if (road.isNotEmpty) return road;
//     if (serialNumber.isNotEmpty) return 'Труба №$serialNumber';
//     return 'Новая труба';
//   }

//   CulvertData copyWith({
//     String? address,
//     String? coordinates,
//     String? road,
//     String? serialNumber,
//     String? pipeType,
//     String? material,
//     String? diameter,
//     String? length,
//     String? headType,
//     String? foundationType,
//     String? workType,
//     String? constructionYear,
//     DateTime? lastRepairDate,
//     DateTime? lastInspectionDate,
//     double? strengthRating,
//     double? safetyRating,
//     double? maintainabilityRating,
//     double? generalConditionRating,
//     List<String>? defects,
//     List<String>? photos,
//   }) {
//     return CulvertData(
//       address: address ?? this.address,
//       coordinates: coordinates ?? this.coordinates,
//       road: road ?? this.road,
//       serialNumber: serialNumber ?? this.serialNumber,
//       pipeType: pipeType ?? this.pipeType,
//       material: material ?? this.material,
//       diameter: diameter ?? this.diameter,
//       length: length ?? this.length,
//       headType: headType ?? this.headType,
//       foundationType: foundationType ?? this.foundationType,
//       workType: workType ?? this.workType,
//       constructionYear: constructionYear ?? this.constructionYear,
//       lastRepairDate: lastRepairDate ?? this.lastRepairDate,
//       lastInspectionDate: lastInspectionDate ?? this.lastInspectionDate,
//       strengthRating: strengthRating ?? this.strengthRating,
//       safetyRating: safetyRating ?? this.safetyRating,
//       maintainabilityRating: maintainabilityRating ?? this.maintainabilityRating,
//       generalConditionRating: generalConditionRating ?? this.generalConditionRating,
//       defects: defects ?? this.defects,
//       photos: photos ?? this.photos,
//     );
//   }

//   bool matches(String searchQuery) {
//     final query = searchQuery.toLowerCase();
//     return address.toLowerCase().contains(query) ||
//         road.toLowerCase().contains(query) ||
//         serialNumber.toLowerCase().contains(query) ||
//         coordinates.toLowerCase().contains(query) ||
//         material.toLowerCase().contains(query) ||
//         pipeType.toLowerCase().contains(query);
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     if (other is! CulvertData) return false;
//     return address == other.address &&
//         coordinates == other.coordinates &&
//         road == other.road &&
//         serialNumber == other.serialNumber &&
//         pipeType == other.pipeType &&
//         material == other.material &&
//         diameter == other.diameter &&
//         length == other.length &&
//         headType == other.headType &&
//         foundationType == other.foundationType &&
//         workType == other.workType &&
//         constructionYear == other.constructionYear &&
//         lastRepairDate == other.lastRepairDate &&
//         lastInspectionDate == other.lastInspectionDate &&
//         strengthRating == other.strengthRating &&
//         safetyRating == other.safetyRating &&
//         maintainabilityRating == other.maintainabilityRating &&
//         generalConditionRating == other.generalConditionRating;
//   }

//   @override
//   int get hashCode {
//     return Object.hash(
//       address,
//       coordinates,
//       road,
//       serialNumber,
//       pipeType,
//       material,
//       diameter,
//       length,
//       headType,
//       foundationType,
//       workType,
//       constructionYear,
//       lastRepairDate,
//       lastInspectionDate,
//       strengthRating,
//       safetyRating,
//       maintainabilityRating,
//       generalConditionRating,
//     );
//   }

//   double? get latitude {
//     final parts = coordinates.split(',');
//     if (parts.length == 2) {
//       final latStr = parts[0].replaceAll(RegExp(r'[^0-9.-]'), '');
//       return double.tryParse(latStr);
//     }
//     return null;
//   }

//   double? get longitude {
//     final parts = coordinates.split(',');
//     if (parts.length == 2) {
//       final lonStr = parts[1].replaceAll(RegExp(r'[^0-9.-]'), '');
//       return double.tryParse(lonStr);
//     }
//     return null;
//   }
// }
