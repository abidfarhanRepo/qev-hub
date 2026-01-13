import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Badge component for displaying savings amount/percentage
class SavingsBadge extends StatelessWidget {
  final double? percentage;
  final double? amount;
  final bool showAmount;
  final bool compact;

  const SavingsBadge({
    super.key,
    this.percentage,
    this.amount,
    this.showAmount = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (percentage == null && amount == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.success.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.savings_outlined,
            size: compact ? 14 : 16,
            color: AppColors.success,
          ),
          if (!compact) const SizedBox(width: 6),
          if (percentage != null) ...[
            if (!compact) const SizedBox(width: 4),
            Text(
              '${percentage!.toStringAsFixed(0)}% OFF',
              style: TextStyle(
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ],
          if (showAmount && amount != null && amount! > 0) ...[
            if (percentage != null && !compact) const SizedBox(width: 8),
            Text(
              'Save QAR ${amount!.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w500,
                color: AppColors.success,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact pill-style savings badge
class SavingsBadgePill extends StatelessWidget {
  final double percentage;
  final bool showIcon;

  const SavingsBadgePill({
    super.key,
    required this.percentage,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon)
            const Icon(
              Icons.local_offer,
              size: 14,
              color: Colors.white,
            ),
          if (showIcon) const SizedBox(width: 4),
          Text(
            '${percentage.toStringAsFixed(0)}% OFF',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
