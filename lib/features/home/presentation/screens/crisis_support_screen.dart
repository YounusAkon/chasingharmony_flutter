import 'package:flutter/material.dart';

class CrisisSupportScreen extends StatelessWidget {
  const CrisisSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top + 12;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image/Profile.png', fit: BoxFit.cover),
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
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Important Notice
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.shade400, width: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade400,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Important Notice",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  "If you are in immediate danger, please call ",
                            ),
                            TextSpan(
                              text: "988",
                              style: TextStyle(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: " or "),
                            TextSpan(
                              text: "911",
                              style: TextStyle(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ". This app is not a substitute for emergency services. Get help now. You are not alone.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Disclaimer
                Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFF8B5CF6),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Disclaimer:",
                      style: TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(color: Colors.white, fontSize: 11),
                      children: [
                        TextSpan(
                          text: "CELYS AI ",
                        ),
                        TextSpan(
                          text: "is not a licensed therapist, ",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "psychologist, psychiatrist, medical provider, or emergency service. This app provides emotional support and wellness guidance only and should not replace professional mental health care, diagnosis, treatment, or crisis intervention.",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Crisis Message
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red.shade400,
                            width: 4,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red.shade400,
                            size: 50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "This is a Crisis",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "You're Not Alone",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "If you're in crisis or thinking about harming yourself, help is here, and you matter. You're not alone 24/7, and we will help.",
                        style: TextStyle(color: Colors.grey, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Support Options
                _buildSupportTile(
                  icon: Icons.phone,
                  title: "National Suicide Prevention Lifeline",
                  value: "988",
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                _buildSupportTile(
                  icon: Icons.message,
                  title: "Crisis Text Line",
                  value: "741741",
                  color: Colors.orange,
                ),
                const SizedBox(height: 12),
                _buildSupportTile(
                  icon: Icons.language,
                  title: "International Support",
                  value: "findahelpline.com",
                  color: const Color(0xFF8B5CF6),
                ),
                const SizedBox(height: 32),

                // Call 911 Button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.white),
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
                const SizedBox(height: 16),

                // Footer Note
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Call 911 if you are in immediate danger",
                      style: TextStyle(color: Colors.red, fontSize: 15),
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
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
