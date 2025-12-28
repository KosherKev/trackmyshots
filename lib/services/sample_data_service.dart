import 'package:trackmyshots/models/models.dart';

class SampleDataService {
  // Sample child - Emily Ross, 6 months old
  static ChildProfile getSampleChild() {
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
    
    return ChildProfile(
      id: 'child_1',
      name: 'Emily Ross',
      gender: 'Male',
      dateOfBirth: sixMonthsAgo,
      createdAt: sixMonthsAgo,
      updatedAt: now,
    );
  }

  // Generate CLEAN vaccine schedule based on child's age (for new users)
  static List<Vaccine> generateScheduleForChild(ChildProfile child) {
    final birthDate = child.dateOfBirth;
    
    return [
      // Hepatitis B - 3 doses
      Vaccine(
        id: 'hep_b',
        name: 'Hepatitis B',
        shortName: 'H',
        description: 'Hepatitis B is a liver disease that can cause mild illness lasting a few weeks, or it can lead to a serious, lifelong illness.',
        totalDoses: 3,
        administrationSchedule: 'At birth, 1-2 months, and 6-18 months',
        purpose: 'Protects against Hepatitis B virus, which spreads through blood and body fluids. The vaccine is the first anti-cancer vaccine because it prevents liver cancer caused by the virus.',
        sideEffects: 'Soreness where the shot was given, fever, or allergic reactions (rare).',
        doses: [
          VaccineDose(
            id: 'hep_b_1',
            doseNumber: 1,
            scheduledDate: birthDate,
            isAdministered: false,
            ageInWeeks: 0,
          ),
          VaccineDose(
            id: 'hep_b_2',
            doseNumber: 2,
            scheduledDate: birthDate.add(const Duration(days: 42)), // 6 weeks
            isAdministered: false,
            ageInWeeks: 6,
          ),
          VaccineDose(
            id: 'hep_b_3',
            doseNumber: 3,
            scheduledDate: birthDate.add(const Duration(days: 182)), // 26 weeks
            isAdministered: false,
            ageInWeeks: 26,
          ),
        ],
      ),

      // Rotavirus - 2 doses
      Vaccine(
        id: 'rotavirus',
        name: 'Rotavirus',
        shortName: 'R',
        description: 'Rotavirus causes severe diarrhea and vomiting. It affects mostly babies and young children.',
        totalDoses: 2,
        administrationSchedule: 'At 6 and 10 weeks of age',
        purpose: 'Prevents severe diarrhea, vomiting, fever, and abdominal pain caused by rotavirus. Vaccination prevents hospitalization from dehydration.',
        sideEffects: 'Mild diarrhea, vomiting, irritability, or fever.',
        doses: [
          VaccineDose(
            id: 'rota_1',
            doseNumber: 1,
            scheduledDate: birthDate.add(const Duration(days: 42)), // 6 weeks
            isAdministered: false,
            ageInWeeks: 6,
          ),
          VaccineDose(
            id: 'rota_2',
            doseNumber: 2,
            scheduledDate: birthDate.add(const Duration(days: 70)), // 10 weeks
            isAdministered: false,
            ageInWeeks: 10,
          ),
        ],
      ),

      // DTP - 4 doses
      Vaccine(
        id: 'dtp',
        name: 'DTP (Diphtheria, Tetanus, Pertussis)',
        shortName: 'D',
        description: 'Protects against three serious diseases: Diphtheria (breathing problems), Tetanus (lockjaw), and Pertussis (whooping cough).',
        totalDoses: 4,
        administrationSchedule: 'At 6, 10, 14 weeks, and 15-18 months',
        purpose: 'Prevents thick coating in throat (Diphtheria), painful muscle stiffening (Tetanus), and severe coughing fits (Pertussis).',
        sideEffects: 'Fever, redness/swelling at shot site, soreness, fussiness, or tiredness.',
        doses: [
          VaccineDose(
            id: 'dtp_1',
            doseNumber: 1,
            scheduledDate: birthDate.add(const Duration(days: 42)), // 6 weeks
            isAdministered: false,
            ageInWeeks: 6,
          ),
          VaccineDose(
            id: 'dtp_2',
            doseNumber: 2,
            scheduledDate: birthDate.add(const Duration(days: 70)), // 10 weeks
            isAdministered: false,
            ageInWeeks: 10,
          ),
          VaccineDose(
            id: 'dtp_3',
            doseNumber: 3,
            scheduledDate: birthDate.add(const Duration(days: 98)), // 14 weeks
            isAdministered: false,
            ageInWeeks: 14,
          ),
          VaccineDose(
            id: 'dtp_4',
            doseNumber: 4,
            scheduledDate: birthDate.add(const Duration(days: 455)), // 65 weeks (~15 months)
            isAdministered: false,
            ageInWeeks: 65,
          ),
        ],
      ),

      // Hib - 4 doses
      Vaccine(
        id: 'hib',
        name: 'Hib (Haemophilus influenzae type b)',
        shortName: 'H',
        description: 'Haemophilus influenzae type b can cause severe infection, affecting the brain (meningitis) and lungs (pneumonia).',
        totalDoses: 4,
        administrationSchedule: 'At 6, 10, 14 weeks, and 12-15 months',
        purpose: 'Prevents meningitis, pneumonia, and severe throat infections (epiglottitis) which can lead to brain damage or deafness.',
        sideEffects: 'Redness, warmth, or swelling at injection site, and fever.',
        doses: [
          VaccineDose(
            id: 'hib_1',
            doseNumber: 1,
            scheduledDate: birthDate.add(const Duration(days: 42)), // 6 weeks
            isAdministered: false,
            ageInWeeks: 6,
          ),
          VaccineDose(
            id: 'hib_2',
            doseNumber: 2,
            scheduledDate: birthDate.add(const Duration(days: 70)), // 10 weeks
            isAdministered: false,
            ageInWeeks: 10,
          ),
          VaccineDose(
            id: 'hib_3',
            doseNumber: 3,
            scheduledDate: birthDate.add(const Duration(days: 98)), // 14 weeks
            isAdministered: false,
            ageInWeeks: 14,
          ),
          VaccineDose(
            id: 'hib_4',
            doseNumber: 4,
            scheduledDate: birthDate.add(const Duration(days: 364)), // 52 weeks (~12 months)
            isAdministered: false,
            ageInWeeks: 52,
          ),
        ],
      ),

      // PCV - 4 doses
      Vaccine(
        id: 'pcv',
        name: 'PCV (Pneumococcal Conjugate Vaccine)',
        shortName: 'P',
        description: 'Pneumococcal disease is caused by bacteria that can lead to ear infections, pneumonia, and meningitis.',
        totalDoses: 4,
        administrationSchedule: 'At 6, 10, 14 weeks, and 12-15 months',
        purpose: 'Protects against pneumococcal bacteria which cause ear infections, sinus infections, pneumonia, and bloodstream infections.',
        sideEffects: 'Drowsiness, temporary loss of appetite, redness/swelling at shot site, or mild fever.',
        doses: [
          VaccineDose(
            id: 'pcv_1',
            doseNumber: 1,
            scheduledDate: birthDate.add(const Duration(days: 42)), // 6 weeks
            isAdministered: false,
            ageInWeeks: 6,
          ),
          VaccineDose(
            id: 'pcv_2',
            doseNumber: 2,
            scheduledDate: birthDate.add(const Duration(days: 70)), // 10 weeks
            isAdministered: false,
            ageInWeeks: 10,
          ),
          VaccineDose(
            id: 'pcv_3',
            doseNumber: 3,
            scheduledDate: birthDate.add(const Duration(days: 98)), // 14 weeks
            isAdministered: false,
            ageInWeeks: 14,
          ),
          VaccineDose(
            id: 'pcv_4',
            doseNumber: 4,
            scheduledDate: birthDate.add(const Duration(days: 364)), // 52 weeks (~12 months)
            isAdministered: false,
            ageInWeeks: 52,
          ),
        ],
      ),
    ];
  }

