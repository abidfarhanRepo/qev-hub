import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/repositories/charging_repository_simple.dart';
import '../../../data/models/charging_station_v2.dart';

/// Simple station detail screen
class StationDetailSimple extends ConsumerStatefulWidget {
  final String stationId;

  const StationDetailSimple({required this.stationId, super.key});

  @override
  ConsumerState<StationDetailSimple> createState() => _StationDetailSimpleState();
}

class _StationDetailSimpleState extends ConsumerState<StationDetailSimple> {
  final SimpleChargingRepository _repository = SimpleChargingRepository(Supabase.instance.client);

  ChargingStationSimple? _station;
  List<Map<String, dynamic>> _chargers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final station = await _repository.getStationById(widget.stationId);
    final chargers = await _repository.getChargersForStation(widget.stationId);

    setState(() {
      _station = station;
      _chargers = chargers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Loading ${_station?.name ?? 'station'}...'),
            ],
          ),
        ),
      );
    }

    if (_station == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Station Not Found')),
        body: const Center(
          child: Text('Station not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_station!.name),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.ev_station,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _station!.address,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Availability card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${_station!.availableChargers ?? 0}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text(
                              'Available',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.border,
                        ),
                        Column(
                          children: [
                            Text(
                              '${_station!.totalChargers ?? 0}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const Text(
                              'Total',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Chargers section
                  const Text(
                    'Available Chargers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_chargers.isEmpty)
                    const Center(
                      child: Text('No chargers available'),
                    )
                  else
                    ..._chargers.map((charger) => _buildChargerCard(charger)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChargerCard(Map<String, dynamic> charger) {
    final isAvailable = charger['is_enabled'] == true;
    final chargerId = charger['id'] as String?;
    final powerOutput = charger['power_output_kw'] as num?;
    final connectorType = charger['connector_type'] as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isAvailable ? Colors.green : Colors.red,
          child: Icon(
            isAvailable ? Icons.bolt : Icons.block,
            color: Colors.white,
          ),
        ),
        title: Text('Charger ${charger['charger_code'] ?? 'N/A'}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (powerOutput != null) Text('${powerOutput.toStringAsFixed(1)} kW'),
            if (connectorType != null) Text(connectorType),
          ],
        ),
        trailing: isAvailable && chargerId != null
            ? ElevatedButton(
                onPressed: () => _startBooking(chargerId, charger),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Book'),
              )
            : null,
      ),
    );
  }

  void _startBooking(String chargerId, Map<String, dynamic> charger) {
    if (_station == null) return;

    context.push(
      '/booking-simple?chargerId=$chargerId&stationId=${_station!.id}',
    );
  }
}
