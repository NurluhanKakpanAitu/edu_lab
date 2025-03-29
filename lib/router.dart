import 'package:edu_lab/screens/auth_screen.dart';
import 'package:edu_lab/screens/course_screen.dart';
import 'package:edu_lab/screens/home_screen.dart';
import 'package:edu_lab/screens/module_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/profile_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/', // Указываем стартовую страницу

  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(
      path: '/course/:id', // Route for CourseScreen
      builder: (context, state) {
        final courseId = state.pathParameters['id']!;
        return CourseScreen(
          courseId: courseId,
        ); // Pass the course ID to the screen
      },
    ),
    GoRoute(
      path: '/module/:id', // Route for CourseScreen
      builder: (context, state) {
        final moduleId = state.pathParameters['id']!;
        return ModuleScreen(
          moduleId: moduleId,
        ); // Pass the course ID to the screen
      },
    ),
  ],
);