  // Generate vaccine schedule based on child's age
  static List<Vaccine> getVaccinesForChild(ChildProfile child) {
    final birthDate = child.dateOfBirth;
    
    return [
      // Hepatitis B - 3 doses (at birth, 1-2 months, 6-18 months)
      Vaccine(
        id: 'hep_b',
        name: 'Hepatitis B',
        shortName: 'H',
        description: 'Hepatitis B is a liver disease that can cause mild illness lasting a few weeks, or it can lead to a serious, lifelong illness.',
        totalDoses: 3,
        administrationSchedule: 'At birth, 1-2 months, and 6-18 months',
        purpose: 'Protects against Hepatitis B virus, which spreads through blood and body fluids. The vaccine is the first anti-cancer vaccine because it prevents liver cancer caused by the virus.',
        sideEffects: 'Soreness where the shot was given, fever, or allergic reactions (rare).',
        doses: [
          VaccineDose(
            id: 'hep_b_1',
            doseNumber: 1,
            scheduledDate: birthDate,
            administeredDate: birthDate,
            isAdministered: true,
            ageInWeeks: 0,
            administeredBy: 'Dr. Smith',
            batchNumber: 'HB2024-001',
          ),
          VaccineDose(
            id: 'hep_b_2',
            doseNumber: 2,
            scheduledDate: birthDate.add(const Duration(days: 42)), // 6 weeks
            administeredDate: birthDate.add(const Duration(days: 42)),
            isAdministered: true,
            ageInWeeks: 6,
            administeredBy: 'Dr. Smith',
            batchNumber: 'HB2024-002',
          ),
          VaccineDose(
            id: 'hep_b_3',
            doseNumber: 3,
            scheduledDate: birthDate.add(const Duration(days: 182)), // 26 weeks
            administeredDate: birthDate.add(const Duration(days: 182)),
            isAdministered: true,
            ageInWeeks: 26,
            administeredBy: 'Dr. Smith',
            batchNumber: 'HB2024-003',
          ),
        ],
      ),

      // Rotavirus - 2 doses (at 6 and 10 weeks)
      Vaccine(
        id: 'rotavirus',
        name: 'Rotavirus',
        shortName: 'R',
        description: 'Rotavirus causes severe diarrhea and vomiting. It affects mostly babies and young children.',
        totalDoses: 2,
        administrationSchedule: 'At 6 and 10 weeks of age',
        purpose: 'Prevents severe diarrhea, vomiting, fever, and abdominal pain caused by rotavirus. Vaccination prevents hospitalization from dehydration.',
        sideEffects: 'Mild diarrhea, vomiting, irritability, or fever.',
        doses: [
          VaccineDose(
            id: 'rota_1',
            doseNumber: 1,
            scheduledDate: birthDate.add(const Duration(days: 42)), // 6 weeks
            administeredDate: birthDate.add(const Duration(days: 42)),
            isAdministered: true,
            ageInWeeks: 6,
            administeredBy: 'Dr. Smith',
            batchNumber: 'RV2024-001',
          ),
          VaccineDose(
            id: 'rota_2',
            doseNumber: 2,
            scheduledDate: birthDate.add(const Duration(days: 70)), // 10 weeks
            isAdministered: false,
            ageInWeeks: 10,
          ),
        ],
      ),

      // DTP - 4 doses (at 6, 10, 14 weeks, and 15-18 months)
      Vaccine(
        id: 'dtp',
        name: 'DTP (Diphtheria, Tetanus, Pertussis)',
        shortName: 'D',
        description: 'Protects against three serious diseases: Diphtheria (breathing problems), Tetanus (lockjaw), and Pertussis (whooping cough).',
        totalDoses: 4,
        administrationSchedule: 'At 6, 10, 14 weeks, and 15-18 months',
        purpose: 'Prevents thick coating in throat (Diphtheria), painful muscle stiffening (Tetanus), and severe coughing fits (Pertussis).',
        sideEffects: 'Fever, redness/swelling at shot site, soreness, fussiness, or tiredness.',
        doses: [
          VaccineDose(
            id: 'dtp_1',
            doseNumber: 1,
            scheduledDate: birthDate.add(const Duration(days: 42)), // 6 weeks
            administeredDate: birthDate.add(const Duration(days: 42)),
            isAdministered: true,
            ageInWeeks: 6,
            administeredBy: 'Dr. Smith',
            batchNumber: 'DTP2024-001',
          ),
          VaccineDose(
            id: 'dtp_2',
            doseNumber: 2,
            scheduledDate: birthDate.add(const Duration(days: 70)), // 10 weeks
            isAdministered: false,
            ageInWeeks: 10,
          ),
          VaccineDose(
            id: 'dtp_3',
            doseNumber: 3,
            scheduledDate: birthDate.add(const Duration(days: 98)), // 14 weeks
            isAdministered: false,
            ageInWeeks: 14,
          ),
          VaccineDose(
            id: 'dtp_4',
            doseNumber: 4,
            scheduledDate: birthDate.add(const Duration(days: 455)), // 65 weeks (~15 months)
            isAdministered: false,
            ageInWeeks: 65,
          ),
        ],
      ),

      // Hib - 4 doses (at 6, 10, 14 weeks, and 12-15 months)
      Vaccine(
        id: 'hib',
        name: 'Hib (Haemophilus influenzae type b)',
        shortName: 'H',
        description: 'Haemophilus influenzae type b can cause severe infection, affecting the brain (meningitis) and lungs (pneumonia).',
        totalDoses: 4,
        administrationSchedule: 'At 6, 10, 14 weeks, and 12-15 months',
        purpose: 'Prevents meningitis, pneumonia, and severe throat infections (epiglottitis) which can lead to brain damage or deafness.',
        sideEffects: 'Redness, warmth, or swelling at injection site, and fever.',
        doses: [
          VaccineDose(
            id: 'hib_1',
            doseNumber: 1,
            scheduledDate: birthDate.add(const Duration(days: 42)), // 6 weeks
            administeredDate: birthDate.add(const Duration(days: 42)),
            isAdministered: true,
            ageInWeeks: 6,
            administeredBy: 'Dr. Smith',
            batchNumber: 'HIB2024-001',
          ),
          VaccineDose(
            id: 'hib_2',
            doseNumber: 2,
            scheduledDate: birthDate.add(const Duration(days: 70)), // 10 weeks
            administeredDate: birthDate.add(const Duration(days: 70)),
            isAdministered: true,
            ageInWeeks: 10,
            administeredBy: 'Dr. Smith',
            batchNumber: 'HIB2024-002',
          ),
          VaccineDose(
            id: 'hib_3',
            doseNumber: 3,
            scheduledDate: birthDate.add(const Duration(days: 98)), // 14 weeks
            administeredDate: birthDate.add(const Duration(days: 98)),
            isAdministered: true,
            ageInWeeks: 14,
            administeredBy: 'Dr. Smith',
            batchNumber: 'HIB2024-003',
          ),
          VaccineDose(
            id: 'hib_4',
            doseNumber: 4,
            scheduledDate: birthDate.add(const Duration(days: 364)), // 52 weeks (~12 months)
            isAdministered: false,
            ageInWeeks: 52,
          ),
        ],
      ),

      // PCV - 4 doses (at 6, 10, 14 weeks, and 12-15 months)
      Vaccine(
        id: 'pcv',
        name: 'PCV (Pneumococcal Conjugate Vaccine)',
        shortName: 'P',
        description: 'Pneumococcal disease is caused by bacteria that can lead to ear infections, pneumonia, and meningitis.',
        totalDoses: 4,
        administrationSchedule: 'At 6, 10, 14 weeks, and 12-15 months',
        purpose: 'Protects against pneumococcal bacteria which cause ear infections, sinus infections, pneumonia, and bloodstream infections.',
        sideEffects: 'Drowsiness, temporary loss of appetite, redness/swelling at shot site, or mild fever.',
        doses: [
          VaccineDose(
            id: 'pcv_1',
            doseNumber: 1,
            scheduledDate: birthDate.add(const Duration(days: 42)), // 6 weeks
            administeredDate: birthDate.add(const Duration(days: 42)),
            isAdministered: true,
            ageInWeeks: 6,
            administeredBy: 'Dr. Smith',
            batchNumber: 'PCV2024-001',
          ),
          VaccineDose(
            id: 'pcv_2',
            doseNumber: 2,
            scheduledDate: birthDate.add(const Duration(days: 70)), // 10 weeks
            isAdministered: false,
            ageInWeeks: 10,
          ),
          VaccineDose(
            id: 'pcv_3',
            doseNumber: 3,
            scheduledDate: birthDate.add(const Duration(days: 98)), // 14 weeks
            isAdministered: false,
            ageInWeeks: 14,
          ),
          VaccineDose(
            id: 'pcv_4',
            doseNumber: 4,
            scheduledDate: birthDate.add(const Duration(days: 364)), // 52 weeks
            isAdministered: false,
            ageInWeeks: 52,
          ),
        ],
      ),
    ];
  }

