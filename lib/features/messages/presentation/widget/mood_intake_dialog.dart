import 'dart:math';

import 'package:chasingharmony_fluttere/features/messages/controller/mode_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Result returned when the user completes (or partially fills) the
/// mood-intake flow shown after picking a mood.
class MoodIntakeResult {
  const MoodIntakeResult({
    required this.intensity,
    required this.triggers,
    required this.otherTrigger,
    required this.duration,
    required this.support,
  });

  final int intensity;
  final Set<String> triggers;
  final String? otherTrigger;
  final String? duration;
  final String? support;
}

/// Multi-step intake dialog opened from the chat screen's reaction icon.
/// Steps: intensity → triggers → duration → support type. Left/right arrows
/// in the header move between steps without losing state.
class MoodIntakeDialog extends StatefulWidget {
  const MoodIntakeDialog({super.key});

  /// Fixed dialog dimensions so the box doesn't resize between steps.
  /// Clamped to the screen so small phones don't overflow.
  static const double _dialogWidth = 360;
  static const double _dialogHeight = 600;

  static Future<MoodIntakeResult?> show() {
    return Get.dialog<MoodIntakeResult>(
      Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          final width = size.width - 32 < _dialogWidth
              ? size.width - 32
              : _dialogWidth;
          final height = size.height - 80 < _dialogHeight
              ? size.height - 80
              : _dialogHeight;
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(24),
                border:
                    Border.all(color: const Color(0xFF7600BF), width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: const MoodIntakeDialog(),
            ),
          );
        },
      ),
      barrierColor: Colors.black.withValues(alpha: 0.6),
    );
  }

  @override
  State<MoodIntakeDialog> createState() => _MoodIntakeDialogState();
}

class _MoodIntakeDialogState extends State<MoodIntakeDialog> {
  late final ModeSelectController _modeController =
      Get.find<ModeSelectController>();
  int _step = 0;

  // Step state
  int _intensity = 6;
  final Set<String> _triggers = <String>{};
  String? _otherTrigger;
  String? _duration;
  String? _support;

  static const int _totalSteps = 4;

  static const List<String> _fallbackTriggers = [
    'work_or_school',
    'relationships',
    'health',
    'finances',
    'family',
    'overthinking',
    'social_media',
    'not_specific',
    'other',
  ];

  static const List<String> _fallbackDurations = [
    'just_today',
    'a_few_days',
    'a_week_or_more',
    'a_few_weeks',
    'a_few_months',
    'longer_than_6_months',
  ];

  static const List<String> _fallbackSupportTypes = [
    'someone_to_talk_to',
    'practical_advice',
    'coping_tools',
    'motivation',
    'distraction',
    'just_listening',
    'not_sure',
  ];

  List<_TriggerOption> get _triggerOptions {
    final triggerValues = _modeController.triggers.isNotEmpty
        ? _modeController.triggers
        : _fallbackTriggers;

    return triggerValues
        .where((value) => value.toLowerCase() != 'other')
        .map(_TriggerOption.fromBackendValue)
        .toList(growable: false);
  }

  List<String> get _durationOptions {
    return _modeController.durations.isNotEmpty
        ? _modeController.durations
        : _fallbackDurations;
  }

  List<_SupportOption> get _supportOptions {
    final supportValues = _modeController.supportTypes.isNotEmpty
        ? _modeController.supportTypes
        : _fallbackSupportTypes;

    return supportValues
        .where((value) => value.toLowerCase() != 'not_sure')
        .map(_SupportOption.fromBackendValue)
        .toList(growable: false);
  }

  bool get _showOtherTrigger {
    final triggerValues = _modeController.triggers.isNotEmpty
        ? _modeController.triggers
        : _fallbackTriggers;
    return triggerValues.any((value) => value.toLowerCase() == 'other');
  }

  bool get _showNotSureSupport {
    final supportValues = _modeController.supportTypes.isNotEmpty
        ? _modeController.supportTypes
        : _fallbackSupportTypes;
    return supportValues.any((value) => value.toLowerCase() == 'not_sure');
  }

  @override
  void initState() {
    super.initState();
    _modeController.ensureModesLoaded();
  }

  void _goNext() {
    if (_step < _totalSteps - 1) {
      setState(() => _step += 1);
    } else {
      Get.back<MoodIntakeResult>(
        result: MoodIntakeResult(
          intensity: _intensity,
          triggers: _triggers,
          otherTrigger: _otherTrigger,
          duration: _duration,
          support: _support,
        ),
      );
    }
  }

