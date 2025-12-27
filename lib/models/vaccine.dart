class Vaccine {
  final String id;
  final String name;
  final String shortName;
  final String description;
  final int totalDoses;
  final List<VaccineDose> doses;
  final String administrationSchedule;
  final String sideEffects;
  final String purpose;

  Vaccine({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.totalDoses,
    required this.doses,
    required this.administrationSchedule,
    this.sideEffects = '',
    this.purpose = '',
  });

  int get completedDoses => doses.where((dose) => dose.isAdministered).length;

  double get completionPercentage => 
      totalDoses > 0 ? (completedDoses / totalDoses * 100).roundToDouble() : 0;

  bool get isCompleted => completedDoses == totalDoses;

  VaccineDose? get nextDose => 
      doses.firstWhere((dose) => !dose.isAdministered, orElse: () => doses.last);

  factory Vaccine.fromJson(Map<String, dynamic> json) {
    return Vaccine(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      description: json['description'] as String,
      totalDoses: json['totalDoses'] as int,
      doses: (json['doses'] as List)
          .map((dose) => VaccineDose.fromJson(dose))
          .toList(),
      administrationSchedule: json['administrationSchedule'] as String,
      sideEffects: json['sideEffects'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'description': description,
      'totalDoses': totalDoses,
      'doses': doses.map((dose) => dose.toJson()).toList(),
      'administrationSchedule': administrationSchedule,
      'sideEffects': sideEffects,
      'purpose': purpose,
    };
  }

  Vaccine copyWith({
    String? id,
    String? name,
    String? shortName,
    String? description,
    int? totalDoses,
    List<VaccineDose>? doses,
    String? administrationSchedule,
    String? sideEffects,
    String? purpose,
  }) {
    return Vaccine(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      description: description ?? this.description,
      totalDoses: totalDoses ?? this.totalDoses,
      doses: doses ?? this.doses,
      administrationSchedule: administrationSchedule ?? this.administrationSchedule,
      sideEffects: sideEffects ?? this.sideEffects,
      purpose: purpose ?? this.purpose,
    );
  }
}

class VaccineDose {
  final String id;
  final int doseNumber;
  final DateTime? scheduledDate;
  final DateTime? administeredDate;
  final bool isAdministered;
  final String? administeredBy;
  final String? batchNumber;
  final String? notes;
  final int ageInWeeks;

  VaccineDose({
    required this.id,
    required this.doseNumber,
    this.scheduledDate,
    this.administeredDate,
    this.isAdministered = false,
    this.administeredBy,
    this.batchNumber,
    this.notes,
    required this.ageInWeeks,
  });

  bool get isDue {
    if (isAdministered) return false;
    if (scheduledDate == null) return false;
    return DateTime.now().isAfter(scheduledDate!.subtract(const Duration(days: 7)));
  }

  bool get isOverdue {
    if (isAdministered) return false;
    if (scheduledDate == null) return false;
    return DateTime.now().isAfter(scheduledDate!);
  }

  VaccineDose copyWith({
    String? id,
    int? doseNumber,
    DateTime? scheduledDate,
    DateTime? administeredDate,
    bool? isAdministered,
    String? administeredBy,
    String? batchNumber,
    String? notes,
    int? ageInWeeks,
  }) {
    return VaccineDose(
      id: id ?? this.id,
      doseNumber: doseNumber ?? this.doseNumber,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      administeredDate: administeredDate ?? this.administeredDate,
      isAdministered: isAdministered ?? this.isAdministered,
      administeredBy: administeredBy ?? this.administeredBy,
      batchNumber: batchNumber ?? this.batchNumber,
      notes: notes ?? this.notes,
      ageInWeeks: ageInWeeks ?? this.ageInWeeks,
    );
  }

  factory VaccineDose.fromJson(Map<String, dynamic> json) {
    return VaccineDose(
      id: json['id'] as String,
      doseNumber: json['doseNumber'] as int,
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : null,
      administeredDate: json['administeredDate'] != null
          ? DateTime.parse(json['administeredDate'] as String)
          : null,
      isAdministered: json['isAdministered'] as bool? ?? false,
      administeredBy: json['administeredBy'] as String?,
      batchNumber: json['batchNumber'] as String?,
      notes: json['notes'] as String?,
      ageInWeeks: json['ageInWeeks'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doseNumber': doseNumber,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'administeredDate': administeredDate?.toIso8601String(),
      'isAdministered': isAdministered,
      'administeredBy': administeredBy,
      'batchNumber': batchNumber,
      'notes': notes,
      'ageInWeeks': ageInWeeks,
    };
  }
}
