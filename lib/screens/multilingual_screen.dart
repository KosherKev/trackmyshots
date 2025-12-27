import 'package:flutter/material.dart';
import 'package:trackmyshots/theme/app_theme.dart';

class MultilingualScreen extends StatefulWidget {
  const MultilingualScreen({super.key});

  @override
  State<MultilingualScreen> createState() => _MultilingualScreenState();
}

class _MultilingualScreenState extends State<MultilingualScreen> {
  String selectedLanguage = 'English';

  final List<Map<String, String>> languages = [
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'Deutsch', 'code': 'de'},
    {'name': 'Italian', 'code': 'it'},
  ];

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
        title: const Text('Multilingual Support'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/reminders');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryLight,
              AppTheme.primaryBlue.withOpacity(0.6),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          children: languages.map((language) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildLanguageOption(
                language['name']!,
                language['code']!,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String languageName, String languageCode) {
    final isSelected = selectedLanguage == languageName;

    return InkWell(
      onTap: () {
        setState(() {
          selectedLanguage = languageName;
        });
        // TODO: Implement language change logic
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Container(
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryBlue,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              languageName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
