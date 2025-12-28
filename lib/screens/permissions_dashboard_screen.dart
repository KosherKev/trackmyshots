import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trackmyshots/theme/app_theme.dart';

class PermissionsDashboardScreen extends StatefulWidget {
  const PermissionsDashboardScreen({super.key});

  @override
  State<PermissionsDashboardScreen> createState() => _PermissionsDashboardScreenState();
}

class _PermissionsDashboardScreenState extends State<PermissionsDashboardScreen> with WidgetsBindingObserver {
  bool _notificationsGranted = false;
  bool _batteryOptimizationIgnored = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    setState(() => _isLoading = true);
    
    final notificationStatus = await Permission.notification.status;
    final batteryStatus = await Permission.ignoreBatteryOptimizations.status;

    if (mounted) {
      setState(() {
        _notificationsGranted = notificationStatus.isGranted;
        // Battery optimization: isGranted means it is IGNORING optimizations (good for us)
        _batteryOptimizationIgnored = batteryStatus.isGranted;
        _isLoading = false;
      });
    }
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isPermanentlyDenied) {
      if (mounted) openAppSettings();
    } else {
      _checkPermissions();
    }
  }

  Future<void> _requestBatteryPermission() async {
    final status = await Permission.ignoreBatteryOptimizations.request();
    if (status.isPermanentlyDenied) {
      if (mounted) openAppSettings();
    } else {
      _checkPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Permissions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildPermissionCard(
                    context,
                    title: 'Notifications',
                    description: 'Required to send you timely reminders for upcoming vaccinations and appointments.',
                    icon: Icons.notifications_active_outlined,
                    isGranted: _notificationsGranted,
                    onAction: _requestNotificationPermission,
                  ),
                  const SizedBox(height: 16),
                  _buildPermissionCard(
                    context,
                    title: 'Ignore Battery Optimization',
                    description: 'Highly Recommended. Prevents the system from delaying or cancelling reminders to save battery.',
                    icon: Icons.battery_alert_outlined,
                    isGranted: _batteryOptimizationIgnored,
                    onAction: _requestBatteryPermission,
                    isCritical: false, // Optional but recommended
                  ),
                  const SizedBox(height: 32),
                  if (!_notificationsGranted || !_batteryOptimizationIgnored)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Some features may not work correctly without these permissions.',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App Permissions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDark,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage permissions to ensure TrackMyShots works perfectly.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildPermissionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required bool isGranted,
    required VoidCallback onAction,
    bool isCritical = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isGranted 
                      ? AppTheme.success.withOpacity(0.1) 
                      : (isCritical ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isGranted 
                      ? AppTheme.success 
                      : (isCritical ? Colors.red : Colors.orange),
                  size: 24,
                ),
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
                    const SizedBox(height: 4),
                    Text(
                      isGranted ? 'Active' : 'Action Needed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isGranted 
                            ? AppTheme.success 
                            : (isCritical ? Colors.red : Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isGranted)
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCritical ? Colors.red : Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Enable'),
                )
              else
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.success,
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
