import 'package:flutter/material.dart';
class DurationScreen extends StatefulWidget {
  const DurationScreen({super.key});

  @override
  State<DurationScreen> createState() => _DurationScreenState();
}

class _DurationScreenState extends State<DurationScreen> {
  String? selectedDuration;

  final List<DurationOption> options = [
    DurationOption(
      icon: Icons.access_time,
      title: "Just today",
    ),
    DurationOption(
      icon: Icons.calendar_today,
      title: "A few days",
    ),
    DurationOption(
      icon: Icons.calendar_today,
      title: "A week or more",
    ),
    DurationOption(
      icon: Icons.calendar_today,
      title: "A few weeks",
    ),
    DurationOption(
      icon: Icons.calendar_today,
      title: "A few Months",
    ),
    DurationOption(
      icon: Icons.calendar_today,
      title: "Longer than 6 Months",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              // Title
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: "How ", style: TextStyle(color: Colors.white)),
                    TextSpan(
                        text: "long ",
                        style: TextStyle(color: Color(0xFF8B5CF6))),
                    TextSpan(
                        text: "has this been\ngoing on?",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Understanding duration helps",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Duration Options
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = selectedDuration == option.title;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDuration = option.title;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6B46C1)
                              : const Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF8B5CF6), width: 2)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              option.icon,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF8B5CF6),
                              size: 28,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Continue Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF8B5CF6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: selectedDuration != null
                      ? () {
                          // Navigate to next screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Selected: $selectedDuration"),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Data Model
class DurationOption {
  final IconData icon;
  final String title;

  DurationOption({required this.icon, required this.title});
}