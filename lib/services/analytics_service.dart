import 'package:flutter/foundation.dart';

/// Service to handle app analytics and event tracking.
/// Currently logs to console/debug output, but designed to easily swap in
/// Firebase Analytics, Mixpanel, or Amplitude later.
class AnalyticsService {
  // Singleton instance
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  /// Logs when a user views a specific screen
  Future<void> logScreenView({required String screenName}) async {
    _log('Screen View: $screenName');
    // TODO: Integrate FirebaseAnalytics.instance.logScreenView
  }

  /// Logs specific user interactions (button clicks, feature usage)
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    _log('Event: $name, Params: $parameters');
    // TODO: Integrate FirebaseAnalytics.instance.logEvent
  }

  /// Logs when a user clicks an affiliate/marketplace link
  Future<void> logMarketplaceClick({
    required String itemId,
    required String itemName,
    required String category,
    required String affiliateUrl,
  }) async {
    await logEvent(
      name: 'click_marketplace_item',
      parameters: {
        'item_id': itemId,
        'item_name': itemName,
        'category': category,
        'url': affiliateUrl,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Logs when a user views sponsored content
  Future<void> logSponsoredContentView({
    required String contentTitle,
    required String sponsorName,
  }) async {
    await logEvent(
      name: 'view_sponsored_content',
      parameters: {
        'content_title': contentTitle,
        'sponsor_name': sponsorName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  void _log(String message) {
    if (kDebugMode) {
      print('[Analytics] $message');
    }
  }
}
