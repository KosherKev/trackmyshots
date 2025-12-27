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
  final List<String> relatedVaccineIds;

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
    this.relatedVaccineIds = const [],
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
    List<String>? relatedVaccineIds,
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
      relatedVaccineIds: relatedVaccineIds ?? this.relatedVaccineIds,
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
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
      relatedVaccineIds: (json['relatedVaccineIds'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
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
      'relatedVaccineIds': relatedVaccineIds,
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
