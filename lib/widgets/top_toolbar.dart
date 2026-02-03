import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../theme/app_theme.dart';

class TopToolbar extends HookWidget {
  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onReset;

  const TopToolbar({super.key, required this.isRunning, required this.onStart, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: AppTheme.cardBackground,
      padding: const .symmetric(horizontal: 8),
      child: Row(
        children: [
          // 应用标题
          const Icon(Icons.remove_red_eye_outlined, color: AppTheme.pupilColor, size: 18),
          const SizedBox(width: 6),
          const Text(
            'PhotoRefractor',
            style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: .w600),
          ),
          const SizedBox(width: 24),

          // 菜单按钮
          const _MenuButton(label: 'File'),
          const _MenuButton(label: 'Settings'),
          const _MenuButton(label: 'Algorithm'),

          const Spacer(),

          // 四个操作按钮（移至最右侧，沿用原 Record/Reset 配色）
          _ToolButton(label: 'Camera', icon: Icons.camera_alt_outlined, isActive: isRunning, onPressed: onStart),
          const SizedBox(width: 8),
          _ToolButton(label: 'LED', icon: Icons.lightbulb_outline, color: AppTheme.recordButtonColor, onPressed: () {}),
          const SizedBox(width: 8),
          _ToolButton(label: 'Algorithm', icon: Icons.settings, onPressed: () {}),
          const SizedBox(width: 8),
          _ToolButton(
            label: 'New record',
            icon: Icons.add,
            color: AppTheme.startButtonColor,
            isNewRecord: true,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _ToolButton(label: 'Reset', icon: Icons.refresh, color: AppTheme.resetButtonColor, onPressed: onReset),
        ],
      ),
    );
  }
}

class _MenuButton extends HookWidget {
  final String label;

  const _MenuButton({required this.label});

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: TextButton(
        onPressed: () {
          // TODO: 实现菜单功能
        },
        style: TextButton.styleFrom(
          foregroundColor: isHovered.value ? AppTheme.textPrimary : AppTheme.textSecondary,
          backgroundColor: isHovered.value ? AppTheme.surfaceColor : Colors.transparent,
          padding: const .symmetric(horizontal: 12),
          minimumSize: const Size(0, 32),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}

/// 四个操作按钮（Camera、LED、Algorithm、New record），沿用原 Record/Reset 配色
class _ToolButton extends HookWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;
  final Color? color;
  final bool isNewRecord;

  const _ToolButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
    this.color,
    this.isNewRecord = false,
  });

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final buttonColor = color ?? (isActive ? AppTheme.refractionColor : AppTheme.textPrimary);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: SizedBox(
        height: 26,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 14, color: buttonColor),
          label: Text(label, style: TextStyle(fontSize: 11, color: buttonColor)),
          style: ElevatedButton.styleFrom(
            backgroundColor: isHovered.value ? buttonColor.withValues(alpha: 0.15) : AppTheme.surfaceColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            side: BorderSide(color: isHovered.value ? buttonColor : buttonColor.withValues(alpha: 0.5)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isNewRecord ? 6 : 4)),
          ),
        ),
      ),
    );
  }
}
