import 'package:edu_lab/app_localizations.dart';
import 'package:edu_lab/main.dart';
import 'package:edu_lab/services/auth_service.dart';
import 'package:edu_lab/components/shared/language_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late Locale _selectedLocale;
  final AuthService _authService = AuthService();
  bool _isButtonEnabled = false;

  void _changeLanguage(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
    MyApp.setLocale(context, locale);
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _selectedLocale = MyApp.getLocale(context) ?? Locale('kk', '');
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  void _login() async {
    final response = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (response.success == true) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.errorMessage ?? '')));
    }
  }

  void _register() async {
    final response = await _authService.register(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (response.success == true) {
      context.go('/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.errorMessage ?? '')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('title')),
        backgroundColor: Colors.blueAccent,
        actions: [
          LanguageDropdown(
            selectedLocale: _selectedLocale,
            onLocaleChange: _changeLanguage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: localizations.translate('email'),
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: localizations.translate('password'),
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _login : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 30, 151, 139),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                localizations.translate('login'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _register : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 39, 96, 219),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                localizations.translate('register'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            SizedBox(height: 32.0),
            Divider(),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Image.asset('assets/google_logo.png', height: 24.0),
              label: Text(
                localizations.translate('withGoogle'),
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 25, 0, 29),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
