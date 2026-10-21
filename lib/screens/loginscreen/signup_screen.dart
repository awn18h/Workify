import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;
  final AuthService _authService = AuthService();

  static const Color darkBlue = Color(0xFF063A9B);
  static const Color blue = Color(0xFF075DFF);
  static const Color cyan = Color(0xFF00D8D8);
  static const Color textDark = Color(0xFF081B3A);
  static const Color textGrey = Color(0xFF72809B);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match');
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
      );
      if (!mounted) return;
      _showMessage('Account created for ${user?.email}');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code}');
      if (!mounted) return;
      _showMessage(e.message ?? 'Sign up failed');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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

                  /// Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 5),

                  /// Workify name
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          darkBlue,
                          blue,
                          cyan,
                        ],
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'Workify',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Title
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Join Workify and start your\ncareer journey today.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: textGrey,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Full name
                  CustomTextField(
                    controller: nameController,
                    label: 'Full Name',
                    hint: 'John Doe',
                    icon: Icons.person_outline_rounded,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 16),

                  /// Email
                  CustomTextField(
                    controller: emailController,
                    label: 'Email Address',
                    hint: 'john.doe@example.com',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  /// Password
                  CustomTextField(
                    controller: passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    icon: Icons.lock_outline_rounded,
                    obscureText: obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: textGrey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Confirm password
                  CustomTextField(
                    controller: confirmPasswordController,
                    label: 'Confirm Password',
                    hint: '••••••••',
                    icon: Icons.lock_reset_rounded,
                    obscureText: obscureConfirmPassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: textGrey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Sign up button
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
                        onTap: isLoading ? null : _signUp,
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
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create Account',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Back to login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: textGrey,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: blue,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

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
