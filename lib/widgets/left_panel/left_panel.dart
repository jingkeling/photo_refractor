import 'package:flutter/material.dart';
import '../../models/measurement_data.dart';
import '../../theme/app_theme.dart';
import 'settings_section.dart';
import 'averages_section.dart';
import 'constants_section.dart';

class LeftPanel extends StatelessWidget {
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
  final AveragesData averages;

  const LeftPanel({
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
    required this.averages,
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
            // Animal ID（仅标签，无输入框）
            const Text('Animal ID:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
            const SizedBox(height: 16),

            // Settings Section
            SettingsSection(
              pupilFactor: pupilFactor,
              onPupilFactorChanged: onPupilFactorChanged,
              irisFactor: irisFactor,
              onIrisFactorChanged: onIrisFactorChanged,
              purkinjeThresholdP1: purkinjeThresholdP1,
              onPurkinjeThresholdP1Changed: onPurkinjeThresholdP1Changed,
              purkinjeThresholdP2: purkinjeThresholdP2,
              onPurkinjeThresholdP2Changed: onPurkinjeThresholdP2Changed,
              gazeControlOn: gazeControlOn,
              onGazeControlChanged: onGazeControlChanged,
              gazeTolerance: gazeTolerance,
              onGazeToleranceChanged: onGazeToleranceChanged,
              calibrationFactor: calibrationFactor,
              onCalibrationFactorChanged: onCalibrationFactorChanged,
              pupilSizeFactor: pupilSizeFactor,
              onPupilSizeFactorChanged: onPupilSizeFactorChanged,
            ),
            const SizedBox(height: 16),

            // Averages Section
            AveragesSection(averages: averages),
            const SizedBox(height: 16),

            // Constants Section
            const ConstantsSection(),
          ],
        ),
      ),
    );
  }
}
