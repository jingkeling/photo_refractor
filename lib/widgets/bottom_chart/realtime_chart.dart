import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../models/measurement_data.dart';
import '../../theme/app_theme.dart';

class RealtimeChart extends HookWidget {
  final List<MeasurementData> data;

  const RealtimeChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // 使用 useMemoized 缓存图表数据的计算
    final chartData = useMemoized(() {
      if (data.isEmpty) return null;

      final minX = data.first.timestamp;
      final maxX = data.last.timestamp;

      // 瞳孔大小数据点
      final pupilSpots = data.map((d) {
        final normalizedY = (d.pupilSize - 3.9) / (20.6 - 3.9);
        return FlSpot(d.timestamp, normalizedY.clamp(0.0, 1.0));
      }).toList();

      // 屈光度数据点
      final refractionSpots = data.map((d) {
        final normalizedY = (d.refraction + 10) / 20;
        return FlSpot(d.timestamp, normalizedY.clamp(0.0, 1.0));
      }).toList();

      return (minX: minX, maxX: maxX, pupilSpots: pupilSpots, refractionSpots: refractionSpots);
    }, [data]);

    return Container(
      color: AppTheme.backgroundColor,
      padding: const .fromLTRB(12, 8, 12, 8),
      child: Column(
        children: [
          // 图表主体
          Expanded(
            child: Row(
              children: [
                // 左侧Y轴标签 (Pupil size)
                const _LeftYAxis(),
                // 图表
                Expanded(
                  child: chartData == null
                      ? const _EmptyChart()
                      : _ChartContent(
                          minX: chartData.minX,
                          maxX: chartData.maxX,
                          pupilSpots: chartData.pupilSpots,
                          refractionSpots: chartData.refractionSpots,
                        ),
                ),
                // 右侧Y轴标签 (Refraction)
                const _RightYAxis(),
                // 图例
                const _Legend(),
              ],
            ),
          ),
          // X轴标签
          const _XAxisLabel(),
        ],
      ),
    );
  }
}

class _LeftYAxis extends HookWidget {
  const _LeftYAxis();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Column(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .end,
        children: [
          const Text(
            '20.6',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
          ),
          const Text(
            '10.0',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
          ),
          Row(
            mainAxisAlignment: .end,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(shape: .circle, color: AppTheme.pupilColor),
              ),
              const SizedBox(width: 4),
              const Text(
                '3.90',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RightYAxis extends HookWidget {
  const _RightYAxis();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Column(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .start,
        children: [
          const Text(
            '10.0',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
          ),
          const Text(
            '0.0',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
          ),
          Row(
            children: [
              const Text(
                '-10.0',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
              ),
              const SizedBox(width: 4),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(shape: .circle, color: AppTheme.refractionColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyChart extends HookWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: .circular(4),
      ),
      child: const Center(
        child: Text('No data available', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
      ),
    );
  }
}

class _ChartContent extends HookWidget {
  final double minX;
  final double maxX;
  final List<FlSpot> pupilSpots;
  final List<FlSpot> refractionSpots;

  const _ChartContent({required this.minX, required this.maxX, required this.pupilSpots, required this.refractionSpots});

  @override
  Widget build(BuildContext context) {
    final interval = useMemoized(() => (maxX - minX) / 5, [minX, maxX]);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: .circular(4),
      ),
      padding: const .all(8),
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: 0,
          maxY: 1,
          clipData: const FlClipData.all(),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            horizontalInterval: 0.25,
            verticalInterval: interval > 0 ? interval : 1,
            getDrawingHorizontalLine: (value) => FlLine(color: AppTheme.borderColor.withValues(alpha: 0.5), strokeWidth: 0.5),
            getDrawingVerticalLine: (value) => FlLine(color: AppTheme.borderColor.withValues(alpha: 0.5), strokeWidth: 0.5),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: interval > 0 ? interval : 1,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const .only(top: 4),
                    child: Text(
                      value.toStringAsFixed(1),
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // 瞳孔大小线
            LineChartBarData(
              spots: pupilSpots,
              isCurved: false,
              color: AppTheme.pupilColor,
              barWidth: 0,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(radius: 2.5, color: AppTheme.pupilColor, strokeWidth: 0);
                },
              ),
              belowBarData: BarAreaData(show: false),
            ),
            // 屈光度线
            LineChartBarData(
              spots: refractionSpots,
              isCurved: false,
              color: AppTheme.refractionColor,
              barWidth: 0,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(radius: 2.5, color: AppTheme.refractionColor, strokeWidth: 0);
                },
              ),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => AppTheme.cardBackground,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final isPupil = spot.barIndex == 0;
                  final actualValue = isPupil ? spot.y * (20.6 - 3.9) + 3.9 : spot.y * 20 - 10;
                  return LineTooltipItem(
                    '${isPupil ? 'Pupil' : 'Refr'}: ${actualValue.toStringAsFixed(2)}',
                    TextStyle(color: isPupil ? AppTheme.pupilColor : AppTheme.refractionColor, fontSize: 10),
                  );
                }).toList();
              },
            ),
          ),
        ),
        duration: .zero,
      ),
    );
  }
}

class _XAxisLabel extends HookWidget {
  const _XAxisLabel();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: .only(top: 4),
      child: Text('time [sec]', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
    );
  }
}

class _Legend extends HookWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const .only(left: 12),
      child: Column(
        mainAxisAlignment: .end,
        crossAxisAlignment: .start,
        children: [
          const _LegendItem(color: AppTheme.estimateColor, label: 'estimate'),
          const SizedBox(height: 4),
          const _LegendItem(color: AppTheme.refractionColor, label: 'refraction corrected'),
          const SizedBox(height: 4),
          const _LegendItem(color: AppTheme.pupilColor, label: 'pupil size'),
          const SizedBox(height: 8),
          // Logo
          Row(
            children: [
              Icon(Icons.biotech, size: 12, color: AppTheme.textMuted.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Text(
                'Keling',
                style: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.5), fontSize: 9, fontWeight: .w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends HookWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: .circle, color: color),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 9),
            overflow: .ellipsis,
          ),
        ),
      ],
    );
  }
}
