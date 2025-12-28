class ChildProfile {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String gender;
  final String? photoUrl;
  final String? bloodType;
  final String? allergies;
  final String? medicalNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChildProfile({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    this.photoUrl,
    this.bloodType,
    this.allergies,
    this.medicalNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  int get ageInWeeks {
    final now = DateTime.now();
    final difference = now.difference(dateOfBirth);
    return (difference.inDays / 7).floor();
  }

  int get ageInMonths {
    final now = DateTime.now();
    final difference = now.difference(dateOfBirth);
    return (difference.inDays / 30.44).floor();
  }

  int get ageInYears {
    final now = DateTime.now();
    int years = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      years--;
    }
    return years;
  }

  String get formattedAge {
    if (ageInYears < 1) {
      if (ageInMonths < 1) {
        return '$ageInWeeks weeks';
      }
      return '$ageInMonths months';
    } else if (ageInYears == 1) {
      return '1 year';
    } else {
      return '$ageInYears years';
    }
  }

  ChildProfile copyWith({
    String? id,
    String? name,
    DateTime? dateOfBirth,
    String? gender,
    String? photoUrl,
    String? bloodType,
    String? allergies,
    String? medicalNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String? ?? 'Male', // Default for migration
      photoUrl: json['photoUrl'] as String?,
      bloodType: json['bloodType'] as String?,
      allergies: json['allergies'] as String?,
      medicalNotes: json['medicalNotes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'photoUrl': photoUrl,
      'bloodType': bloodType,
      'allergies': allergies,
      'medicalNotes': medicalNotes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
