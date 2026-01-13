import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/vehicle.dart';
import 'app_loader.dart';
import 'app_card.dart';

/// Reusable vehicle card for marketplace and related screens
class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool isSaved;
  final bool showSavings;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.onSave,
    this.isSaved = false,
    this.showSavings = true,
  });

  @override
  Widget build(BuildContext context) {
    final savingsPercentage = vehicle.savingsPercentage;
    final hasSavings = savingsPercentage != null && savingsPercentage > 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AppCard(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Image
            buildImage(context, hasSavings),

            // Vehicle Info
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Manufacturer and Model
                  Text(
                    '${vehicle.manufacturer} ${vehicle.model}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 5),

                  // Year and Range
                  Wrap(
                    spacing: 8,
                    runSpacing: 3,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${vehicle.year}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.battery_full_outlined,
                            size: 11,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            vehicle.range != null ? '${vehicle.range} km' : 'N/A',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price Row
                  buildPriceRow(hasSavings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(BuildContext context, bool hasSavings) {
    // Safely get image URL from images array or imageUrl field
    String? imageUrl;
    if (vehicle.images != null && vehicle.images!.isNotEmpty) {
      imageUrl = vehicle.images!.firstWhere(
        (url) => url.isNotEmpty,
        orElse: () => vehicle.imageUrl ?? '',
      );
    } else {
      imageUrl = vehicle.imageUrl;
    }

    final hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

    return Stack(
      children: [
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: hasValidImage
              ? ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                      child: AppLoader(size: 20),
                    ),
                    errorWidget: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.electric_car,
                        size: 40,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Icon(
                    Icons.electric_car,
                    size: 40,
                    color: AppColors.textTertiary,
                  ),
                ),
        ),

        // Savings Badge
        if (hasSavings && showSavings)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_offer,
                    size: 10,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${vehicle.savingsPercentage?.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Save Button
        if (onSave != null)
          Positioned(
            top: 6,
            right: 6,
            child: InkWell(
              onTap: onSave,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surface.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: isSaved ? AppColors.error : AppColors.textPrimary,
                ),
              ),
            ),
          ),

        // Availability Badge
        if (vehicle.availability == AvailabilityStatus.preOrder ||
            vehicle.availability == AvailabilityStatus.soldOut)
          Positioned(
            bottom: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: vehicle.availability == AvailabilityStatus.soldOut
                    ? AppColors.error
                    : AppColors.warning,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                vehicle.availability == AvailabilityStatus.preOrder
                    ? 'PRE-ORDER'
                    : 'SOLD OUT',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildPriceRow(bool hasSavings) {
    final displayPrice = vehicle.priceQar ?? vehicle.price;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasSavings && vehicle.brokerMarketPrice != null) ...[
                Text(
                  'QAR ${vehicle.brokerMarketPrice?.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              Text(
                'QAR ${displayPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        if (vehicle.stockCount != null && vehicle.stockCount! > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.success.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 12,
                  color: AppColors.success,
                ),
                const SizedBox(width: 3),
                Text(
                  '${vehicle.stockCount}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
