class VaccineLink {
  final String vaccineId;
  final String doseId; // Changed from doseNumber to doseId for better mapping
  final bool wasAdministered;
  final String? notGivenReason;

  VaccineLink({
    required this.vaccineId,
    required this.doseId,
    this.wasAdministered = false,
    this.notGivenReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'vaccineId': vaccineId,
      'doseId': doseId,
      'wasAdministered': wasAdministered,
      'notGivenReason': notGivenReason,
    };
  }

  factory VaccineLink.fromJson(Map<String, dynamic> json) {
    return VaccineLink(
      vaccineId: json['vaccineId'] as String,
      doseId: json['doseId'] as String,
      wasAdministered: json['wasAdministered'] as bool? ?? false,
      notGivenReason: json['notGivenReason'] as String?,
    );
  }
}

class AppointmentFulfillment {
  final bool wasKept;
  final DateTime? actualDateTime;
  final String? notes;
  final List<VaccineLink> vaccineLinks; // Snapshot of what happened

  AppointmentFulfillment({
    required this.wasKept,
    this.actualDateTime,
    this.notes,
    this.vaccineLinks = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'wasKept': wasKept,
      'actualDateTime': actualDateTime?.toIso8601String(),
      'notes': notes,
      'vaccineLinks': vaccineLinks.map((l) => l.toJson()).toList(),
    };
  }

  factory AppointmentFulfillment.fromJson(Map<String, dynamic> json) {
    return AppointmentFulfillment(
      wasKept: json['wasKept'] as bool,
      actualDateTime: json['actualDateTime'] != null 
          ? DateTime.parse(json['actualDateTime'] as String) 
          : null,
      notes: json['notes'] as String?,
      vaccineLinks: (json['vaccineLinks'] as List?)
          ?.map((e) => VaccineLink.fromJson(e as Map<String, dynamic>))
          .toList() ?? const [],
    );
  }
}

class Appointment {
  final String id;
  final String doctorName;
  final String doctorSpecialty;
  final String? doctorPhotoUrl;
  final DateTime dateTime;
  final Duration duration;
  final String location;
  final AppointmentType type;
  final AppointmentStatus status;
  final String? notes;
  final List<VaccineLink> linkedVaccines;
  final AppointmentFulfillment? fulfillment;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.doctorSpecialty,
    this.doctorPhotoUrl,
    required this.dateTime,
    this.duration = const Duration(hours: 1),
    required this.location,
    required this.type,
    this.status = AppointmentStatus.scheduled,
    this.notes,
    this.linkedVaccines = const [],
    this.fulfillment,
  });

  DateTime get endTime => dateTime.add(duration);

  bool get isPast => DateTime.now().isAfter(dateTime);

  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  bool get isUpcoming => DateTime.now().isBefore(dateTime) && !isToday;

  String get formattedDate {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return '${days[dateTime.weekday - 1]}, ${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  String get formattedTime {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'pm' : 'am';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    final endHour = endTime.hour > 12 ? endTime.hour - 12 : endTime.hour;
    final endPeriod = endTime.hour >= 12 ? 'pm' : 'am';
    final endMinute = endTime.minute.toString().padLeft(2, '0');
    
    return '$hour:$minute $period - $endHour:$endMinute $endPeriod';
  }

  Appointment copyWith({
    String? id,
    String? doctorName,
    String? doctorSpecialty,
    String? doctorPhotoUrl,
    DateTime? dateTime,
    Duration? duration,
    String? location,
    AppointmentType? type,
    AppointmentStatus? status,
    String? notes,
    List<VaccineLink>? linkedVaccines,
    AppointmentFulfillment? fulfillment,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      doctorPhotoUrl: doctorPhotoUrl ?? this.doctorPhotoUrl,
      dateTime: dateTime ?? this.dateTime,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      linkedVaccines: linkedVaccines ?? this.linkedVaccines,
      fulfillment: fulfillment ?? this.fulfillment,
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    // Handle legacy relatedVaccineIds if present and linkedVaccines is missing
    List<VaccineLink> links = [];
    if (json['linkedVaccines'] != null) {
      links = (json['linkedVaccines'] as List)
          .map((e) => VaccineLink.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (json['relatedVaccineIds'] != null) {
      // Migration for legacy data
      links = (json['relatedVaccineIds'] as List)
          .map((id) => VaccineLink(vaccineId: id as String, doseId: 'unknown'))
          .toList();
    }

    return Appointment(
      id: json['id'] as String,
      doctorName: json['doctorName'] as String,
      doctorSpecialty: json['doctorSpecialty'] as String,
      doctorPhotoUrl: json['doctorPhotoUrl'] as String?,
      dateTime: DateTime.parse(json['dateTime'] as String),
      duration: Duration(minutes: json['durationMinutes'] as int? ?? 60),
      location: json['location'] as String,
      type: AppointmentType.values.firstWhere(
        (e) => e.toString() == 'AppointmentType.${json['type']}',
        orElse: () => AppointmentType.vaccination,
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString() == 'AppointmentStatus.${json['status']}',
        orElse: () => AppointmentStatus.scheduled,
      ),
      notes: json['notes'] as String?,
      linkedVaccines: links,
      fulfillment: json['fulfillment'] != null
          ? AppointmentFulfillment.fromJson(json['fulfillment'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'doctorPhotoUrl': doctorPhotoUrl,
      'dateTime': dateTime.toIso8601String(),
      'durationMinutes': duration.inMinutes,
      'location': location,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'notes': notes,
      'linkedVaccines': linkedVaccines.map((l) => l.toJson()).toList(),
      'fulfillment': fulfillment?.toJson(),
    };
  }
}

enum AppointmentType {
  vaccination,
  checkup,
  consultation,
  followUp,
  emergency,
}

enum AppointmentStatus {
  scheduled,
  confirmed,
  completed,
  cancelled,
  noShow,
}
