import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../utils/camera_platform_io.dart' if (dart.library.html) '../utils/camera_platform_stub.dart' as _platform;

/// 摄像头控制器状态 Record 类型
typedef CameraState = ({
  CameraController? controller,
  ValueNotifier<bool> isInitialized,
  ValueNotifier<bool> isInitializing,
  ValueNotifier<String?> error,
  ValueNotifier<List<CameraDescription>> cameras,
  Future<void> Function() initialize,
  void Function() dispose,
});

/// 自定义 Hook: 管理摄像头控制器的生命周期
///
/// 默认不自动初始化摄像头，需要调用 `initialize()` 手动初始化
///
/// 使用方式：
/// ```dart
/// final camera = useCameraController();
///
/// // 通过 .value 读取
/// if (camera.isInitialized.value) { ... }
/// if (camera.error.value != null) { ... }
///
/// // 调用方法
/// camera.initialize();
/// camera.dispose();
/// ```
///
/// [preferredLensDirection] - 优先使用的摄像头方向，默认后置
/// [resolution] - 分辨率预设，默认 medium
CameraState useCameraController({
  CameraLensDirection preferredLensDirection = CameraLensDirection.back,
  ResolutionPreset resolution = ResolutionPreset.medium,
}) {
  final controller = useState<CameraController?>(null);
  final isInitialized = useState(false);
  final isInitializing = useState(false);
  final error = useState<String?>(null);
  final cameras = useState<List<CameraDescription>>([]);

  // 只用 useState 存 controller，单一数据源，避免和 controllerRef 双写导致时序问题

  // 初始化摄像头的函数
  Future<void> initCamera() async {
    if (isInitializing.value || isInitialized.value) return;

    // 检查平台支持（camera 插件仅支持 Android、iOS、Web）
    if (kIsWeb) {
      error.value = 'Camera not supported on web';
      return;
    }
    if (_platform.isDesktop) {
      error.value = 'Camera not supported on this platform';
      return;
    }

    isInitializing.value = true;
    error.value = null;

    try {
      // 获取可用摄像头列表
      final availableCams = await availableCameras();
      cameras.value = availableCams;

      if (availableCams.isEmpty) {
        isInitializing.value = false;
        error.value = 'No cameras available';
        return;
      }

      // 选择摄像头：优先使用指定方向的摄像头
      var selectedCamera = availableCams.first;
      for (final cam in availableCams) {
        if (cam.lensDirection == preferredLensDirection) {
          selectedCamera = cam;
          break;
        }
      }

      // 创建控制器后立刻写入 state，方便 dispose/cleanup 时能拿到引用；UI 靠 isInitialized 区分未就绪
      final ctrl = CameraController(selectedCamera, resolution, enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);
      controller.value = ctrl;

      // 初始化控制器
      await ctrl.initialize();

      isInitialized.value = true;
      isInitializing.value = false;
    } on CameraException catch (e) {
      controller.value?.dispose();
      controller.value = null;
      isInitializing.value = false;
      error.value = 'Camera error: ${e.description}';
    } catch (e) {
      controller.value?.dispose();
      controller.value = null;
      isInitializing.value = false;
      error.value = 'Failed to initialize camera: $e';
    }
  }

  // 释放摄像头资源的函数：先清空 state 触发一次不包含预览的 build，再在下一帧回调中 dispose，避免 buildPreview() 在已 dispose 的 controller 上调用
  void disposeCamera() {
    final ctrl = controller.value;
    if (ctrl != null) {
      controller.value = null;
      isInitialized.value = false;
      isInitializing.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrl.dispose();
      });
    }
  }

  // 组件销毁时自动清理（只依赖 controller 单一来源）
  useEffect(() {
    return () {
      controller.value?.dispose();
      controller.value = null;
    };
  }, []);

  return (
    controller: controller.value,
    isInitialized: isInitialized,
    isInitializing: isInitializing,
    error: error,
    cameras: cameras,
    initialize: initCamera,
    dispose: disposeCamera,
  );
}

/// 获取摄像头的实际分辨率字符串
String getCameraResolutionString(CameraController? controller) {
  if (controller == null || !controller.value.isInitialized) {
    return '-- × -- @ --fps';
  }

  final size = controller.value.previewSize;
  if (size == null) {
    return '-- × -- @ --fps';
  }

  // previewSize 可能是旋转后的尺寸，取较大值为宽
  final width = size.width > size.height ? size.width.toInt() : size.height.toInt();
  final height = size.width > size.height ? size.height.toInt() : size.width.toInt();

  return '$width × $height @ 30fps';
}
