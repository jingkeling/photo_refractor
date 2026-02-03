import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../theme/app_theme.dart';

class SettingsSection extends HookWidget {
  final double pupilFactor;
  final ValueChanged<double> onPupilFactorChanged;
  final double irisFactor;
  final ValueChanged<double> onIrisFactorChanged;
  final double purkinjeThresholdP1;
  final ValueChanged<double> onPurkinjeThresholdP1Changed;
  final double purkinjeThresholdP2;
  final ValueChanged<double> onPurkinjeThresholdP2Changed;
  final bool gazeControlOn;
  final ValueChanged<bool> onGazeControlChanged;
  final double gazeTolerance;
  final ValueChanged<double> onGazeToleranceChanged;
  final double calibrationFactor;
  final ValueChanged<double> onCalibrationFactorChanged;
  final double pupilSizeFactor;
  final ValueChanged<double> onPupilSizeFactorChanged;

  const SettingsSection({
    super.key,
    required this.pupilFactor,
    required this.onPupilFactorChanged,
    required this.irisFactor,
    required this.onIrisFactorChanged,
    required this.purkinjeThresholdP1,
    required this.onPurkinjeThresholdP1Changed,
    required this.purkinjeThresholdP2,
    required this.onPurkinjeThresholdP2Changed,
    required this.gazeControlOn,
    required this.onGazeControlChanged,
    required this.gazeTolerance,
    required this.onGazeToleranceChanged,
    required this.calibrationFactor,
    required this.onCalibrationFactorChanged,
    required this.pupilSizeFactor,
    required this.onPupilSizeFactorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: .w600),
        ),
        const SizedBox(height: 8),
        _ParameterRow(label: 'pupil factor:', value: pupilFactor, onChanged: onPupilFactorChanged, step: 0.01),
        _ParameterRow(label: 'iris factor:', value: irisFactor, onChanged: onIrisFactorChanged, step: 0.01),
        _PurkinjeThresholdRow(
          label: 'purkinje threshold:',
          valueP1: purkinjeThresholdP1,
          onP1Changed: onPurkinjeThresholdP1Changed,
          valueP2: purkinjeThresholdP2,
          onP2Changed: onPurkinjeThresholdP2Changed,
        ),
        _GazeControlRow(label: 'gaze control:', isOn: gazeControlOn, onChanged: onGazeControlChanged),
        _ParameterRow(label: 'gaze tolerance:', value: gazeTolerance, onChanged: onGazeToleranceChanged, step: 1.0),
        _ParameterRow(label: 'calibration factor:', value: calibrationFactor, onChanged: onCalibrationFactorChanged, step: 0.1),
        _ParameterRow(label: 'pupil size factor:', value: pupilSizeFactor, onChanged: onPupilSizeFactorChanged, step: 0.01),
      ],
    );
  }
}

class _ParameterRow extends HookWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double step;

  const _ParameterRow({required this.label, required this.value, required this.onChanged, required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          ),
          Text(
            value.toStringAsFixed(2),
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 11, fontFamily: 'monospace'),
          ),
          const SizedBox(width: 4),
          _SmallButton(label: '−', onPressed: () => onChanged(value - step)),
          _SmallButton(label: '+', onPressed: () => onChanged(value + step)),
        ],
      ),
    );
  }
}

class _PurkinjeThresholdRow extends HookWidget {
  final String label;
  final double valueP1;
  final ValueChanged<double> onP1Changed;
  final double valueP2;
  final ValueChanged<double> onP2Changed;

  const _PurkinjeThresholdRow({
    required this.label,
    required this.valueP1,
    required this.onP1Changed,
    required this.valueP2,
    required this.onP2Changed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          const SizedBox(height: 2),
          Row(
            children: [
              const SizedBox(width: 8),
              Text(
                valueP1.toStringAsFixed(2),
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 11, fontFamily: 'monospace'),
              ),
              const Text(' P1(+) ', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
              const Text('/ ', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
              const Text('P2(−)', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _GazeControlRow extends HookWidget {
  final String label;
  final bool isOn;
  final ValueChanged<bool> onChanged;

  const _GazeControlRow({required this.label, required this.isOn, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          ),
          GestureDetector(
            onTap: () => onChanged(true),
            child: Text(
              'On',
              style: TextStyle(
                color: isOn ? AppTheme.pupilColor : AppTheme.textMuted,
                fontSize: 11,
                fontWeight: isOn ? .w600 : .normal,
              ),
            ),
          ),
          const Text(' /disc ', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
          GestureDetector(
            onTap: () => onChanged(false),
            child: Text(
              'Off',
              style: TextStyle(
                color: !isOn ? AppTheme.refractionColor : AppTheme.textMuted,
                fontSize: 11,
                fontWeight: !isOn ? .w600 : .normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallButton extends HookWidget {
  final String label;
  final VoidCallback onPressed;

  const _SmallButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: SizedBox(
        width: 20,
        height: 18,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: .zero,
            minimumSize: .zero,
            backgroundColor: isHovered.value ? AppTheme.pupilColor.withValues(alpha: 0.2) : AppTheme.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: .circular(2),
              side: BorderSide(color: isHovered.value ? AppTheme.pupilColor : AppTheme.borderColor, width: 0.5),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(color: isHovered.value ? AppTheme.pupilColor : AppTheme.textSecondary, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
