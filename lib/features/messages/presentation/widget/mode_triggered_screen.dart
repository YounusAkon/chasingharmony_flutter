import 'package:flutter/material.dart';

class TriggerScreen extends StatefulWidget {
  const TriggerScreen({super.key});

  @override
  State<TriggerScreen> createState() => _TriggerScreenState();
}

class _TriggerScreenState extends State<TriggerScreen> {
  final Set<String> selectedTriggers = {};

  final List<TriggerOption> triggerOptions = [
    TriggerOption(
      icon: Icons.work_outline,
      title: "Work or School",
      color: const Color(0xFF8B5CF6),
    ),
    TriggerOption(
      icon: Icons.favorite,
      title: "Relationships",
      color: Colors.red,
    ),
    TriggerOption(
      icon: Icons.add_circle_outline,
      title: "Health",
      color: const Color(0xFF8B5CF6),
    ),
    TriggerOption(
      icon: Icons.attach_money,
      title: "Finances",
      color: Colors.green,
    ),
    TriggerOption(icon: Icons.group, title: "Family", color: Colors.grey),
    TriggerOption(
      icon: Icons.psychology,
      title: "Overthinking",
      color: const Color(0xFF8B5CF6),
    ),
    TriggerOption(
      icon: Icons.phone_android,
      title: "Social media",
      color: const Color(0xFF8B5CF6),
    ),
    TriggerOption(
      icon: Icons.help_outline,
      title: "Not specific reason",
      color: const Color(0xFF8B5CF6),
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
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),

              const SizedBox(height: 8),

              // Title
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "What ",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: "triggered ",
                      style: TextStyle(color: Color(0xFF8B5CF6)),
                    ),
                    TextSpan(
                      text: "this?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const Text(
                "Select all that apply",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 28),

              // Trigger Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: triggerOptions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == triggerOptions.length) {
                      // Other option
                      return GestureDetector(
                        onTap: () {
                          // You can show a text field here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Other option clicked"),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F1F1F),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit_note,
                                size: 32,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Other",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              const Text(
                                "(write your own)",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final option = triggerOptions[index];
                    final isSelected = selectedTriggers.contains(option.title);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedTriggers.remove(option.title);
                          } else {
                            selectedTriggers.add(option.title);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? option.color
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              option.icon,
                              size: 36,
                              color: isSelected ? option.color : Colors.white70,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              option.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Continue Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: selectedTriggers.isNotEmpty
                      ? () {
                          print("Selected triggers: $selectedTriggers");
                          // Navigate to next screen
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
            ],
          ),
        ),
      ),
    );
  }
}

// Data Model
class TriggerOption {
  final IconData icon;
  final String title;
  final Color color;

  TriggerOption({required this.icon, required this.title, required this.color});
}
