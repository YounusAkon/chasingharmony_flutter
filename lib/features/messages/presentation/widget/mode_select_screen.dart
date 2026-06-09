import 'package:chasingharmony_fluttere/app/controller/app_ground_controller.dart';
import 'package:chasingharmony_fluttere/features/messages/controller/mode_select_controller.dart';
import 'package:chasingharmony_fluttere/features/messages/presentation/widget/mood_intake_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reusable mood-picker. Used as a dialog from the home screen "Start Chat"
/// flow, and also as a full screen via [MoodSelectionScreen].
class MoodSelectionDialog extends StatefulWidget {
  const MoodSelectionDialog({super.key, this.onContinue});

  final ValueChanged<String>? onContinue;
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
  late final ModeSelectController _controller = Get.find<ModeSelectController>();
  String? _selectedMood;

  @override
  void initState() {
    super.initState();
    _controller.ensureModesLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final moods = _controller.feelings
          .map(MoodOption.fromBackendValue)
          .toList(growable: false);
      final selectedMood = moods.any((mood) => mood.value == _selectedMood)
          ? _selectedMood
          : null;

      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            const SizedBox(height: 14),
            Flexible(
              child: _buildBody(
                moods: moods,
                selectedMood: selectedMood,
              ),
            ),
            const SizedBox(height: 14),
            _buildContinueButton(
              context,
              selectedMood: selectedMood,
            ),
          ],
        ),
      );
    });
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
                onPressed: () {
                  Get.back<String?>();
                  if (Get.isRegistered<AppGroundController>()) {
                    Get.find<AppGroundController>().changeTab(0);
                  }
                },
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

  Widget _buildBody({
    required List<MoodOption> moods,
    required String? selectedMood,
  }) {
    if (_controller.isLoading.value && moods.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8B5CF6),
          ),
        ),
      );
    }

    if (_controller.error.value.isNotEmpty && moods.isEmpty) {
      return SizedBox(
        height: 280,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _controller.error.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _controller.loadModes(),
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Color(0xFFB100FF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (moods.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(
          child: Text(
            'No mood options available right now.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    return _buildMoodGrid(
      moods: moods,
      selectedMood: selectedMood,
    );
  }

  Widget _buildMoodGrid({
    required List<MoodOption> moods,
    required String? selectedMood,
  }) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: moods.length,
      itemBuilder: (context, index) {
        final mood = moods[index];
        final isSelected = selectedMood == mood.value;
        return _MoodCard(
          mood: mood,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedMood = mood.value),
        );
      },
    );
  }

  Widget _buildContinueButton(
    BuildContext context, {
    required String? selectedMood,
  }) {
    final activeMood = selectedMood;
    final enabled = activeMood != null;
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
                ? () async {
                    final String mood = activeMood;

                    Get.back<String>(result: mood);
                    widget.onContinue?.call(mood);
                    await Future<void>.delayed(Duration.zero);
                    if (Get.isDialogOpen != true) {
                      await MoodIntakeDialog.show(feeling: mood);
                    }
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
    required this.value,
    required this.emoji,
    required this.title,
    required this.color,
    required this.description,
  });

  final String value;
  final String emoji;
  final String title;
  final Color color;
  final String description;

  factory MoodOption.fromBackendValue(String value) {
    switch (value.trim().toLowerCase()) {
      case 'good':
        return const MoodOption(
          value: 'good',
          emoji: '😊',
          title: 'Good',
          color: Color(0xFF22C55E),
          description: 'Feeling positive and energized',
        );
      case 'happy':
        return const MoodOption(
          value: 'happy',
          emoji: '😄',
          title: 'Happy',
          color: Color(0xFFFFB020),
          description: 'Feeling cheerful and motivated',
        );
      case 'stressed':
        return const MoodOption(
          value: 'stressed',
          emoji: '😟',
          title: 'Stressed',
          color: Color(0xFFFF8A3D),
          description: 'Feeling pressured or anxious',
        );
      case 'overwhelmed':
        return const MoodOption(
          value: 'overwhelmed',
          emoji: '😣',
          title: 'Overwhelmed',
          color: Color(0xFFEF4444),
          description: 'Struggling to cope',
        );
      case 'tired':
        return const MoodOption(
          value: 'tired',
          emoji: '🥱',
          title: 'Tired',
          color: Color(0xFF8B5CF6),
          description: 'Mentally and emotionally drained',
        );
      case 'neutral':
        return const MoodOption(
          value: 'neutral',
          emoji: '😐',
          title: 'Neutral',
          color: Color(0xFF38BDF8),
          description: 'Feeling okay, nothing strong',
        );
      case 'sad':
        return const MoodOption(
          value: 'sad',
          emoji: '🙁',
          title: 'Sad',
          color: Color(0xFF14B8A6),
          description: 'Feeling down or low',
        );
      case 'angry':
        return const MoodOption(
          value: 'angry',
          emoji: '😠',
          title: 'Angry',
          color: Color(0xFFEC4899),
          description: 'Frustrated or irritated',
        );
      default:
        return MoodOption(
          value: value,
          emoji: '🙂',
          title: _formatMoodLabel(value),
          color: const Color(0xFF8B5CF6),
          description: 'Take a moment to check in with how you feel.',
        );
    }
  }

  static String _formatMoodLabel(String value) {
    return value
        .trim()
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) {
          final lower = part.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }
}
