import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../models/measurement_data.dart';
import '../../theme/app_theme.dart';

class AveragesSection extends HookWidget {
  final AveragesData averages;

  const AveragesSection({super.key, required this.averages});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Text(
          'Averages (per 10 valid frames)',
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: .w600),
        ),
        const SizedBox(height: 8),
        _AverageRow(label: 'avg refraction:', value: averages.avgRefraction, std: averages.stdRefraction),
        _AverageRow(label: 'avg refraction nose:', value: averages.avgRefractionNose, std: averages.stdRefractionNose),
        _AverageRow(label: 'avg pupil size:', value: averages.avgPupilSize, std: averages.stdPupilSize),
        _AverageRow(label: 'avg gaze x:', value: averages.avgGazeX, std: averages.stdGazeX),
        _AverageRow(label: 'avg gaze y:', value: averages.avgGazeY, std: averages.stdGazeY),
        _AverageRow(label: 'avg pupil brightness:', value: averages.avgPupilBrightness, std: averages.stdPupilBrightness),
      ],
    );
  }
}

class _AverageRow extends HookWidget {
  final String label;
  final double value;
  final double std;

  const _AverageRow({required this.label, required this.value, required this.std});

  @override
  Widget build(BuildContext context) {
    // 使用 useMemoized 缓存格式化的字符串
    final formattedValue = useMemoized(() => '${value.toStringAsFixed(2)} ± ${std.toStringAsFixed(2)}', [value, std]);

    return Padding(
      padding: const .symmetric(vertical: 1),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formattedValue,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 11, fontFamily: 'monospace'),
              textAlign: .right,
            ),
          ),
        ],
      ),
    );
  }
}