  void _goPrev() {
    if (_step == 0) return;
    setState(() => _step -= 1);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: SingleChildScrollView(
                  key: ValueKey<int>(_step),
                  physics: const BouncingScrollPhysics(),
                  child: _buildStepBody(),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  // ---- Header (title + arrows) -------------------------------------------------

  Widget _buildHeader() {
    final canBack = _step > 0;
    final canForward = _step < _totalSteps - 1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _arrowButton(
          icon: Icons.chevron_left,
          enabled: canBack,
          onTap: _goPrev,
        ),
        Expanded(
          child: Column(
            children: [
              Center(child: _buildStepTitle()),
              const SizedBox(height: 4),
              Text(
                _stepSubtitle(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        _arrowButton(
          icon: Icons.chevron_right,
          enabled: canForward,
          onTap: _goNext,
        ),
      ],
    );
  }

  Widget _arrowButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Icon(
            icon,
            color: enabled ? Colors.white : Colors.white24,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildStepTitle() {
    const titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
    const highlightStyle = TextStyle(
      color: Color(0xFFEC4899),
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );

    switch (_step) {
      case 0:
        return const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'How ', style: titleStyle),
              TextSpan(text: 'intense', style: highlightStyle),
              TextSpan(text: ' is it?', style: titleStyle),
            ],
          ),
        );
      case 1:
        return const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'What ', style: titleStyle),
              TextSpan(text: 'triggered', style: highlightStyle),
              TextSpan(text: ' this?', style: titleStyle),
            ],
          ),
        );
      case 2:
        return const Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              TextSpan(text: 'How ', style: titleStyle),
              TextSpan(text: 'long', style: highlightStyle),
              TextSpan(text: ' has this been\ngoing on?', style: titleStyle),
            ],
          ),
        );
      case 3:
      default:
        return const Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              TextSpan(text: 'What ', style: titleStyle),
              TextSpan(text: 'support', style: highlightStyle),
              TextSpan(text: ' would help?', style: titleStyle),
            ],
          ),
        );
    }
  }

  String _stepSubtitle() {
    switch (_step) {
      case 0:
        return 'Rate how strong these feelings are';
      case 1:
        return 'Select all that apply';
      case 2:
        return 'Understanding duration helps';
      case 3:
      default:
        return 'Choose what feels most helpful right now';
    }
  }

  // ---- Step bodies -------------------------------------------------------------

  Widget _buildStepBody() {
    switch (_step) {
      case 0:
        return _IntensityStep(
          value: _intensity,
          min: _modeController.minIntensity,
          max: _modeController.maxIntensity,
          onChanged: (v) => setState(() => _intensity = v),
        );
      case 1:
        return _TriggersStep(
          options: _triggerOptions,
          showOtherOption: _showOtherTrigger,
          selected: _triggers,
          otherText: _otherTrigger,
          onToggle: (title) => setState(() {
            if (_triggers.contains(title)) {
              _triggers.remove(title);
            } else {
              _triggers.add(title);
            }
          }),
          onOtherChanged: (value) => setState(() {
            final trimmed = value.trim();
            _otherTrigger = trimmed.isEmpty ? null : trimmed;
            if (trimmed.isEmpty) {
              _triggers.remove('other');
            } else {
              _triggers.add('other');
            }
          }),
        );
      case 2:
        return _DurationStep(
          options: _durationOptions,
          selected: _duration,
          onSelect: (title) => setState(() => _duration = title),
        );
      case 3:
      default:
        return _SupportStep(
          options: _supportOptions,
          showNotSureOption: _showNotSureSupport,
          selected: _support,
          onSelect: (title) => setState(() => _support = title),
        );
    }
  }

  // ---- Continue button ---------------------------------------------------------

  Widget _buildContinueButton() {
    final isLast = _step == _totalSteps - 1;
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
            onTap: _goNext,
            child: Center(
              child: Text(
                isLast ? 'Continue to Chat' : 'Continue',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Step 1: Intensity ---------------------------------------------

class _IntensityStep extends StatelessWidget {
  const _IntensityStep({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  static const double _gaugeWidth = 278;
  static const double _gaugeHeight = 168;

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final values = List<int>.generate(
      max >= min ? (max - min + 1) : 0,
      (index) => min + index,
    );
    final totalSteps = values.isEmpty ? 1 : values.length;
    final progress = values.isEmpty
        ? 0.0
        : ((value - min + 1).clamp(0, totalSteps) / totalSteps).toDouble();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 2),

        /// TOP HALF ARC
        SizedBox(
          height: _gaugeHeight,
          width: _gaugeWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Background Arc
              CustomPaint(
                size: const Size(_gaugeWidth, _gaugeHeight),
                painter: _ArcPainter(
                  progress: 1,
                  color: const Color(0xFF15173A),
                  isBackground: true,
                ),
              ),

              /// Progress Arc
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0,
                  end: progress,
                ),
                duration: const Duration(milliseconds: 350),
                builder: (context, progress, child) {
                  return CustomPaint(
                    size: const Size(_gaugeWidth, _gaugeHeight),
                    painter: _ArcPainter(
                      progress: progress,
                      color: const Color(0xFFB100FF),
                    ),
                  );
                },
              ),

              /// CENTER VALUE
              Positioned(
                top: 0,
                child: Text(
                  value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 0),

        /// NUMBER SELECTOR
        Transform.translate(
          offset: const Offset(0, -80),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(values.length, (index) {
              final number = values[index];
              final isSelected = number == value;

              return Padding(
                padding: EdgeInsets.only(
                  right: index == values.length - 1 ? 0 : 4,
                ),
                child: GestureDetector(
                  onTap: () => onChanged(number),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF6A00FF),
                                Color(0xFFC000FF),
                              ],
                            )
                          : null,
                      color: isSelected ? null : const Color(0xFF11152B),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFC000FF)
                                    .withValues(alpha: 0.45),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      number.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

/// ARC PAINTER
class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isBackground;

  _ArcPainter({
    required this.progress,
    required this.color,
    this.isBackground = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 20.0;
    final diameter = min(
      size.width - strokeWidth,
      (size.height * 2) - strokeWidth,
    );
    final rect = Rect.fromLTWH(
      (size.width - diameter) / 2,
      size.height - diameter,
      diameter,
      diameter,
    );

    const startAngle = pi;
    const sweepAngle = pi;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (isBackground) {
      paint.color = color;
    } else {
      paint.shader = const LinearGradient(
        colors: [
          Color(0xFF5B00FF),
          Color(0xFFC000FF),
        ],
      ).createShader(rect);
    }

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ---------------- Step 2: Triggers ----------------------------------------------

class _TriggerOption {
  const _TriggerOption(this.value, this.title, this.icon, this.color);
  final String value;
  final String title;
  final IconData icon;
  final Color color;

  factory _TriggerOption.fromBackendValue(String value) {
    switch (value.trim().toLowerCase()) {
      case 'work_or_school':
        return const _TriggerOption(
          'work_or_school',
          'Work or School',
          Icons.work_outline,
          Color(0xFFEC4899),
        );
      case 'relationships':
        return const _TriggerOption(
          'relationships',
          'Relationships',
          Icons.favorite_border,
          Color(0xFFEF4444),
        );
      case 'health':
        return const _TriggerOption(
          'health',
          'Health',
          Icons.add_circle_outline,
          Color(0xFF8B5CF6),
        );
      case 'finances':
        return const _TriggerOption(
          'finances',
          'Finances',
          Icons.attach_money,
          Color(0xFF22C55E),
        );
      case 'family':
        return const _TriggerOption(
          'family',
          'Family',
          Icons.group_outlined,
          Color(0xFF94A3B8),
        );
      case 'overthinking':
        return const _TriggerOption(
          'overthinking',
          'Overthinking',
          Icons.psychology_outlined,
          Color(0xFF8B5CF6),
        );
      case 'social_media':
        return const _TriggerOption(
          'social_media',
          'Social media',
          Icons.phone_iphone_outlined,
          Color(0xFFEC4899),
        );
      case 'not_specific':
        return const _TriggerOption(
          'not_specific',
          'Not specific',
          Icons.help_outline,
          Color(0xFF8B5CF6),
        );
      default:
        return _TriggerOption(
          value,
          _formatBackendLabel(value),
          Icons.label_outline,
          const Color(0xFF8B5CF6),
        );
    }
  }
}

class _TriggersStep extends StatefulWidget {
  const _TriggersStep({
    required this.options,
    required this.showOtherOption,
    required this.selected,
    required this.otherText,
    required this.onToggle,
    required this.onOtherChanged,
  });

  final List<_TriggerOption> options;
  final bool showOtherOption;
  final Set<String> selected;
  final String? otherText;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onOtherChanged;

  @override
  State<_TriggersStep> createState() => _TriggersStepState();
}

class _TriggersStepState extends State<_TriggersStep> {
  late final TextEditingController _otherCtrl = TextEditingController(
    text: widget.otherText ?? '',
  );
  late bool _otherOpen = (widget.otherText ?? '').trim().isNotEmpty;

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.95,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: widget.options.length,
          itemBuilder: (context, i) {
            final option = widget.options[i];
            final isSelected = widget.selected.contains(option.value);
            return _TriggerCard(
              option: option,
              selected: isSelected,
              onTap: () => widget.onToggle(option.value),
            );
          },
        ),
        if (widget.showOtherOption) ...[
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _otherOpen = !_otherOpen),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF131525),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _otherOpen || (widget.otherText ?? '').trim().isNotEmpty
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFF2A2D45),
                  width:
                      _otherOpen || (widget.otherText ?? '').trim().isNotEmpty
                          ? 2
                          : 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit, color: Color(0xFF8B5CF6), size: 18),
                  const SizedBox(width: 10),
                  const Text(
                    'Other ',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const Text(
                    '(write your own)',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          if (_otherOpen) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _otherCtrl,
              onChanged: widget.onOtherChanged,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Tell us what triggered this',
                hintStyle: const TextStyle(color: Colors.white38),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF2A2D45)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _TriggerCard extends StatelessWidget {
  const _TriggerCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _TriggerOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFF131525),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? option.color : const Color(0xFF2A2D45),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(option.icon, color: option.color, size: 26),
            const SizedBox(height: 6),
            Text(
              option.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Step 3: Duration ----------------------------------------------

class _DurationStep extends StatelessWidget {
  const _DurationStep({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: options.map((value) {
        final isSelected = selected == value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () => onSelect(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF131525),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFF2A2D45),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFF8B5CF6),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      _formatBackendLabel(value),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------- Step 4: Support type ------------------------------------------

class _SupportOption {
  const _SupportOption(this.value, this.title, this.icon, this.color);
  final String value;
  final String title;
  final IconData icon;
  final Color color;

  factory _SupportOption.fromBackendValue(String value) {
    switch (value.trim().toLowerCase()) {
      case 'someone_to_talk_to':
        return const _SupportOption(
          'someone_to_talk_to',
          'Someone to talk to',
          Icons.chat_bubble_outline,
          Color(0xFF8B5CF6),
        );
      case 'practical_advice':
        return const _SupportOption(
          'practical_advice',
          'Practical advice',
          Icons.lightbulb_outline,
          Color(0xFF38BDF8),
        );
      case 'coping_tools':
        return const _SupportOption(
          'coping_tools',
          'Coping tools',
          Icons.eco_outlined,
          Color(0xFF22C55E),
        );
      case 'motivation':
        return const _SupportOption(
          'motivation',
          'Motivation',
          Icons.star_outline,
          Color(0xFFFFB020),
        );
      case 'distraction':
        return const _SupportOption(
          'distraction',
          'Distraction',
          Icons.sports_esports_outlined,
          Color(0xFFEF4444),
        );
      case 'just_listening':
        return const _SupportOption(
          'just_listening',
          'Just listening',
          Icons.favorite_border,
          Color(0xFFEC4899),
        );
      default:
        return _SupportOption(
          value,
          _formatBackendLabel(value),
          Icons.volunteer_activism_outlined,
          const Color(0xFF8B5CF6),
        );
    }
  }
}

class _SupportStep extends StatelessWidget {
  const _SupportStep({
    required this.options,
    required this.showNotSureOption,
    required this.selected,
    required this.onSelect,
  });

  final List<_SupportOption> options;
  final bool showNotSureOption;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: options.length,
          itemBuilder: (context, i) {
            final option = options[i];
            final isSelected = selected == option.value;
            return GestureDetector(
              onTap: () => onSelect(option.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF131525),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? option.color
                        : const Color(0xFF2A2D45),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: option.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(option.icon, color: option.color, size: 20),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      option.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (showNotSureOption) ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => onSelect('not_sure'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF131525),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected == 'not_sure'
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFF2A2D45),
                  width: selected == 'not_sure' ? 2 : 1,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help_outline, color: Colors.white70, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Not sure',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

String _formatBackendLabel(String value) {
  return value
      .trim()
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) {
        final lower = part.toLowerCase();
        if (lower.length == 1) {
          return lower.toUpperCase();
        }
        return '${lower[0].toUpperCase()}${lower.substring(1)}';
      })
      .join(' ');
}
