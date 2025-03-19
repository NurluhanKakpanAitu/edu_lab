import 'package:flutter/material.dart';

class LanguageDropdown extends StatefulWidget {
  final Locale selectedLocale;
  final Function(Locale) onLocaleChange;

  const LanguageDropdown({
    required this.selectedLocale,
    required this.onLocaleChange,
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
      icon: Icon(Icons.language, color: Colors.white),
      dropdownColor: Colors.blueAccent,
      onChanged: (Locale? newValue) {
        if (newValue != null) {
          widget.onLocaleChange(newValue);
        }
      },
      items: [
        DropdownMenuItem(
          value: Locale('en', ''),
          child: Text('English', style: TextStyle(color: Colors.white)),
        ),
        DropdownMenuItem(
          value: Locale('ru', ''),
          child: Text('Русский', style: TextStyle(color: Colors.white)),
        ),
        DropdownMenuItem(
          value: Locale('kk', ''),
          child: Text('Қазақша', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
