import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../theme/app_theme.dart';

class ConstantsSection extends HookWidget {
  const ConstantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: const [
        Text(
          'Constants',
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: .w600),
        ),
        SizedBox(height: 8),
        _ConstantRow(label: 'video:', value: 'infrared @ 3 fps'),
        _ConstantRow(label: 'magnif:', value: '25.47'),
      ],
    );
  }
}

class _ConstantRow extends HookWidget {
  final String label;
  final String value;

  const _ConstantRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 1),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
