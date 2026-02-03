import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../models/measurement_data.dart';
import '../../theme/app_theme.dart';
import 'led_control.dart';
import 'information_section.dart';
import 'measurements_section.dart';

class RightPanel extends HookWidget {
  final double ledBrightness;
  final ValueChanged<double> onLedBrightnessChanged;
  final int storedDataCount;
  final int averagesCount;
  final MeasurementData currentMeasurement;

  const RightPanel({
    super.key,
    required this.ledBrightness,
    required this.onLedBrightnessChanged,
    required this.storedDataCount,
    required this.averagesCount,
    required this.currentMeasurement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: SingleChildScrollView(
        padding: const .all(12),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // LED Brightness 控制
            LedControl(brightness: ledBrightness, onChanged: onLedBrightnessChanged),
            const SizedBox(height: 24),

            // Information 区域
            InformationSection(storedDataCount: storedDataCount, averagesCount: averagesCount),
            const SizedBox(height: 24),

            // Measurements 区域
            MeasurementsSection(measurement: currentMeasurement),
          ],
        ),
      ),
    );
  }
}
