import 'package:flutter/material.dart';

/// Utility class for displaying various types of [SnackBar] messages.
///
/// This class centralizes the logic for showing success, error, and info
/// messages to the user, ensuring a consistent look and feel across the application.
/// It uses a private constructor to prevent instantiation.
class SnackbarUtils {
  SnackbarUtils._();

  static const _borderRadius = 8.0;
  static const _iconSpacing = 12.0;
  static const _fontSize = 14.0;

  /// Displays a success [SnackBar] with a green background and a check icon.
  ///
  /// The [message] is the text to be displayed.
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    );
  }

  /// Displays an error [SnackBar] with a red background and an error icon.
  ///
  /// The [message] is the text to be displayed.
  /// This snackbar includes an 'OK' action button by default.
  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.error_outline,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 4),
      showAction: true,
    );
  }

  /// Displays an info [SnackBar] with a blue background and an info icon.
  ///
  /// The [message] is the text to be displayed.
  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline,
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 3),
    );
  }

  /// Internal helper method to display a custom [SnackBar].
  ///
  /// This method configures the appearance and behavior of the snackbar,
  /// including its [message], [icon], [backgroundColor], [duration],
  /// and whether to show an 'OK' [action] button.
  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Duration duration,
    bool showAction = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: _iconSpacing),
            Expanded(
              child: Text(message, style: const TextStyle(fontSize: _fontSize)),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        action: showAction
            ? SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: messenger.hideCurrentSnackBar,
              )
            : null,
      ),
    );
  }
}
