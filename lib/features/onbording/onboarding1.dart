import 'package:chasingharmony_fluttere/features/onbording/welcomescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboarding1Screen extends StatefulWidget {
  const Onboarding1Screen({super.key});

  @override
  State<Onboarding1Screen> createState() => _Onboarding1ScreenState();
}

class _Onboarding1ScreenState extends State<Onboarding1Screen> {
  static const Color _bgTop = Color(0xFF0C0118);
  static const Color _bgBottom = Color(0xFF1E0635);
  static const Color _dotInactive = Color(0xFF3D2A5A);
  static const Color _gradBlue = Color(0xFF3B82F6);
  static const Color _gradPurple = Color(0xFF8B5CF6);
  static const Color _bodyColor = Color(0xFFB8B8C8);

  late final PageController _pageController;
  int _currentPage = 0;

  static const List<_PageData> _pages = [
    _PageData(
      imagePath: 'assets/image/image 1.png',
      titleKey: 'onboarding.page1Title',
      bodyKey: 'onboarding.page1Body',
      imageTopInset: 88,
      imageWidth: 226,
      imageHeight: 226,
    ),
    _PageData(
      imagePath: 'assets/image/image 3.png',
      titleKey: 'onboarding.page2Title',
      bodyKey: 'onboarding.page2Body',
      imageTopInset: 44,
      imageWidth: 306,
      imageHeight: 306,
    ),
    _PageData(
      imagePath: 'assets/image/image 4.png',
      titleKey: 'onboarding.page3Title',
      bodyKey: 'onboarding.page3Body',
      useFullBleedImage: true,
      imageScale: 0.82,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _skip() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => WelcomeScreen()),
  );

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _skip();
    }
  }

  void _back() => _pageController.previousPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/backgroundimage.png', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _bgTop.withValues(alpha: 0.78),
                  _bgBottom.withValues(alpha: 0.92),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _TopBar(onSkip: _skip),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (_, i) => _OnboardingPage(data: _pages[i]),
                  ),
                ),
                _BottomControls(
                  currentPage: _currentPage,
                  pageCount: _pages.length,
                  onBack: _back,
                  onNext: _next,
                  dotInactive: _dotInactive,
                  gradBlue: _gradBlue,
                  gradPurple: _gradPurple,
                  bodyColor: _bodyColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageData {
  const _PageData({
    required this.imagePath,
    required this.titleKey,
    required this.bodyKey,
    this.useFullBleedImage = false,
    this.imageTopInset = 36,
    this.imageWidth = 220,
    this.imageHeight = 220,
    this.imageScale = 1,
  });

  final String imagePath;
  final String titleKey;
  final String bodyKey;
  final bool useFullBleedImage;
  final double imageTopInset;
  final double imageWidth;
  final double imageHeight;
  final double imageScale;
}

// ── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
            ).createShader(b),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 22,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onSkip,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFFB8B8C8),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page content ─────────────────────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _PageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: Stack(
        children: [
          if (data.useFullBleedImage)
            Positioned.fill(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Transform.scale(
                    scale: data.imageScale,
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      data.imagePath,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, error, stackTrace) => const Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: Color(0xFF8B5CF6),
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF05010C).withValues(alpha: 0.18),
                          const Color(0xFF05010C).withValues(alpha: 0.88),
                        ],
                        stops: const [0.0, 0.54, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Positioned(
              top: data.imageTopInset,
              left: 0,
              right: 0,
              child: Center(
                child: _ImageBubble(
                  imagePath: data.imagePath,
                  width: data.imageWidth,
                  height: data.imageHeight,
                ),
              ),
            ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data.titleKey.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 14),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${'app.title'.tr} ',
                        style: const TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: data.bodyKey.tr,
                        style: const TextStyle(
                          color: Color(0xFFE3DDED),
                          fontSize: 13,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageBubble extends StatelessWidget {
  const _ImageBubble({
    required this.imagePath,
    required this.width,
    required this.height,
  });

  final String imagePath;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF3B82F6).withValues(alpha: 0.18),
            const Color(0xFF8B5CF6).withValues(alpha: 0.10),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (_, error, stackTrace) => Icon(
            Icons.image_outlined,
            color: Color(0xFF8B5CF6),
            size: 80,
          ),
        ),
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.currentPage,
    required this.pageCount,
    required this.onBack,
    required this.onNext,
    required this.dotInactive,
    required this.gradBlue,
    required this.gradPurple,
    required this.bodyColor,
  });

  final int currentPage;
  final int pageCount;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final Color dotInactive;
  final Color gradBlue;
  final Color gradPurple;
  final Color bodyColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      child: Column(
        children: [
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pageCount, (i) {
              final active = i == currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: active ? 24 : 8,
                decoration: BoxDecoration(
                  gradient: active
                      ? LinearGradient(colors: [gradBlue, gradPurple])
                      : null,
                  color: active ? null : dotInactive,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
          const SizedBox(height: 22),
          // Back / Next row
          Row(
            children: [
              AnimatedOpacity(
                opacity: currentPage > 0 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: currentPage == 0,
                  child: _CircleBackButton(onTap: onBack),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GradientNextButton(
                  label: currentPage == pageCount - 1
                      ? 'onboarding.getStarted'.tr
                      : 'onboarding.next'.tr,
                  onTap: onNext,
                  gradBlue: gradBlue,
                  gradPurple: gradPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF3D2A5A), width: 1.5),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class _GradientNextButton extends StatelessWidget {
  const _GradientNextButton({
    required this.label,
    required this.onTap,
    required this.gradBlue,
    required this.gradPurple,
  });

  final String label;
  final VoidCallback onTap;
  final Color gradBlue;
  final Color gradPurple;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [gradBlue, gradPurple]),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
