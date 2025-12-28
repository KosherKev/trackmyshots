import 'package:flutter/material.dart';

/// Shared card widget used across Educational Resources, Progress & Feedback, and Reminders screens
/// Ensures consistent sizing, styling, and spacing throughout the app
class StandardCard extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;
  final bool centerText;

  const StandardCard({
    super.key,
    required this.text,
    this.onTap,
    this.leading,
    this.trailing,
    this.centerText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: centerText ? TextAlign.center : TextAlign.left,
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 16),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Standard container for screens with dark blue gradient background
class StandardScreenContainer extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;

  const StandardScreenContainer({
    super.key,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF003D6B), // Dark navy
            Color(0xFF002447), // Darker navy
          ],
        ),
      ),
      child: ListView(
        padding: padding ?? const EdgeInsets.all(16),
        children: children,
      ),
    );
  }
}
