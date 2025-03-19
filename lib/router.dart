import 'package:edu_lab/screens/auth_screen.dart';
import 'package:go_router/go_router.dart';
import 'screens/profile_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/', // Указываем стартовую страницу
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthScreen()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
  ],
);
