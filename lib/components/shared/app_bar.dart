import 'package:flutter/material.dart';
import 'package:edu_lab/components/shared/language_drop_down.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Locale selectedLocale;
  final Function(Locale) onLocaleChange;
  final VoidCallback? onBackButtonPressed; // Nullable callback for back button

  const CustomAppBar({
    super.key,
    required this.title,
    required this.selectedLocale,
    required this.onLocaleChange,
    this.onBackButtonPressed, // Optional parameter for back button
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          onBackButtonPressed != null
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBackButtonPressed,
              )
              : null, // Show back button only if onBackButtonPressed is provided
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
