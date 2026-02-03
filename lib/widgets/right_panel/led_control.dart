import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../theme/app_theme.dart';

class LedControl extends HookWidget {
  final double brightness;
  final ValueChanged<double> onChanged;

  const LedControl({super.key, required this.brightness, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // LED 指示灯颜色
    final ledColor = useMemoized(
      () => brightness > 0 ? Color.lerp(AppTheme.textMuted, AppTheme.estimateColor, brightness / 100)! : AppTheme.textMuted,
      [brightness],
    );

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            const Text(
              'LED Brightness',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: .w600),
            ),
            const Spacer(),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: .circle,
                color: ledColor,
                boxShadow: brightness > 50
                    ? [BoxShadow(color: AppTheme.estimateColor.withValues(alpha: 0.3), blurRadius: 4, spreadRadius: 1)]
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                ),
                child: Slider(value: brightness, min: 0, max: 100, onChanged: onChanged),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 40,
              child: Text(
                '${brightness.toInt()}%',
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 11, fontFamily: 'monospace'),
                textAlign: .right,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
