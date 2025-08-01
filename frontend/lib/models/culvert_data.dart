import 'package:intl/intl.dart';
import 'user.dart';

class CulvertData {
  final String id;
  final List<User> users;
  final String address;
  final String coordinates;
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
    required this.coordinates,
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

  String get displayTitle =>
      serialNumber?.isNotEmpty == true ? serialNumber! : address;

  factory CulvertData.fromJson(Map<String, dynamic> json) {
    return CulvertData(
      id: json['id'] ?? '',
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e))
              .toList() ??
          [],
      address: json['address'] ?? '',
      coordinates: json['coordinates'] ?? '',
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
      strengthRating: (json['strengthRating'] as num?)?.toDouble(),
      safetyRating: (json['safetyRating'] as num?)?.toDouble(),
      maintainabilityRating: (json['maintainabilityRating'] as num?)?.toDouble(),
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
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final data = <String, dynamic>{
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
      'strengthRating': strengthRating,
      'safetyRating': safetyRating,
      'maintainabilityRating': maintainabilityRating,
      'generalConditionRating': generalConditionRating,
      'defects': defects,
      'photos': photos,
      'users': users.map((u) => u.id).toList(),
    };

    if (id.isNotEmpty) data['id'] = id;
    if (constructionDate != null) {
      data['constructionDate'] = dateFormat.format(constructionDate!);
    }
    if (lastRepairDate != null) {
      data['lastRepairDate'] = dateFormat.format(lastRepairDate!);
    }
    if (lastInspectionDate != null) {
      data['lastInspectionDate'] = dateFormat.format(lastInspectionDate!);
    }

    return data;
  }

  factory CulvertData.empty(User user) {
    return CulvertData(
      id: '',
      users: [user],
      address: '',
      coordinates: '',
      road: null,
      serialNumber: null,
      pipeType: null,
      material: null,
      diameter: null,
      length: null,
      headType: null,
      foundationType: null,
      workType: null,
      defects: [],
      photos: [],
    );
  }
}
