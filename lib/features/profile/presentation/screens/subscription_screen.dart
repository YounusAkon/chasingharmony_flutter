import 'package:flutter/material.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  String _selectedPlan = 'CELY Care';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Back to Profile",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/image/Profile.png', fit: BoxFit.cover),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "CELY AI Subscription Plans",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Choose Your Peace — Support, clarity, and calm whenever you need it.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // CELY Basic
                  _buildPlanCard(
                    planKey: "CELY Basic",
                    title: "CELY Basic",
                    price: "\$0",
                    period: "/month",
                    features: const [
                      "Limited chat",
                      "Mood check-in",
                      "Anonymous support",
                    ],
                    buttonText: "Subscribe",
                    isPopular: false,
                    gradientColors: const [
                      Color(0xFF3B82F6),
                      Color(0xFF8B5CF6),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // CELY Care - Most Popular
                  Stack(
                    children: [
                      _buildPlanCard(
                        planKey: "CELY Care",
                        title: "CELY Care",
                        price: "\$9.99",
                        period: "/month",
                        features: const [
                          "Unlimited chat",
                          "Mood tracking",
                          "Guided exercises",
                        ],
                        buttonText: "Subscribe",
                        isPopular: true,
                        gradientColors: const [
                          Color(0xFF3B82F6),
                          Color(0xFF8B5CF6),
                        ],
                      ),
                      const Positioned(
                        top: 16,
                        right: 20,
                        child: MostPopularBadge(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // CELY Mind+
                  _buildPlanCard(
                    planKey: "CELY Mind+",
                    title: "CELY Mind+",
                    price: "\$19.99",
                    period: "/month",
                    features: const [
                      "AI journaling",
                      "Deep emotional support",
                      "Personalized AI",
                    ],
                    buttonText: "Subscribe",
                    isPopular: false,
                    gradientColors: const [
                      Color(0xFF3B82F6),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildPlanCard(
                    planKey: "CELY Mind+",
                    title: "CELY Mind+",
                    price: "\$39.99",
                    period: "/month",
                    features: const [
                      "Full access",
                      "Priority AI",
                      "Wellness plans",
                    ],
                    buttonText: "Subscribe",
                    isPopular: false,
                    gradientColors: const [
                      Color(0xFF3B82F6),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String planKey,
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required String buttonText,
    required bool isPopular,
    required List<Color> gradientColors,
  }) {
    final isSelected = _selectedPlan == planKey;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = planKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A).withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: const Color(0xFF8B5CF6), width: 2)
              : Border.all(color: Colors.white.withValues(alpha: 0.06)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.22),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  period,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey, thickness: 0.5),
            const SizedBox(height: 16),

            // Features
            Column(
              children: features
                  .map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF22C55E),
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 24),

            // Subscribe Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => setState(() => _selectedPlan = planKey),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradientColors),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MostPopularBadge extends StatelessWidget {
  const MostPopularBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Most Popular",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
