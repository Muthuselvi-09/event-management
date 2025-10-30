import 'package:flutter/material.dart';

void main() => runApp(const EventraApp());

class EventraApp extends StatelessWidget {
  const EventraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const SplashAndOnboarding(),
    );
  }
}

//----------------------------------------------------------
// Splash + Onboarding Controller
//----------------------------------------------------------
class SplashAndOnboarding extends StatefulWidget {
  const SplashAndOnboarding({super.key});

  @override
  State<SplashAndOnboarding> createState() => _SplashAndOnboardingState();
}

class _SplashAndOnboardingState extends State<SplashAndOnboarding> {
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _showOnboarding = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showOnboarding
          ? const OnboardingScreen()
          : const SplashScreen(),
    );
  }
}

//----------------------------------------------------------
// Splash Screen
//----------------------------------------------------------
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
            boxShadow: const [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              'assets/codingrim_logo.webp',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

//----------------------------------------------------------
// Onboarding Screen
//----------------------------------------------------------
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardPageData> pages = [
    _OnboardPageData(
      image: 'assets/woocommerce_logo.png',
      title: 'Create & Manage Events',
      description: 'Quickly add events, schedules, and manage attendees.',
    ),
    _OnboardPageData(
      image: 'assets/zhacommerce_logo.png',
      title: 'Share & Track',
      description: 'Share event details and track registrations easily.',
    ),
  ];

  void _goNext() {
    if (_currentPage < pages.length - 1) {
      _controller.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skipToEnd() {
    _controller.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pages.length, (index) {
        bool active = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? Colors.indigo : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bottomBarHeight = 110.0;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                final p = pages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              p.image!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        p.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: bottomBarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: _skipToEnd,
                  child: Text('Skip', style: TextStyle(color: Colors.grey.shade800)),
                ),
                const Spacer(),
                _buildDots(),
                const Spacer(),
                ElevatedButton(
                  onPressed: _goNext,
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(_currentPage == pages.length - 1 ? 'Get Started' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//----------------------------------------------------------
// Page Data Model
//----------------------------------------------------------
class _OnboardPageData {
  final String? image;
  final String title;
  final String description;

  _OnboardPageData({
    this.image,
    required this.title,
    required this.description,
  });
}

//----------------------------------------------------------
// Home Page
//----------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eventra - Home')),
      body: const Center(
        child: Text(
          'Welcome to Eventra!\nYour event management app.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
