import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../hooks/use_camera_controller.dart';
import '../../theme/app_theme.dart';

class CameraView extends HookWidget {
  final bool isRunning;

  const CameraView({super.key, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    final camera = useCameraController(preferredLensDirection: CameraLensDirection.back, resolution: ResolutionPreset.medium);

    final animationController = useAnimationController(duration: const .new(milliseconds: 1500));

    final pulseAnimation = useAnimation(
      Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut)),
    );

    // 监听 isRunning 变化，控制摄像头生命周期和瞳孔检测框动画
    useEffect(() {
      if (isRunning) {
        camera.initialize(); // 开始时初始化摄像头
        animationController.repeat(reverse: true); // 启动脉冲动画
      } else {
        animationController.stop();
        animationController.reset();
        camera.dispose(); // 停止时释放摄像头资源
      }
      return null;
    }, [isRunning]);

    return Container(
      margin: const .all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        border: Border.all(color: AppTheme.borderColor, width: 1),
        borderRadius: .circular(4),
      ),
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                margin: const .all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  border: Border.all(color: AppTheme.textMuted.withValues(alpha: 0.3), width: 1),
                ),
                child: ClipRect(
                  child: Stack(
                    fit: .expand,
                    children: [
                      _CameraPreview(camera: camera),
                      CustomPaint(size: Size.infinite, painter: _GridPainter()),
                      if (isRunning && camera.isInitialized.value) _PupilOverlay(pulseValue: pulseAnimation),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 8,
            left: 12,
            child: _StatusIndicator(
              isRunning: isRunning,
              isInitialized: camera.isInitialized.value,
              isInitializing: camera.isInitializing.value,
              hasError: camera.error.value != null,
            ),
          ),

          Positioned(
            top: 8,
            right: 12,
            child: Container(
              padding: const .symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppTheme.backgroundColor.withValues(alpha: 0.7), borderRadius: .circular(2)),
              child: Text(
                getCameraResolutionString(camera.controller),
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
              ),
            ),
          ),

          if (camera.error.value != null)
            Positioned(
              bottom: 8,
              left: 12,
              right: 12,
              child: Container(
                padding: const .symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.refractionColor.withValues(alpha: 0.2),
                  borderRadius: .circular(4),
                  border: Border.all(color: AppTheme.refractionColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  camera.error.value!,
                  style: const TextStyle(color: AppTheme.refractionColor, fontSize: 10),
                  textAlign: .center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CameraPreview extends StatelessWidget {
  final CameraState camera;

  const _CameraPreview({required this.camera});

  @override
  Widget build(BuildContext context) {
    if (camera.isInitializing.value) {
      return const Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            SizedBox(width: 32, height: 32, child: CircularProgressIndicator(color: AppTheme.pupilColor, strokeWidth: 2)),
            SizedBox(height: 12),
            Text('Initializing camera...', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          ],
        ),
      );
    }

    if (camera.isInitialized.value && camera.controller != null) {
      return _CameraPreviewWidget(controller: camera.controller!);
    }

    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(
            camera.error.value != null ? Icons.videocam_off : Icons.videocam_off_outlined,
            size: 48,
            color: camera.error.value != null
                ? AppTheme.refractionColor.withValues(alpha: 0.5)
                : AppTheme.textMuted.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          Text(
            camera.error.value != null ? 'Camera Error' : 'Camera Preview',
            style: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.5), fontSize: 14),
          ),
          if (camera.error.value == null) ...[
            const SizedBox(height: 4),
            Text(
              'Press Start to begin capture',
              style: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.3), fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

class _CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;

  const _CameraPreviewWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final previewAspectRatio = controller.value.aspectRatio;
        final containerAspectRatio = constraints.maxWidth / constraints.maxHeight;

        double scale;
        if (previewAspectRatio > containerAspectRatio) {
          scale = constraints.maxHeight / (constraints.maxWidth / previewAspectRatio);
        } else {
          scale = constraints.maxWidth / (constraints.maxHeight * previewAspectRatio);
        }

        return ClipRect(
          child: Transform.scale(
            scale: scale,
            child: Center(child: CameraPreview(controller)),
          ),
        );
      },
    );
  }
}

class _StatusIndicator extends HookWidget {
  final bool isRunning;
  final bool isInitialized;
  final bool isInitializing;
  final bool hasError;

  const _StatusIndicator({
    required this.isRunning,
    required this.isInitialized,
    required this.isInitializing,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    final blinkController = useAnimationController(duration: const .new(milliseconds: 800));

    final blinkValue = useAnimation(Tween<double>(begin: 0.3, end: 1.0).animate(blinkController));

    useEffect(() {
      if (isRunning && isInitialized) {
        blinkController.repeat(reverse: true);
      } else {
        blinkController.stop();
        blinkController.value = 1.0;
      }
      return null;
    }, [isRunning, isInitialized]);

    final (statusColor, statusText) = switch (true) {
      _ when hasError => (AppTheme.refractionColor, 'ERROR'),
      _ when isInitializing => (AppTheme.estimateColor, 'INIT'),
      _ when isRunning && isInitialized => (AppTheme.startButtonColor, 'LIVE'),
      _ => (AppTheme.textMuted, 'STANDBY'),
    };

    return Container(
      padding: const .symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: AppTheme.backgroundColor.withValues(alpha: 0.7), borderRadius: .circular(2)),
      child: Row(
        mainAxisSize: .min,
        children: [
          Opacity(
            opacity: (isRunning && isInitialized) ? blinkValue : 1.0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: .circle, color: statusColor),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(color: statusColor, fontSize: 10, fontWeight: .w600),
          ),
        ],
      ),
    );
  }
}

class _PupilOverlay extends HookWidget {
  final double pulseValue;

  const _PupilOverlay({required this.pulseValue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: pulseValue,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: .circle,
            border: Border.all(color: AppTheme.pupilColor.withValues(alpha: 0.8), width: 2),
          ),
          child: Stack(
            alignment: .center,
            children: [
              Container(width: 20, height: 2, color: AppTheme.pupilColor.withValues(alpha: 0.6)),
              Container(width: 2, height: 20, color: AppTheme.pupilColor.withValues(alpha: 0.6)),
              Positioned(
                top: 20,
                left: 25,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: AppTheme.estimateColor,
                    boxShadow: [BoxShadow(color: AppTheme.estimateColor.withValues(alpha: 0.5), blurRadius: 4, spreadRadius: 1)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.textMuted.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;

    for (int i = 1; i < 4; i++) {
      final x = size.width * i / 4;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 1; i < 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
