import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'loginscreen/signin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color blue = Color(0xFF075DFF);
  static const Color textDark = Color(0xFF081B3A);
  static const Color textGrey = Color(0xFF72809B);

  Future<void> _logout(BuildContext context) async {
    await AuthService().signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final name =
        (user?.displayName?.isNotEmpty ?? false) ? user!.displayName! : 'there';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FCFF),
        elevation: 0,
        title: const Text(
          'Workify',
          style: TextStyle(
            color: blue,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded, color: textDark),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $name 👋',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              user?.email ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
