import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../models/measurement_data.dart';
import '../../theme/app_theme.dart';

class MeasurementsSection extends HookWidget {
  final MeasurementData measurement;

  const MeasurementsSection({super.key, required this.measurement});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Text(
          'Measurements (per frame)',
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: .w600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const .all(10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: .circular(4),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              _MeasurementRow(label: 'refraction:', value: measurement.refraction, unit: 'D', color: AppTheme.refractionColor),
              _MeasurementRow(label: 'pupil size:', value: measurement.pupilSize, unit: 'mm', color: AppTheme.pupilColor),
              _MeasurementRow(label: 'gaze x:', value: measurement.gazeX, unit: '°'),
              _MeasurementRow(label: 'gaze y:', value: measurement.gazeY, unit: '°'),
              const Divider(height: 16, color: AppTheme.borderColor),
              _MeasurementRow(label: 'pupil brightness:', value: measurement.pupilBrightness, unit: ''),
              _MeasurementRow(label: 'image brightness:', value: measurement.imageBrightness, unit: ''),
              _MeasurementRow(label: 'count:', value: measurement.count.toDouble(), unit: '', isInteger: true),
            ],
          ),
        ),
      ],
    );
  }
}

class _MeasurementRow extends HookWidget {
  final String label;
  final double value;
  final String unit;
  final Color? color;
  final bool isInteger;

  const _MeasurementRow({required this.label, required this.value, required this.unit, this.color, this.isInteger = false});

  @override
  Widget build(BuildContext context) {
    // 缓存格式化的值
    final formattedValue = useMemoized(() => isInteger ? value.toInt().toString() : value.toStringAsFixed(2), [value, isInteger]);

    return Padding(
      padding: const .symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: .end,
              children: [
                Text(
                  formattedValue,
                  style: TextStyle(
                    color: color ?? AppTheme.textPrimary,
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: color != null ? .w600 : .normal,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 2),
                  Text(unit, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
