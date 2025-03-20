import 'package:flutter/material.dart';
import 'package:edu_lab/components/language_drop_down.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Locale selectedLocale;
  final Function(Locale) onLocaleChange;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.selectedLocale,
    required this.onLocaleChange,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      elevation: 4,
      actions: [
        LanguageDropdown(
          selectedLocale: selectedLocale,
          onLocaleChange: onLocaleChange,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
