import 'package:edu_lab/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key, required this.locale});

  final String locale;

  @override
  BottomNavbarState createState() => BottomNavbarState();
}

class BottomNavbarState extends State<BottomNavbar> {
  int currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.locale == 'kk') {
      currentIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: localizations.translate('home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: localizations.translate('profile'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: localizations.translate('discussions'),
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blueAccent,
      onTap: (index) {
        if (index == 1) {
          context.go('/profile');
          setCurrentIndex(index);
        } else if (index == 2) {
          context.go('/discussion');
          setCurrentIndex(index);
        } else {
          context.go('/home');
          setCurrentIndex(index);
        }
      },
    );
  }
}
