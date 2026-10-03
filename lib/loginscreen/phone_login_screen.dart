import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart';
import 'signin_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController phoneController =
      TextEditingController(text: '+962');
  final TextEditingController codeController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? _verificationId;
  int? _resendToken;
  int _secondsLeft = 0;
  Timer? _timer;

  bool get codeSent => _verificationId != null;

  static const Color blue = Color(0xFF075DFF);
  static const Color cyan = Color(0xFF00D8D8);
  static const Color textDark = Color(0xFF081B3A);
  static const Color textGrey = Color(0xFF72809B);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  Future<void> _sendCode() async {
    final phone = phoneController.text.replaceAll(' ', '').trim();

    if (!phone.startsWith('+') || phone.length < 10) {
      _showMessage('Enter your number with country code, e.g. +962790000000');
      return;
    }

    setState(() => isLoading = true);

    try {
      await _authService.sendPhoneCode(
        phoneNumber: phone,
        resendToken: _resendToken,
        onCodeSent: (verificationId, resendToken) {
          if (!mounted) return;
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken;
            isLoading = false;
          });
          _startTimer();
          _showMessage('Code sent to $phone');
        },
        onError: (e) {
          debugPrint('FirebaseAuthException: ${e.code} ${e.message}');
          if (!mounted) return;
          setState(() => isLoading = false);
          _showMessage(e.message ?? 'Could not send the code');
        },
        onAutoVerified: (user) {
          if (!mounted || user == null) return;
          _goHome();
        },
      );
    } catch (e) {
      debugPrint('sendCode error: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
      _showMessage('Could not send the code');
    }
  }

  Future<void> _verifyCode() async {
    final code = codeController.text.trim();

    if (code.length != 6) {
      _showMessage('Enter the 6-digit code');
      return;
    }

    setState(() => isLoading = true);

    try {
      final user = await _authService.verifyPhoneCode(
        verificationId: _verificationId!,
        smsCode: code,
      );
      if (!mounted || user == null) return;
      _goHome();
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} ${e.message}');
      if (!mounted) return;
      if (e.code == 'invalid-verification-code') {
        _showMessage('Wrong code, please try again');
      } else {
        _showMessage(e.message ?? 'Verification failed');
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _changeNumber() {
    _timer?.cancel();
    setState(() {
      _verificationId = null;
      _secondsLeft = 0;
      codeController.clear();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  Widget _gradientButton({
    required String label,
    required VoidCallback? onTap,
  }) {
    return Container(
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
          onTap: onTap,
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
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
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
                      codeSent
                          ? Icons.sms_outlined
                          : Icons.phone_android_rounded,
                      size: 44,
                      color: blue,
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// Title
                  Text(
                    codeSent ? 'Enter the Code' : 'Login with Phone',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    codeSent
                        ? 'We sent a 6-digit code to\n${phoneController.text.trim()}'
                        : 'Enter your phone number and we will\nsend you a verification code.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: textGrey,
                    ),
                  ),

                  const SizedBox(height: 32),

                  if (!codeSent) ...[
                    /// Phone number
                    CustomTextField(
                      controller: phoneController,
                      label: 'Phone Number',
                      hint: '+962 79 000 0000',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 28),
                    _gradientButton(
                      label: 'Send Code',
                      onTap: isLoading ? null : _sendCode,
                    ),
                  ] else ...[
                    /// OTP code
                    CustomTextField(
                      controller: codeController,
                      label: 'Verification Code',
                      hint: '123456',
                      icon: Icons.sms_outlined,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 28),
                    _gradientButton(
                      label: 'Verify & Login',
                      onTap: isLoading ? null : _verifyCode,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed:
                          (_secondsLeft > 0 || isLoading) ? null : _sendCode,
                      child: Text(
                        _secondsLeft > 0
                            ? 'Resend code in $_secondsLeft s'
                            : 'Resend code',
                        style: TextStyle(
                          color: _secondsLeft > 0 ? textGrey : blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: isLoading ? null : _changeNumber,
                      child: const Text(
                        'Change phone number',
                        style: TextStyle(
                          color: textGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 50),

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
