import 'package:flutter/material.dart';

class IntensityScreen extends StatefulWidget {
  const IntensityScreen({super.key});

  @override
  State<IntensityScreen> createState() => _IntensityScreenState();
}

class _IntensityScreenState extends State<IntensityScreen> {
  int intensity = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Header with back button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 20),

              // Title
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "How ",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: "intense ",
                      style: TextStyle(color: Color(0xFF8B5CF6)),
                    ),
                    TextSpan(
                      text: "is it?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                "Rate how strong these feelings are",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              // Semi-circle Gauge
              SizedBox(
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Arc Background
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: CircularProgressIndicator(
                        value: 0.9,
                        strokeWidth: 18,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(
                          Colors.transparent,
                        ),
                      ),
                    ),

                    // Colored Progress Arc
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: CircularProgressIndicator(
                        value: intensity / 10,
                        strokeWidth: 18,
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF8B5CF6),
                        ),
                      ),
                    ),

                    // Center Number
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          intensity.toString(),
                          style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Number Scale
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(10, (index) {
                    final value = index + 1;
                    final isSelected = value == intensity;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          intensity = value;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8B5CF6)
                              : Colors.grey.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            value.toString(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const Spacer(),

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
                  onPressed: () {
                    // Handle continue
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Intensity selected: $intensity")),
                    );
                  },
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
