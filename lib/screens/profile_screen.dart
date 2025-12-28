import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/screens/support_screen.dart';
import 'package:trackmyshots/widgets/edit_child_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:trackmyshots/screens/support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // int _currentIndex = 1; // Managed by MainScreen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A9FCA), // Solid blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A9FCA),
        elevation: 0,
        // leading: Removed back button as it is a tab
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final childProfile = appState.currentChild;
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // User Profile Card
              _buildUserProfileCard(context, childProfile, appState),
              const SizedBox(height: 16),

              // Vaccination Progress Summary
              _buildProgressSummary(context, appState),
              const SizedBox(height: 24),

              // App Section Header
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildAppSection(context, appState),
              const SizedBox(height: 24),

              // Data Management Section Header
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'Data Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildDataSection(context, appState),
              const SizedBox(height: 24),

              // General Section Header
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'General',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildGeneralSection(context),
              
              const SizedBox(height: 100), // Space for bottom nav
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserProfileCard(
    BuildContext context,
    ChildProfile? child,
    AppState appState,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          if (child != null) {
            showDialog(
              context: context,
              builder: (context) => EditChildDialog(child: child),
            );
          }
        },
        child: Row(
          children: [
            // Profile Image/Circle
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF0066B3).withOpacity(0.1),
              child: Text(
                child?.name.substring(0, 1).toUpperCase() ?? 'E',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066B3),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child?.name ?? 'Emily Ross',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    child != null 
                        ? child.formattedAge
                        : 'Edit profile name, age and more',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSummary(BuildContext context, AppState appState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vaccination Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          
          // Overall Completion
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Completion',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${appState.overallCompletion.toInt()}%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066B3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: appState.overallCompletion / 100,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0066B3)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 20),
          
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatColumn(
                  Icons.check_circle,
                  '${appState.totalDosesCompleted}',
                  'Completed',
                  const Color(0xFF4CAF50),
                ),
              ),
              Container(width: 1, height: 50, color: const Color(0xFFE0E0E0)),
              Expanded(
                child: _buildStatColumn(
                  Icons.vaccines,
                  '${appState.totalDosesRequired}',
                  'Total Doses',
                  const Color(0xFF0066B3),
                ),
              ),
              Container(width: 1, height: 50, color: const Color(0xFFE0E0E0)),
              Expanded(
                child: _buildStatColumn(
                  Icons.medical_services,
                  '${appState.vaccines.length}',
                  'Vaccines',
                  const Color(0xFF0066B3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF757575),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAppSection(BuildContext context, AppState appState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications, color: Color(0xFF0066B3)),
            title: const Text(
              'Reminders',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () {
              Navigator.pushNamed(context, '/reminders');
            },
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.notifications_active, color: Color(0xFF0066B3)),
            title: const Text(
              'Push Notifications',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Get reminded about upcoming doses',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            trailing: Switch(
              value: appState.notificationsEnabled,
              onChanged: (value) {
                appState.toggleNotifications(value);
              },
              activeColor: const Color(0xFF0066B3),
            ),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.security, color: Color(0xFF0066B3)),
            title: const Text(
              'Permissions',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Manage app permissions',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () {
              Navigator.pushNamed(context, '/permissions');
            },
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFF0066B3)),
            title: const Text(
              'Language',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'English',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () {
              Navigator.pushNamed(context, '/multilingual');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection(BuildContext context, AppState appState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.file_upload, color: Color(0xFF0066B3)),
            title: const Text(
              'Export Data',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Backup your vaccination records',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () => _exportData(context, appState),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.file_download, color: Color(0xFF0066B3)),
            title: const Text(
              'Import Data',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Restore from backup',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () => _importData(context, appState),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.refresh, color: Color(0xFFFFA726)),
            title: const Text(
              'Reset to Sample Data',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'For testing purposes',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () => _resetToSampleData(context, appState),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Color(0xFFEF5350)),
            title: const Text(
              'Clear All Data',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Delete all records',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () => _clearAllData(context, appState),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline, color: Color(0xFF0066B3)),
            title: const Text(
              'Help & Support',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportScreen(type: SupportPageType.help),
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFF0066B3)),
            title: const Text(
              'About',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: Color(0xFF0066B3)),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportScreen(type: SupportPageType.privacy),
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: Color(0xFF0066B3)),
            title: const Text(
              'Terms of Use',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportScreen(type: SupportPageType.terms),
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.warning_amber_rounded, color: Color(0xFF0066B3)),
            title: const Text(
              'Medical Disclaimer',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () {
              Navigator.pushNamed(context, '/medical-disclaimer');
            },
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.contact_mail, color: Color(0xFF0066B3)),
            title: const Text(
              'Contact Us',
              style: TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF757575)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportScreen(type: SupportPageType.contact),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext context, AppState appState) async {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final password = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Encrypted Backup'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter a password to encrypt your backup file. You will need this password to restore it.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 4) {
                    return 'Password must be at least 4 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, passwordController.text);
              }
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );

    if (password != null && context.mounted) {
      try {
        await appState.exportEncryptedData(password);
        // share_plus handles the UI feedback for success usually (opens share sheet)
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Export failed: $e'),
              backgroundColor: const Color(0xFFEF5350),
            ),
          );
        }
      }
    }
  }

  Future<void> _importData(BuildContext context, AppState appState) async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        if (!context.mounted) return;

        final passwordController = TextEditingController();
        final formKey = GlobalKey<FormState>();

        final password = await showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Decrypt Backup'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter the password for this backup file.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_open),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context, passwordController.text);
                  }
                },
                child: const Text('Restore'),
              ),
            ],
          ),
        );

        if (password != null && context.mounted) {
          // Show loading
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );

          try {
            final success = await appState.importEncryptedData(file, password);
            
            if (context.mounted) {
              Navigator.pop(context); // Dismiss loading
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data restored successfully!'),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to restore data. File might be corrupted.'),
                    backgroundColor: Color(0xFFEF5350),
                  ),
                );
              }
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context); // Dismiss loading
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString().replaceAll('Exception: ', '')),
                  backgroundColor: const Color(0xFFEF5350),
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: $e'),
            backgroundColor: const Color(0xFFEF5350),
          ),
        );
      }
    }
  }

  Future<void> _resetToSampleData(BuildContext context, AppState appState) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Sample Data?'),
        content: const Text(
          'This will replace your current data with sample vaccination records.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA726),
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await appState.resetToSampleData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data reset to sample data'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    }
  }

  Future<void> _clearAllData(BuildContext context, AppState appState) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all vaccination records and settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await appState.clearAllData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All data has been cleared'),
          backgroundColor: Color(0xFFEF5350),
        ),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TrackMyShots',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.vaccines,
        size: 48,
        color: Color(0xFF0066B3),
      ),
      children: [
        const Text(
          'A comprehensive child immunization tracking application.',
        ),
      ],
    );
  }
}
