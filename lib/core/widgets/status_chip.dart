import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum StatusChipVariant { success, warning, danger, info, neutral }

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.variant = StatusChipVariant.neutral,
  });

  final String label;
  final StatusChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = _variantColors(variant);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colors.$2,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  ({Color $1, Color $2}) _variantColors(StatusChipVariant variant) {
    switch (variant) {
      case StatusChipVariant.success:
        return (
          $1: AppColors.success.withValues(alpha: 0.12),
          $2: AppColors.success,
        );
      case StatusChipVariant.warning:
        return (
          $1: AppColors.warning.withValues(alpha: 0.14),
          $2: AppColors.warning,
        );
      case StatusChipVariant.danger:
        return (
          $1: AppColors.danger.withValues(alpha: 0.12),
          $2: AppColors.danger,
        );
      case StatusChipVariant.info:
        return (
          $1: AppColors.info.withValues(alpha: 0.12),
          $2: AppColors.info,
        );
      case StatusChipVariant.neutral:
        return (
          $1: AppColors.textSecondary.withValues(alpha: 0.12),
          $2: AppColors.textSecondary,
        );
    }
  }
}