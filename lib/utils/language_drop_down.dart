import 'package:flutter/material.dart';

class LanguageDropdown extends StatefulWidget {
  final Locale selectedLocale;
  final Function(Locale) onLocaleChange;
  final Color color;

  const LanguageDropdown({
    required this.selectedLocale,
    required this.onLocaleChange,
    this.color = const Color.fromARGB(255, 215, 220, 227),
    super.key,
  });

  @override
  LanguageDropdownState createState() => LanguageDropdownState();
}

class LanguageDropdownState extends State<LanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: widget.selectedLocale,
      dropdownColor: widget.color,
      onChanged: (Locale? newValue) {
        if (newValue != null) {
          widget.onLocaleChange(newValue);
        }
      },
      items: [
        DropdownMenuItem(
          value: Locale('en', ''),
          child: Text(
            'English',
            style: TextStyle(color: const Color.fromARGB(255, 27, 24, 24)),
          ),
        ),
        DropdownMenuItem(
          value: Locale('ru', ''),
          child: Text(
            'Русский',
            style: TextStyle(color: const Color.fromARGB(255, 18, 18, 18)),
          ),
        ),
        DropdownMenuItem(
          value: Locale('kk', ''),
          child: Text(
            'Қазақша',
            style: TextStyle(color: const Color.fromARGB(255, 18, 18, 18)),
          ),
        ),
      ],
    );
  }
}
