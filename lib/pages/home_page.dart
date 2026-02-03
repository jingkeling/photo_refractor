import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../widgets/top_toolbar.dart';
import '../widgets/left_panel/left_panel.dart';
import '../widgets/center_panel/camera_view.dart';
import '../widgets/right_panel/right_panel.dart';
import '../widgets/bottom_chart/realtime_chart.dart';
import '../models/measurement_data.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Settings state
    final pupilFactor = useState(1.90);
    final irisFactor = useState(1.00);
    final purkinjeThresholdP1 = useState(215.00);
    final purkinjeThresholdP2 = useState(0.0);
    final gazeControlOn = useState(true);
    final gazeTolerance = useState(20.00);
    final calibrationFactor = useState(3.00);
    final pupilSizeFactor = useState(1.00);

    // LED brightness
    final ledBrightness = useState(50.0);

    // Simulation state
    final isRunning = useState(false);
    final measurementHistory = useState<List<MeasurementData>>([]);
    final currentMeasurement = useState(MeasurementData.empty());

    // Statistics
    final storedDataCount = useState(0);
    final averagesCount = useState(0);

    // Averages
    final averages = useState(AveragesData.empty());

    // 模拟数据更新的定时器
    useEffect(() {
      Timer? timer;
      timer = Timer.periodic(const .new(milliseconds: 100), (_) {
        if (isRunning.value) {
          final history = List<MeasurementData>.from(measurementHistory.value);
          final newData = MeasurementData.random(timestamp: history.isEmpty ? 285.0 : history.last.timestamp + 0.1);
          history.add(newData);

          // 保持最近300个数据点
          if (history.length > 300) {
            history.removeAt(0);
          }

          measurementHistory.value = history;
          currentMeasurement.value = newData;
          storedDataCount.value++;

          // 每10帧更新一次平均值
          if (storedDataCount.value % 10 == 0) {
            averagesCount.value++;
            averages.value = AveragesData.fromMeasurements(history.take(10).toList());
          }
        }
      });

      return () => timer?.cancel();
    }, [isRunning.value]);

    void onStart() {
      isRunning.value = !isRunning.value;
    }

    void onReset() {
      isRunning.value = false;
      measurementHistory.value = [];
      currentMeasurement.value = MeasurementData.empty();
      storedDataCount.value = 0;
      averagesCount.value = 0;
      averages.value = AveragesData.empty();
    }

    return Scaffold(
      body: Column(
        children: [
          // 顶部工具栏
          TopToolbar(isRunning: isRunning.value, onStart: onStart, onReset: onReset),

          // 主内容区域
          Expanded(
            child: Row(
              crossAxisAlignment: .stretch,
              children: [
                // 左侧面板 - Settings
                SizedBox(
                  width: 220,
                  child: LeftPanel(
                    pupilFactor: pupilFactor.value,
                    onPupilFactorChanged: (value) => pupilFactor.value = value,
                    irisFactor: irisFactor.value,
                    onIrisFactorChanged: (value) => irisFactor.value = value,
                    purkinjeThresholdP1: purkinjeThresholdP1.value,
                    onPurkinjeThresholdP1Changed: (value) => purkinjeThresholdP1.value = value,
                    purkinjeThresholdP2: purkinjeThresholdP2.value,
                    onPurkinjeThresholdP2Changed: (value) => purkinjeThresholdP2.value = value,
                    gazeControlOn: gazeControlOn.value,
                    onGazeControlChanged: (value) => gazeControlOn.value = value,
                    gazeTolerance: gazeTolerance.value,
                    onGazeToleranceChanged: (value) => gazeTolerance.value = value,
                    calibrationFactor: calibrationFactor.value,
                    onCalibrationFactorChanged: (value) => calibrationFactor.value = value,
                    pupilSizeFactor: pupilSizeFactor.value,
                    onPupilSizeFactorChanged: (value) => pupilSizeFactor.value = value,
                    averages: averages.value,
                  ),
                ),

                // 中间区域 - Camera View
                Expanded(child: CameraView(isRunning: isRunning.value)),

                // 右侧面板 - Information & Measurements
                SizedBox(
                  width: 250,
                  child: RightPanel(
                    ledBrightness: ledBrightness.value,
                    onLedBrightnessChanged: (value) => ledBrightness.value = value,
                    storedDataCount: storedDataCount.value,
                    averagesCount: averagesCount.value,
                    currentMeasurement: currentMeasurement.value,
                  ),
                ),
              ],
            ),
          ),

          // 底部图表
          SizedBox(height: 200, child: RealtimeChart(data: measurementHistory.value)),
        ],
      ),
    );
  }
}
