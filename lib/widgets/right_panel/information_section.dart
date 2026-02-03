import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../theme/app_theme.dart';

class InformationSection extends HookWidget {
  final int storedDataCount;
  final int averagesCount;

  const InformationSection({super.key, required this.storedDataCount, required this.averagesCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Text(
          'Information',
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: .w600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const .all(10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: .circular(4),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'number of stored data:',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$storedDataCount',
                style: const TextStyle(
                  color: AppTheme.pupilColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '(averages: $averagesCount)',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
