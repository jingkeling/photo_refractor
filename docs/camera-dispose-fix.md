# CameraException: buildPreview() was called on a disposed CameraController

## 现象

关闭相机（Stop）时抛出：`CameraException(Disposed CameraController, buildPreview() was called on a disposed...)`。

## 原因

- 异常来自 **camera 插件**：`CameraPreview(controller)` 在 build/更新时会用 controller 去画预览，若 controller 已 dispose 就会报错。
- 根因是**时序**：点 Stop 后，同一帧内先执行 `build()`（此时仍用旧 controller 画了 `CameraPreview`），本帧结束才执行 `useEffect` 里的 `dispose()`。结果是 UI 还在用 controller，但 controller 已被释放，后续任意重建就会触发 `buildPreview()` 报错。

## 解决思路

1. **先清空状态**：在 dispose 逻辑里先把 `controller`、`isInitialized` 等置空/置 false，让下一次 build 不再构建 `CameraPreview(controller)`。
2. **再延迟释放**：用 `WidgetsBinding.instance.addPostFrameCallback` 在下一帧对**事先保存的** controller 调用 `dispose()`。

这样顺序变为：清空 state → 触发重建 → 下一帧界面已不再画预览 → 再 dispose，避免对已释放的 controller 调用 `buildPreview()`。
