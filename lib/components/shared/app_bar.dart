import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackButtonPressed; // Nullable callback for back button

  const CustomAppBar({
    super.key,
    required this.title,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
