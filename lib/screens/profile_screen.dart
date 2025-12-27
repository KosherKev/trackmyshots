import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/theme/app_theme.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/models/models.dart';
import 'package:trackmyshots/widgets/edit_child_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(context),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final childProfile = appState.currentChild;
          
          return ListView(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            children: [
              // PRO Upgrade Card
              _buildProUpgradeCard(context),
              const SizedBox(height: 16),

              // User Profile Card
              _buildUserProfileCard(context, childProfile, appState),
              const SizedBox(height: 24),

              // Vaccination Progress Summary
              _buildProgressSummary(context, appState),
              const SizedBox(height: 24),

              // App Section
              _buildSectionHeader('App'),
              const SizedBox(height: 8),
              _buildAppSection(context, appState),
              const SizedBox(height: 24),

              // Data Management Section
              _buildSectionHeader('Data Management'),
              const SizedBox(height: 8),
              _buildDataSection(context, appState),
              const SizedBox(height: 24),

              // General Section
              _buildSectionHeader('General'),
              const SizedBox(height: 8),
              _buildGeneralSection(context),
              
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProUpgradeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: BoxDecoration(
        color: const Color(0xFF87CEEB),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Get Full Access',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Analyze your progress in detail, customize your goals and get support with reminders. Focus on your health with ad-free experience',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Try Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(
    BuildContext context,
    ChildProfile? child,
    AppState appState,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
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
            CircleAvatar(
              radius: 30,
              backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
              child: Text(
                child?.name.substring(0, 1) ?? 'C',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child?.name ?? 'Child Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    child != null 
                        ? '${child.formattedAge} old'
                        : 'Add child information',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSummary(BuildContext context, AppState appState) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vaccination Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Overall progress
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Completion',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: appState.overallCompletion / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          appState.overallCompletion == 100
                              ? AppTheme.success
                              : AppTheme.primaryBlue,
                        ),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${appState.overallCompletion.toInt()}%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Completed',
                '${appState.totalDosesCompleted}',
                AppTheme.success,
                Icons.check_circle,
              ),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              _buildStatItem(
                'Total Doses',
                '${appState.totalDosesRequired}',
                AppTheme.info,
                Icons.vaccines,
              ),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              _buildStatItem(
                'Vaccines',
                '${appState.vaccines.length}',
                AppTheme.primaryBlue,
                Icons.medical_services,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAppSection(BuildContext context, AppState appState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications, color: AppTheme.primaryBlue),
            title: const Text('Reminders'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(context, '/reminders');
            },
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active, color: AppTheme.primaryBlue),
            title: const Text('Push Notifications'),
            subtitle: const Text('Get reminded about upcoming doses'),
            value: appState.notificationsEnabled,
            onChanged: (value) {
              appState.toggleNotifications(value);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.language, color: AppTheme.primaryBlue),
            title: const Text('Language'),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.chevron_right),
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
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.upload_file, color: AppTheme.primaryBlue),
            title: const Text('Export Data'),
            subtitle: const Text('Backup your vaccination records'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _exportData(context, appState),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.download, color: AppTheme.primaryBlue),
            title: const Text('Import Data'),
            subtitle: const Text('Restore from backup'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _importData(context, appState),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.refresh, color: AppTheme.warning),
            title: const Text('Reset to Sample Data'),
            subtitle: const Text('For testing purposes'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _resetToSampleData(context, appState),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppTheme.error),
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete all records'),
            trailing: const Icon(Icons.chevron_right),
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
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline, color: AppTheme.primaryBlue),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppTheme.primaryBlue),
            title: const Text('About'),
            subtitle: const Text('Version 1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined, color: AppTheme.primaryBlue),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: AppTheme.primaryBlue),
            title: const Text('Terms of Use'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    // TODO: Implement more options
  }

  Future<void> _exportData(BuildContext context, AppState appState) async {
    final jsonData = await appState.exportData();
    if (jsonData != null) {
      // TODO: Share or save the JSON file
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data exported successfully!'),
          backgroundColor: AppTheme.success,
        ),
      );
      // For now, just show the data in a dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export Data'),
            content: SingleChildScrollView(
              child: Text(jsonData),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context, AppState appState) async {
    // TODO: Implement file picker to import JSON
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Import feature coming soon!'),
        backgroundColor: AppTheme.info,
      ),
    );
  }

  Future<void> _resetToSampleData(BuildContext context, AppState appState) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Sample Data?'),
        content: const Text(
          'This will replace your current data with sample vaccination records. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warning,
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
          backgroundColor: AppTheme.success,
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
          'This will permanently delete all vaccination records and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
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
          backgroundColor: AppTheme.error,
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
        color: AppTheme.primaryBlue,
      ),
      children: [
        const Text(
          'A comprehensive child immunization tracking application to help parents keep track of their children\'s vaccination schedules.',
        ),
      ],
    );
  }
}
