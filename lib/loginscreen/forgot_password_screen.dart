import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'signin_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController emailController =
      TextEditingController(text: widget.initialEmail);

  bool isLoading = false;
  bool emailSent = false;
  final AuthService _authService = AuthService();

  static const Color blue = Color(0xFF075DFF);
  static const Color cyan = Color(0xFF00D8D8);
  static const Color textDark = Color(0xFF081B3A);
  static const Color textGrey = Color(0xFF72809B);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _sendResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Please enter your email');
      return;
    }

    setState(() => isLoading = true);

    try {
      await _authService.resetPassword(email);
      if (!mounted) return;
      setState(() => emailSent = true);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code}');
      if (!mounted) return;
      _showMessage(e.message ?? 'Something went wrong');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      body: SafeArea(
        child: Stack(
          children: [
            /// Decorative background
            Positioned(
              top: -100,
              left: -120,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      cyan.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 100,
              right: -130,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: blue.withValues(alpha: 0.04),
                ),
              ),
            ),

            /// Main content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Column(
                children: [
                  /// Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: textDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Icon
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: blue.withValues(alpha: 0.08),
                    ),
                    child: Icon(
                      emailSent
                          ? Icons.mark_email_read_outlined
                          : Icons.lock_reset_rounded,
                      size: 44,
                      color: blue,
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Title
                  Text(
                    emailSent ? 'Check Your Email' : 'Forgot Password?',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    emailSent
                        ? 'We sent a password reset link to\n${emailController.text.trim()}'
                        : 'Enter your email and we will send you\na link to reset your password.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: textGrey,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Email field (hidden after sending)
                  if (!emailSent) ...[
                    CustomTextField(
                      controller: emailController,
                      label: 'Email Address',
                      hint: 'john.doe@example.com',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 28),
                  ],

                  /// Main button
                  Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF075DFF),
                          Color(0xFF008DF5),
                          Color(0xFF00DDD3),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: blue.withValues(alpha: 0.25),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: isLoading
                            ? null
                            : emailSent
                                ? () => Navigator.pop(context)
                                : _sendResetEmail,
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  emailSent
                                      ? 'Back to Login'
                                      : 'Send Reset Link',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  /// Resend
                  if (emailSent) ...[
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: isLoading ? null : _sendResetEmail,
                      child: const Text(
                        "Didn't get the email? Resend",
                        style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 60),

                  /// Bottom decorative waves
                  const WorkifyWaves(),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
