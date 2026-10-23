import 'package:flutter/material.dart';
import 'package:workify_prototype/loginscreen/signin_screen.dart';

class QuestionScreenOne extends StatefulWidget {
  const QuestionScreenOne({super.key});

  @override
  State<QuestionScreenOne> createState() {
    return _QuestionScreenOneState();
  }
}

class _QuestionScreenOneState extends State<QuestionScreenOne> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<Map<String, dynamic>> introPages = [
    {
      'icon': Icons.search_rounded,
      'title': 'Find the Right Service',
      'description': 'Discover services you need, explore prices, '
          'and find the right person for the job.',
    },
    {
      'icon': Icons.work_outline_rounded,
      'title': 'Turn Skills into Opportunities',
      'description': 'Showcase your skills, publish your services, '
          'and set your own prices on Workify.',
    },
    {
      'icon': Icons.handshake_outlined,
      'title': 'Connect and Get Started',
      'description': 'Connect with people, request services, '
          'and turn your needs and skills into opportunities.',
    },
  ];

  void _nextPage() {
    if (currentPage < introPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workify'),
        actions: [
          TextButton(
            onPressed: _goToLogin,
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: introPages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = introPages[index];

                  return _buildIntroPage(
                    icon: page['icon'] as IconData,
                    title: page['title'] as String,
                    description: page['description'] as String,
                  );
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                introPages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? const Color(0xFF087BFA)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    currentPage == introPages.length - 1
                        ? 'Get Started'
                        : 'Next',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroPage({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5FF),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Icon(
              icon,
              size: 80,
              color: const Color(0xFF087BFA),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
