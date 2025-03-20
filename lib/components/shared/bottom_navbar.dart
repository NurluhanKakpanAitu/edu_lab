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
  int _getCurrentIndex(BuildContext context) {
    final String location =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    if (location.startsWith('/profile')) {
      return 1;
    } else if (location.startsWith('/discussion')) {
      return 2;
    } else {
      return 0; // Default to home
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final currentIndex = _getCurrentIndex(context);

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
        } else if (index == 2) {
          context.go('/discussion');
        } else {
          context.go('/home');
        }
      },
    );
  }
}
