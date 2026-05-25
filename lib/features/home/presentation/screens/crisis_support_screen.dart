import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CrisisSupportScreen extends StatelessWidget {
  const CrisisSupportScreen({super.key});

  static const Color _accentRed = Color(0xFFEF4444);
  static const Color _disclaimerPurple = Color(0xFF8B5CF6);
  static const Color _cardBorder = Color(0xFF3A2150);

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  Future<void> _openWebsite(String url) async {
    final Uri uri = Uri.parse('https://$url');

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top + 12;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/Profile.png',
              fit: BoxFit.cover,
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, topPadding, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                    const SizedBox(width: 12),

                    const Text(
                      "Back to Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Important Notice
                _DashedBorderBox(
                  color: _accentRed,
                  radius: 16,
                  strokeWidth: 1,
                  dashLength: 6,
                  gapLength: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.error_outline,
                              color: _accentRed,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Important Notice",
                              style: TextStyle(
                                color: _accentRed,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "If you are in immediate danger, please call ",
                              ),
                              TextSpan(
                                text: "988",
                                style: TextStyle(
                                  color: _accentRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: " or "),
                              TextSpan(
                                text: "911",
                                style: TextStyle(
                                  color: _accentRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ". This app is not a substitute for emergency services. Get help now. You are not alone.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Disclaimer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _cardBorder,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.shield_outlined,
                            color: _disclaimerPurple,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Disclaimer:",
                            style: TextStyle(
                              color: _disclaimerPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(text: "CELYS AI "),
                            TextSpan(
                              text: "is not a licensed therapist,",
                              style: TextStyle(
                                color: _accentRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " psychologist, psychiatrist, medical provider, or emergency service. This app provides emotional support and wellness guidance only and should not replace professional mental health care, diagnosis, treatment, or crisis intervention.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                /// Crisis Message
                Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 90,
                        height: 90,
                        child: Image(
                          image: AssetImage('assets/icon/c.png'),
                        ),
                      ),

                      const Text(
                        "This is a Crisis\nYou're Not Alone",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "If you're in crisis or thinking about harming yourself, help is here , and you matter. You're not alone 24/7, and we will help",
                        style: TextStyle(
                          color: Color(0xFFBFB7C9),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// Support Options
                _buildSupportTile(
                  icon: Icons.phone,
                  title: "National Suicide Prevention Lifeline",
                  value: "988",
                  onTap: () => _makePhoneCall('988'),
                ),

                const SizedBox(height: 12),

                _buildSupportTile(
                  icon: Icons.headset_mic_outlined,
                  title: "Crisis Text Line",
                  value: "741741",
                  onTap: () => _makePhoneCall('741741'),
                ),

                const SizedBox(height: 12),

                _buildSupportTile(
                  icon: Icons.public,
                  title: "International Support",
                  value: "findahelpline.com",
                  onTap: () => _openWebsite('findahelpline.com'),
                ),

                const SizedBox(height: 24),

                /// Call 911 Button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () => _makePhoneCall('911'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),

                        SizedBox(width: 12),

                        Text(
                          "Call 911",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Footer Note
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: _accentRed,
                      size: 16,
                    ),

                    SizedBox(width: 8),

                    Text(
                      "Call 911 if you are in immediate danger",
                      style: TextStyle(
                        color: _accentRed,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _cardBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _accentRed,
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                color: _accentRed,
                size: 20,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _accentRed,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: onTap,
              icon: const Icon(
                Icons.call,
                color: _accentRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderBox extends StatelessWidget {
  const _DashedBorderBox({
    required this.child,
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  final Widget child;
  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        radius: radius,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
      ),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final next = distance + dashLength;

        canvas.drawPath(
          metric.extractPath(
            distance,
            next.clamp(0, metric.length),
          ),
          paint,
        );

        distance = next + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) {
    return old.color != color ||
        old.radius != radius ||
        old.strokeWidth != strokeWidth ||
        old.dashLength != dashLength ||
        old.gapLength != gapLength;
  }
}