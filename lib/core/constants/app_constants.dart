import 'package:flutter/foundation.dart'; // Para kReleaseMode

/// Global application constants, organized by domain.
///
/// This file centralizes fixed values and configurations that do not change
/// at runtime but may vary by environment (development/production).
abstract final class AppConstants {
  AppConstants._();

  /// Base URL for the API.
  ///
  /// Dynamically determined based on the application's build mode ([kReleaseMode]).
  /// Uses environment variables `API_BASE_URL_PROD` for production and
  /// `API_BASE_URL_DEV` for development, with provided default values.
  static String get apiBaseUrl {
    if (kReleaseMode) {
      return const String.fromEnvironment(
        'API_BASE_URL_PROD',
        defaultValue: 'https://api.empiricus.com.br',
      );
    } else {
      return const String.fromEnvironment(
        'API_BASE_URL_DEV',
        defaultValue: 'https://empiricus-app.empiricus.com.br/mock',
      );
    }
  }

  /// Timeout duration for HTTP requests.
  static const Duration apiTimeout = Duration(seconds: 15);

  /// Deeplink scheme for Android and iOS.
  static const String deepLinkScheme = 'empiricus';

  /// Deeplink host for Android and iOS.
  static const String deepLinkHost = 'app';
}
