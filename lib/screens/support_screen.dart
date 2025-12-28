import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  final SupportPageType type;

  const SupportScreen({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _getTitle(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _buildContent(context),
      ),
    );
  }

  String _getTitle() {
    switch (type) {
      case SupportPageType.help:
        return 'Help & Support';
      case SupportPageType.privacy:
        return 'Privacy Policy';
      case SupportPageType.terms:
        return 'Terms of Use';
      case SupportPageType.contact:
        return 'Contact Us';
    }
  }

  Widget _buildContent(BuildContext context) {
    switch (type) {
      case SupportPageType.help:
        return _buildHelpContent();
      case SupportPageType.privacy:
        return _buildPrivacyContent();
      case SupportPageType.terms:
        return _buildTermsContent();
      case SupportPageType.contact:
        return _buildContactContent(context);
    }
  }

  Widget _buildHelpContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          'Frequently Asked Questions',
          Icons.help_outline,
        ),
        const SizedBox(height: 16),
        
        _buildFAQItem(
          'How do I mark a vaccination as completed?',
          'Navigate to the Tracking screen, tap on the vaccine card, then tap the "Mark as Given" button for the specific dose. Enter the administration details and save.',
        ),
        
        _buildFAQItem(
          'Can I edit my child\'s profile?',
          'Yes! Go to the Profile screen and tap on your child\'s profile card. You can update their name, birthdate, blood type, allergies, and medical notes.',
        ),
        
        _buildFAQItem(
          'How do I export my vaccination data?',
          'In the Profile screen, scroll down to "Data Management" and tap "Export Data". Your vaccination records will be exported as a JSON file for backup.',
        ),
        
        _buildFAQItem(
          'What if I miss a scheduled vaccination?',
          'The app will mark it as overdue in the Reminders screen. Contact your healthcare provider as soon as possible to reschedule. You don\'t need to restart the vaccine series - just continue where you left off.',
        ),
        
        _buildFAQItem(
          'How do I add a new appointment?',
          'Currently, appointments are managed through the sample data. A feature to add custom appointments is coming soon!',
        ),
        
        _buildFAQItem(
          'Will my data be backed up automatically?',
          'The app automatically saves all changes to your device using local storage. For an additional backup, use the Export Data feature in the Profile screen.',
        ),
        
        _buildFAQItem(
          'How do I enable/disable notifications?',
          'Go to Profile > App section and toggle the "Push Notifications" switch.',
        ),
        
        _buildFAQItem(
          'Can I track multiple children?',
          'Currently, the app supports one child profile. Support for multiple children is planned for a future update.',
        ),
        
        const SizedBox(height: 24),
        _buildSection(
          'Need More Help?',
          Icons.contact_support,
        ),
        const SizedBox(height: 12),
        const Text(
          'If you have questions that aren\'t answered here, please contact us through the Contact Us page or email us at support@trackmyshots.app',
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Effective Date: December 28, 2024',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 24),
        
        _buildSection('1. Introduction', Icons.info_outline),
        const SizedBox(height: 12),
        const Text(
          'TrackMyShots ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our child immunization tracking application.',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('2. Information We Collect', Icons.storage),
        const SizedBox(height: 12),
        const Text(
          '''We collect and store the following information locally on your device:

• Child's personal information (name, date of birth, blood type, allergies)
• Vaccination records (vaccine names, dates administered, healthcare providers)
• Appointment information (doctor names, dates, locations)
• Medical notes and observations
• App preferences and settings

All data is stored locally on your device. We do not transmit your personal information to our servers or any third parties.''',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('3. How We Use Your Information', Icons.how_to_reg),
        const SizedBox(height: 12),
        const Text(
          '''Your information is used solely to:

• Display your child's vaccination schedule and history
• Send reminders for upcoming vaccinations
• Track immunization progress
• Generate vaccination reports
• Provide educational content about vaccines

We do not use your information for any other purpose, and we do not share it with third parties.''',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('4. Data Security', Icons.security),
        const SizedBox(height: 12),
        const Text(
          '''We take data security seriously:

• All data is stored locally on your device using secure storage mechanisms
• No data is transmitted over the internet
• You can export your data for backup purposes
• You have complete control to delete all data at any time
• We recommend backing up your device regularly''',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('5. Your Rights', Icons.account_circle),
        const SizedBox(height: 12),
        const Text(
          '''You have the right to:

• Access your data at any time through the app
• Export your data as a backup file
• Delete all your data permanently
• Modify your child's information
• Control notification preferences

Since all data is stored locally, you have complete control over your information.''',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('6. Children\'s Privacy', Icons.child_care),
        const SizedBox(height: 12),
        const Text(
          'This app is designed to help parents track their children\'s vaccinations. We understand the sensitivity of children\'s health information and treat all data with the utmost care and security.',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('7. Changes to This Policy', Icons.update),
        const SizedBox(height: 12),
        const Text(
          'We may update this Privacy Policy from time to time. We will notify you of any changes by updating the "Effective Date" at the top of this policy.',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('8. Contact Us', Icons.contact_mail),
        const SizedBox(height: 12),
        const Text(
          'If you have questions about this Privacy Policy, please contact us at:\n\nEmail: privacy@trackmyshots.app\nWebsite: www.trackmyshots.app',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildTermsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Effective Date: December 28, 2024',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 24),
        
        _buildSection('1. Acceptance of Terms', Icons.check_circle_outline),
        const SizedBox(height: 12),
        const Text(
          'By downloading, installing, or using TrackMyShots, you agree to be bound by these Terms of Use. If you do not agree to these terms, please do not use the app.',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('2. Description of Service', Icons.medical_services),
        const SizedBox(height: 12),
        const Text(
          '''TrackMyShots is a personal health tracking application designed to help parents:

• Track their child's vaccination schedule
• Record administered vaccines
• Receive reminders for upcoming vaccinations
• Access educational information about immunizations
• Manage appointment information

This app is a tool to help you organize information. It is not a substitute for professional medical advice, diagnosis, or treatment.''',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('3. Medical Disclaimer', Icons.warning_amber),
        const SizedBox(height: 12),
        const Text(
          '''IMPORTANT MEDICAL DISCLAIMER:

• TrackMyShots is NOT a medical device
• The app does NOT provide medical advice
• Always consult with qualified healthcare professionals
• Do not disregard professional medical advice based on app information
• In case of medical emergency, call emergency services immediately
• Vaccination schedules should be confirmed with your healthcare provider

The information in this app is for organizational purposes only and should not replace professional medical guidance.''',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('4. User Responsibilities', Icons.person),
        const SizedBox(height: 12),
        const Text(
          '''You agree to:

• Provide accurate information
• Keep your data up to date
• Use the app responsibly
• Not use the app for any illegal purposes
• Back up your data regularly
• Verify all vaccination information with healthcare providers
• Not share medical decisions based solely on app data''',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('5. Data and Privacy', Icons.privacy_tip),
        const SizedBox(height: 12),
        const Text(
          'All data entered into TrackMyShots is stored locally on your device. We do not collect, transmit, or store your personal health information on external servers. Please refer to our Privacy Policy for detailed information.',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('6. Limitation of Liability', Icons.gavel),
        const SizedBox(height: 12),
        const Text(
          '''TrackMyShots is provided "as is" without warranties of any kind. We are not liable for:

• Any medical decisions made based on app information
• Loss of data due to device failure or user error
• Inaccuracies in vaccination schedules
• Missed appointments or vaccinations
• Any damages resulting from use of the app

You use this app at your own risk. We strongly recommend consulting healthcare professionals for all medical decisions.''',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('7. Updates and Changes', Icons.system_update),
        const SizedBox(height: 12),
        const Text(
          'We reserve the right to modify these Terms of Use at any time. Continued use of the app after changes constitutes acceptance of the new terms.',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
        const SizedBox(height: 20),
        
        _buildSection('8. Contact Information', Icons.contact_page),
        const SizedBox(height: 12),
        const Text(
          'For questions about these Terms of Use:\n\nEmail: legal@trackmyshots.app\nWebsite: www.trackmyshots.app',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildContactContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0066B3), Color(0xFF4AA5D9)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            children: [
              Icon(Icons.contact_support, size: 64, color: Colors.white),
              SizedBox(height: 16),
              Text(
                'We\'re Here to Help!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Have questions or feedback? We\'d love to hear from you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        
        _buildContactMethod(
          Icons.email,
          'Email Support',
          'support@trackmyshots.app',
          'Send us an email anytime',
        ),
        const SizedBox(height: 16),
        
        _buildContactMethod(
          Icons.bug_report,
          'Report a Bug',
          'bugs@trackmyshots.app',
          'Help us improve the app',
        ),
        const SizedBox(height: 16),
        
        _buildContactMethod(
          Icons.lightbulb_outline,
          'Feature Requests',
          'feedback@trackmyshots.app',
          'Suggest new features',
        ),
        const SizedBox(height: 16),
        
        _buildContactMethod(
          Icons.language,
          'Website',
          'www.trackmyshots.app',
          'Visit our website for more info',
        ),
        const SizedBox(height: 32),
        
        const Text(
          'Response Time',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'We typically respond to inquiries within 24-48 hours during business days. For urgent medical concerns, please contact your healthcare provider immediately.',
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF0066B3)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0066B3),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod(IconData icon, String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0066B3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0066B3)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0066B3),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum SupportPageType {
  help,
  privacy,
  terms,
  contact,
}
