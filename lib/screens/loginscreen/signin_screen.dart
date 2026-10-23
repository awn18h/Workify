import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workify_prototype/screens/nav_bar.dart';
import '../../services/auth_service.dart';
import 'signup_screen.dart';
import '../home_screen.dart';
import 'forgot_password_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'phone_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;
  final AuthService _authService = AuthService();

  static const Color darkBlue = Color(0xFF063A9B);
  static const Color blue = Color(0xFF075DFF);
  static const Color cyan = Color(0xFF00D8D8);
  static const Color textDark = Color(0xFF081B3A);
  static const Color textGrey = Color(0xFF72809B);

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await AuthService.login(

        email: email,
        password: password,
      );
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavBar()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => isLoading = true);

    try {
      final user = await AuthService.signInWithGoogle(context);
      if (!mounted || user == null) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } on GoogleSignInException catch (e) {
      debugPrint('GoogleSignInException: ${e.code} ${e.description}');
      if (!mounted) return;
      if (e.code != GoogleSignInExceptionCode.canceled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.description ?? 'Google sign in failed')),
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Google sign in failed')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                  const SizedBox(height: 15),

                  /// Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
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
                        fontSize: 46,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'JOBS TODAY • BRIGHTER TOMORROW',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textGrey.withValues(alpha: 0.8),
                      letterSpacing: 2.2,
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// Title
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Sign in to continue your career journey\nwith Workify.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: textGrey,
                    ),
                  ),

                  const SizedBox(height: 32),

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

                  const SizedBox(height: 12),

                  /// Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(
                              initialEmail: emailController.text.trim(),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// Login button
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
                        onTap: isLoading ? null : _login,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
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

                  const SizedBox(height: 32),

                  /// Divider
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFDCE4F0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 11,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFDCE4F0),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Google + Apple
                  Row(
                    children: [
                      Expanded(
                        child: SocialButton(
                          title: 'Google',
                          onTap: isLoading ? () {} : _loginWithGoogle,
                          child: const Text(
                            'G',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4285F4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child:

                            /// Phone
                            SocialButton(
                          title: 'Phone',
                          onTap: () {
                            // Navigator.push(
                              // context,
                              // MaterialPageRoute(
                                // builder: (context) => const PhoneLoginScreen(),
                              // ),
                            // );
                          },
                          child: const Icon(
                            Icons.phone_android_rounded,
                            size: 26,
                            color: Color(0xFF075DFF),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Create account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: textGrey,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Create Account',
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

/// ================================
/// CUSTOM TEXT FIELD
/// ================================

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E9F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(
          color: Color(0xFF081B3A),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 17,
            horizontal: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(11),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F6FD),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF70829D),
                size: 23,
              ),
            ),
          ),
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF75839C),
            fontSize: 15,
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF17223B),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

/// ================================
/// SOCIAL LOGIN BUTTON
/// ================================

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.title,
    required this.child,
    required this.onTap,
  });

  final String title;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFDDE6F1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF081B3A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================================
/// BOTTOM WAVE DESIGN
/// ================================

class WorkifyWaves extends StatelessWidget {
  const WorkifyWaves({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: CustomPaint(
        painter: WavePainter(),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// Light wave
    final lightPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF2A8BFF),
          Color(0xFF42E5DD),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final lightPath = Path();

    lightPath.moveTo(0, size.height * 0.45);

    lightPath.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.10,
      size.width * 0.50,
      size.height * 0.60,
    );

    lightPath.quadraticBezierTo(
      size.width * 0.78,
      size.height,
      size.width,
      size.height * 0.40,
    );

    lightPath.lineTo(size.width, size.height);
    lightPath.lineTo(0, size.height);
    lightPath.close();

    canvas.drawPath(lightPath, lightPaint);

    /// Dark wave
    final darkPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF0739CE),
          Color(0xFF076DFF),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final darkPath = Path();

    darkPath.moveTo(0, size.height * 0.65);

    darkPath.quadraticBezierTo(
      size.width * 0.22,
      size.height * 0.35,
      size.width * 0.48,
      size.height * 0.80,
    );

    darkPath.quadraticBezierTo(
      size.width * 0.72,
      size.height * 1.05,
      size.width,
      size.height * 0.58,
    );

    darkPath.lineTo(size.width, size.height);
    darkPath.lineTo(0, size.height);
    darkPath.close();

    canvas.drawPath(darkPath, darkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
