import 'dart:math';

class MeasurementData {
  final double timestamp;
  final double refraction;
  final double pupilSize;
  final double gazeX;
  final double gazeY;
  final double pupilBrightness;
  final double imageBrightness;
  final int count;

  const MeasurementData({
    required this.timestamp,
    required this.refraction,
    required this.pupilSize,
    required this.gazeX,
    required this.gazeY,
    required this.pupilBrightness,
    required this.imageBrightness,
    required this.count,
  });

  factory MeasurementData.empty() {
    return const MeasurementData(
      timestamp: 0,
      refraction: 0,
      pupilSize: 0,
      gazeX: 0,
      gazeY: 0,
      pupilBrightness: 0,
      imageBrightness: 0,
      count: 0,
    );
  }

  factory MeasurementData.random({required double timestamp}) {
    final random = Random();
    return MeasurementData(
      timestamp: timestamp,
      refraction: -2 + random.nextDouble() * 4, // -2 到 2 D
      pupilSize: 8 + random.nextDouble() * 8, // 8 到 16 mm
      gazeX: -5 + random.nextDouble() * 10,
      gazeY: -5 + random.nextDouble() * 10,
      pupilBrightness: 50 + random.nextDouble() * 50,
      imageBrightness: 60 + random.nextDouble() * 10,
      count: (timestamp * 10).toInt(),
    );
  }

  MeasurementData copyWith({
    double? timestamp,
    double? refraction,
    double? pupilSize,
    double? gazeX,
    double? gazeY,
    double? pupilBrightness,
    double? imageBrightness,
    int? count,
  }) {
    return MeasurementData(
      timestamp: timestamp ?? this.timestamp,
      refraction: refraction ?? this.refraction,
      pupilSize: pupilSize ?? this.pupilSize,
      gazeX: gazeX ?? this.gazeX,
      gazeY: gazeY ?? this.gazeY,
      pupilBrightness: pupilBrightness ?? this.pupilBrightness,
      imageBrightness: imageBrightness ?? this.imageBrightness,
      count: count ?? this.count,
    );
  }
}

class AveragesData {
  final double avgRefraction;
  final double stdRefraction;
  final double avgRefractionNose;
  final double stdRefractionNose;
  final double avgPupilSize;
  final double stdPupilSize;
  final double avgGazeX;
  final double stdGazeX;
  final double avgGazeY;
  final double stdGazeY;
  final double avgPupilBrightness;
  final double stdPupilBrightness;

  const AveragesData({
    required this.avgRefraction,
    required this.stdRefraction,
    required this.avgRefractionNose,
    required this.stdRefractionNose,
    required this.avgPupilSize,
    required this.stdPupilSize,
    required this.avgGazeX,
    required this.stdGazeX,
    required this.avgGazeY,
    required this.stdGazeY,
    required this.avgPupilBrightness,
    required this.stdPupilBrightness,
  });

  factory AveragesData.empty() {
    return const AveragesData(
      avgRefraction: 0,
      stdRefraction: 0,
      avgRefractionNose: 0,
      stdRefractionNose: 0,
      avgPupilSize: 0,
      stdPupilSize: 0,
      avgGazeX: 0,
      stdGazeX: 0,
      avgGazeY: 0,
      stdGazeY: 0,
      avgPupilBrightness: 0,
      stdPupilBrightness: 0,
    );
  }

  factory AveragesData.fromMeasurements(List<MeasurementData> measurements) {
    if (measurements.isEmpty) return AveragesData.empty();

    double mean(Iterable<double> values) {
      return values.reduce((a, b) => a + b) / values.length;
    }

    double std(Iterable<double> values, double meanValue) {
      final variance = values.map((v) => pow(v - meanValue, 2)).reduce((a, b) => a + b) / values.length;
      return sqrt(variance);
    }

    final refractions = measurements.map((m) => m.refraction);
    final pupilSizes = measurements.map((m) => m.pupilSize);
    final gazeXs = measurements.map((m) => m.gazeX);
    final gazeYs = measurements.map((m) => m.gazeY);
    final pupilBrightnesses = measurements.map((m) => m.pupilBrightness);

    final avgRef = mean(refractions);
    final avgPupil = mean(pupilSizes);
    final avgGX = mean(gazeXs);
    final avgGY = mean(gazeYs);
    final avgPB = mean(pupilBrightnesses);

    return AveragesData(
      avgRefraction: avgRef,
      stdRefraction: std(refractions, avgRef),
      avgRefractionNose: avgRef * 0.9, // 模拟值
      stdRefractionNose: std(refractions, avgRef) * 0.9,
      avgPupilSize: avgPupil,
      stdPupilSize: std(pupilSizes, avgPupil),
      avgGazeX: avgGX,
      stdGazeX: std(gazeXs, avgGX),
      avgGazeY: avgGY,
      stdGazeY: std(gazeYs, avgGY),
      avgPupilBrightness: avgPB,
      stdPupilBrightness: std(pupilBrightnesses, avgPB),
    );
  }
}
