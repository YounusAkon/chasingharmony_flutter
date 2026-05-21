import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reusable mood-picker. Used as a dialog from the home screen "Start Chat"
/// flow, and also as a full screen via [MoodSelectionScreen].
class MoodSelectionDialog extends StatefulWidget {
  const MoodSelectionDialog({super.key, this.onContinue});

  /// Called with the selected mood title when the user taps "Continue to Chat".
  /// If null, the dialog just closes after selection.
  final ValueChanged<String>? onContinue;

  /// Shows the mood picker as a styled rounded dialog using GetX's root
  /// navigator so it's safe to call from a widget that's about to be disposed
  /// (e.g. after switching bottom-nav tabs).
  static Future<String?> show({ValueChanged<String>? onContinue}) {
    return Get.dialog<String>(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF7600BF), width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: MoodSelectionDialog(onContinue: onContinue),
        ),
      ),
      barrierColor: Colors.black.withValues(alpha: 0.6),
    );
  }

  @override
  State<MoodSelectionDialog> createState() => _MoodSelectionDialogState();
}

class _MoodSelectionDialogState extends State<MoodSelectionDialog> {
  String? _selectedMood;

  static const List<MoodOption> _moods = [
    MoodOption(
      emoji: '😊',
      title: 'Good',
      color: Color(0xFF22C55E),
      description: 'Feeling positive and energized',
    ),
    MoodOption(
      emoji: '😄',
      title: 'Happy',
      color: Color(0xFFFFB020),
      description: 'Feeling cheerful and motivated',
    ),
    MoodOption(
      emoji: '😟',
      title: 'Stressed',
      color: Color(0xFFFF8A3D),
      description: 'Feeling pressured or anxious',
    ),
    MoodOption(
      emoji: '😣',
      title: 'Overwhelmed',
      color: Color(0xFFEF4444),
      description: 'Struggling to cope',
    ),
    MoodOption(
      emoji: '🥱',
      title: 'Tired',
      color: Color(0xFF8B5CF6),
      description: 'Mentally and emotionally drained',
    ),
    MoodOption(
      emoji: '😐',
      title: 'Neutral',
      color: Color(0xFF38BDF8),
      description: 'Feeling okay, nothing strong',
    ),
    MoodOption(
      emoji: '🙁',
      title: 'Sad',
      color: Color(0xFF14B8A6),
      description: 'Feeling down or low',
    ),
    MoodOption(
      emoji: '😠',
      title: 'Angry',
      color: Color(0xFFEC4899),
      description: 'Frustrated or irritated',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const SizedBox(height: 14),
          Flexible(child: _buildGrid()),
          const SizedBox(height: 14),
          _buildContinueButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 32),
            const Expanded(
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'How are you ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: 'feeling?',
                        style: TextStyle(
                          color: Color(0xFFEC4899),
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 22,
                onPressed: () => Get.back<String?>(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          "Let's check in with your emotional state",
          style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _moods.length,
      itemBuilder: (context, index) {
        final mood = _moods[index];
        final isSelected = _selectedMood == mood.title;
        return _MoodCard(
          mood: mood,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedMood = mood.title),
        );
      },
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    final enabled = _selectedMood != null;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: enabled
                ? () {
                    final mood = _selectedMood!;
                    Get.back<String>(result: mood);
                    widget.onContinue?.call(mood);
                  }
                : null,
            child: Opacity(
              opacity: enabled ? 1 : 0.5,
              child: const Center(
                child: Text(
                  'Continue to Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  final MoodOption mood;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF131525),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5CF6)
                : const Color(0xFF2A2D45),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: mood.color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(mood.emoji, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(height: 8),
            Text(
              mood.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: mood.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              mood.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Backwards-compatible full-screen variant.
class MoodSelectionScreen extends StatelessWidget {
  const MoodSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(child: MoodSelectionDialog()),
    );
  }
}

class MoodOption {
  const MoodOption({
    required this.emoji,
    required this.title,
    required this.color,
    required this.description,
  });

  final String emoji;
  final String title;
  final Color color;
  final String description;
}