  // Sample appointments
  static List<Appointment> getSampleAppointments() {
    final now = DateTime.now();
    
    return [
      // Upcoming appointment
      Appointment(
        id: 'apt_1',
        doctorName: 'Dr. Ray Alex',
        doctorSpecialty: 'General Practitioner',
        doctorPhotoUrl: null,
        dateTime: DateTime(2025, 5, 21, 10, 30),
        duration: const Duration(hours: 1),
        location: 'Community Health Center',
        type: AppointmentType.vaccination,
        status: AppointmentStatus.confirmed,
        notes: 'Bring vaccination card',
        linkedVaccines: [
          VaccineLink(vaccineId: 'rotavirus', doseId: 'rotavirus_2'),
          VaccineLink(vaccineId: 'pcv', doseId: 'pcv_2'),
        ],
      ),
      
      // Past appointment
      Appointment(
        id: 'apt_2',
        doctorName: 'Dr. Sarah Johnson',
        doctorSpecialty: 'Pediatrician',
        dateTime: now.subtract(const Duration(days: 30)),
        location: 'Children\'s Clinic',
        type: AppointmentType.checkup,
        status: AppointmentStatus.completed,
        notes: 'Regular 6-week checkup completed successfully',
      ),
    ];
  }

  // Get upcoming doses
  static List<Map<String, dynamic>> getUpcomingDoses(
    List<Vaccine> vaccines,
    ChildProfile child,
  ) {
    final upcomingDoses = <Map<String, dynamic>>[];
    
    for (final vaccine in vaccines) {
      for (final dose in vaccine.doses) {
        if (!dose.isAdministered && dose.scheduledDate != null) {
          upcomingDoses.add({
            'vaccine': vaccine,
            'dose': dose,
            'daysUntil': dose.scheduledDate!.difference(DateTime.now()).inDays,
          });
        }
      }
    }
    
    // Sort by scheduled date
    upcomingDoses.sort((a, b) {
      final doseA = a['dose'] as VaccineDose;
      final doseB = b['dose'] as VaccineDose;
      return doseA.scheduledDate!.compareTo(doseB.scheduledDate!);
    });
    
    return upcomingDoses;
  }
}
