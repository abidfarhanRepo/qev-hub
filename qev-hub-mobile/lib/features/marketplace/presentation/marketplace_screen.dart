import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../../shared/widgets/vehicle_card.dart';
import '../../../../data/models/vehicle.dart';
import '../presentation/vehicle_provider.dart';

/// Marketplace screen with vehicle browsing and filtering
class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final vehicles = ref.read(vehicleListProvider);
      if (vehicles.valueOrNull?.hasMore == true) {
        ref.read(vehicleListProvider.notifier).loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(vehicleListProvider);
    final savedVehicles = ref.watch(savedVehiclesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with search and filter
            _buildHeader(context),

            // Vehicle list/grid
            Expanded(
              child: vehiclesAsync.when(
                data: (result) {
                  if (result.vehicles.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildVehicleGrid(result.vehicles, savedVehicles);
                },
                loading: () => const Center(child: AppLoader(size: 32)),
                error: (_, __) => _buildErrorState(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Title and actions row
          Row(
            children: [
              const Text(
                'Marketplace',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // View toggle
              IconButton(
                icon: Icon(
                  _isGridView ? Icons.view_list : Icons.grid_view,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
              // Filter button
              IconButton(
                icon: const Icon(
                  Icons.filter_list,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => _showFilterModal(context),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search vehicles...',
              prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textTertiary),
                      onPressed: () {
                        _searchController.clear();
                        _clearSearch();
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
            style: const TextStyle(color: AppColors.textPrimary),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                _search(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleGrid(List<Vehicle> vehicles, Set<String> savedVehicles) {
    if (_isGridView) {
      return GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.70,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return VehicleCard(
            vehicle: vehicle,
            isSaved: savedVehicles.contains(vehicle.id),
            onTap: () => context.push('/marketplace/${vehicle.id}'),
            onSave: () => _toggleSave(vehicle.id),
          );
        },
      );
    } else {
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: VehicleCard(
              vehicle: vehicle,
              isSaved: savedVehicles.contains(vehicle.id),
              onTap: () => context.push('/marketplace/${vehicle.id}'),
              onSave: () => _toggleSave(vehicle.id),
            ),
          );
        },
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.electric_car_outlined,
                size: 48,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No vehicles found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your filters or search terms',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(vehicleListProvider.notifier).clearFilter();
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load vehicles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(vehicleListProvider.notifier).refresh();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _search(String query) {
    final currentFilter = ref.read(vehicleFilterProvider);
    ref.read(vehicleListProvider.notifier).applyFilter(
          currentFilter.copyWith(searchQuery: query),
        );
  }

  void _clearSearch() {
    final currentFilter = ref.read(vehicleFilterProvider);
    ref.read(vehicleListProvider.notifier).applyFilter(
          currentFilter.copyWith(searchQuery: null),
        );
  }

  void _toggleSave(String vehicleId) {
    // Implement toggle save
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VehicleFilterModal(),
    );
  }
}

/// Vehicle filter modal
class VehicleFilterModal extends ConsumerStatefulWidget {
  const VehicleFilterModal({super.key});

  @override
  ConsumerState<VehicleFilterModal> createState() => _VehicleFilterModalState();
}

class _VehicleFilterModalState extends ConsumerState<VehicleFilterModal> {
  VehicleType? _selectedVehicleType;
  double _maxPrice = 500000;
  int _minRange = 0;
  bool _inStockOnly = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Filter options
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle type
                  _buildSectionTitle('Vehicle Type'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: VehicleType.values.map((type) {
                      return FilterChip(
                        label: Text(_getVehicleTypeLabel(type)),
                        selected: _selectedVehicleType == type,
                        onSelected: (selected) {
                          setState(() {
                            _selectedVehicleType = selected ? type : null;
                          });
                        },
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Price range
                  _buildSectionTitle('Max Price: QAR ${_maxPrice.toStringAsFixed(0)}'),
                  const SizedBox(height: 12),
                  Slider(
                    value: _maxPrice,
                    min: 50000,
                    max: 500000,
                    divisions: 10,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        _maxPrice = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Min range
                  _buildSectionTitle('Min Range: ${_minRange} km'),
                  const SizedBox(height: 12),
                  Slider(
                    value: _minRange.toDouble(),
                    min: 0,
                    max: 600,
                    divisions: 12,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        _minRange = value.toInt();
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // In stock only
                  SwitchListTile(
                    title: const Text('In Stock Only'),
                    subtitle: const Text('Show only available vehicles'),
                    value: _inStockOnly,
                    onChanged: (value) {
                      setState(() {
                        _inStockOnly = value;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Apply button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  String _getVehicleTypeLabel(VehicleType type) {
    switch (type) {
      case VehicleType.ev:
        return 'Electric';
      case VehicleType.phev:
        return 'Hybrid';
      case VehicleType.fcev:
        return 'Fuel Cell';
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedVehicleType = null;
      _maxPrice = 500000;
      _minRange = 0;
      _inStockOnly = false;
    });
    ref.read(vehicleListProvider.notifier).clearFilter();
    context.pop();
  }

  void _applyFilters() {
    final filter = VehicleFilter(
      vehicleTypes: _selectedVehicleType != null ? [_selectedVehicleType!] : null,
      maxPrice: _maxPrice,
      minRange: _minRange,
      inStockOnly: _inStockOnly,
    );

    ref.read(vehicleListProvider.notifier).applyFilter(filter);
    context.pop();
  }
}
