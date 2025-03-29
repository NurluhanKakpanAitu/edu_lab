import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  BottomNavbarState createState() => BottomNavbarState();
}

class BottomNavbarState extends State<BottomNavbar> {
  int _getCurrentIndex(BuildContext context) {
    final String location =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    if (location.startsWith('/profile')) {
      return 1;
    } else {
      return 0; // Default to home
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Басты бет'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blueAccent,
      onTap: (index) {
        if (index == 1) {
          context.go('/profile');
        } else {
          context.go('/home');
        }
      },
    );
  }
}
