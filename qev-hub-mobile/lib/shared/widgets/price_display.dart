import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Widget for displaying formatted prices with QAR currency
class PriceDisplay extends StatelessWidget {
  final double price;
  final double? compareAtPrice;
  final bool showCurrency;
  final bool showSavings;
  final double? savingsAmount;
  final double? savingsPercentage;
  final TextStyle? style;
  final TextStyle? compareAtStyle;
  final TextStyle? labelStyle;

  const PriceDisplay({
    super.key,
    required this.price,
    this.compareAtPrice,
    this.showCurrency = true,
    this.showSavings = true,
    this.savingsAmount,
    this.savingsPercentage,
    this.style,
    this.compareAtStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final hasSavings = compareAtPrice != null && compareAtPrice! > price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Compare at price (if higher)
        if (hasSavings)
          Text(
            formatPrice(compareAtPrice!),
            style: (compareAtStyle ??
                    const TextStyle(
                      fontSize: 14,
                      color: AppColors.textTertiary,
                      decoration: TextDecoration.lineThrough,
                    ))
                .merge(style),
          ),

        // Main price
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (showCurrency) ...[
              Text(
                'QAR ',
                style: (labelStyle ??
                        const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ))
                    .merge(style),
              ),
            ],
            Text(
              formatPrice(price),
              style: (style ??
                      const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ))
                  .merge(style),
            ),
          ],
        ),

        // Savings indicator
        if (showSavings && hasSavings && (savingsAmount != null || savingsPercentage != null))
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: _buildSavingsIndicator(),
          ),
      ],
    );
  }

  Widget _buildSavingsIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.savings_outlined,
          size: 14,
          color: AppColors.success,
        ),
        if (savingsPercentage != null) ...[
          const SizedBox(width: 4),
          Text(
            '${savingsPercentage!.toStringAsFixed(0)}% savings',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (savingsAmount != null && savingsAmount! > 0) ...[
          if (savingsPercentage != null) const SizedBox(width: 8),
          Text(
            '(QAR ${savingsAmount!.toStringAsFixed(0)})',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.success,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  String formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)},000';
    } else {
      return price.toStringAsFixed(0);
    }
  }
}

/// Compact price display for cards and lists
class CompactPriceDisplay extends StatelessWidget {
  final double price;
  final bool showCurrency;
  final bool highlight;

  const CompactPriceDisplay({
    super.key,
    required this.price,
    this.showCurrency = true,
    this.highlight = true,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          if (showCurrency)
            TextSpan(
              text: 'QAR ',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          TextSpan(
            text: price.toStringAsFixed(0),
            style: TextStyle(
              fontSize: highlight ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: highlight ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Price range display for filtering
class PriceRangeDisplay extends StatelessWidget {
  final double minPrice;
  final double maxPrice;

  const PriceRangeDisplay({
    super.key,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'QAR ${minPrice.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '—',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Text(
          'QAR ${maxPrice.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
