import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/repositories/charging_repository_simple.dart';
import '../../../data/models/charging_station_v2.dart';
import 'booking_provider.dart';

/// Simple booking flow screen
class BookingFlowSimple extends ConsumerStatefulWidget {
  final String chargerId;
  final String stationId;

  const BookingFlowSimple({
    required this.chargerId,
    required this.stationId,
    super.key,
  });

  @override
  ConsumerState<BookingFlowSimple> createState() => _BookingFlowSimpleState();
}

class _BookingFlowSimpleState extends ConsumerState<BookingFlowSimple> {
  final SimpleChargingRepository _repository = SimpleChargingRepository(Supabase.instance.client);

  // Data
  ChargingStationSimple? _station;
  Map<String, dynamic>? _charger;

  // Form state
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _selectedDuration = 60; // minutes
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final station = await _repository.getStationById(widget.stationId);

    // Get charger details
    final client = Supabase.instance.client;
    final chargerData = await client
        .from('chargers')
        .select()
        .eq('id', widget.chargerId)
        .single();

    setState(() {
      _station = station;
      _charger = chargerData as Map<String, dynamic>?;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_station == null || _charger == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Charging Session'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Station info
            _buildSectionTitle('Charging Station'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.ev_station),
                title: Text(_station!.name),
                subtitle: Text(_station!.address),
              ),
            ),
            const SizedBox(height: 16),

            // Charger info
            _buildSectionTitle('Charger'),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.bolt, color: Colors.white),
                ),
                title: Text('Charger ${_charger!['charger_code'] ?? 'N/A'}'),
                subtitle: Text('${_charger!['power_output_kw'] ?? 'N/A'} kW'),
              ),
            ),
            const SizedBox(height: 24),

            // Date selection
            _buildSectionTitle('Select Date'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(DateFormat('EEE, MMM d, yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectDate,
              ),
            ),
            const SizedBox(height: 16),

            // Time selection
            _buildSectionTitle('Select Time'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: Text('${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectTime,
              ),
            ),
            const SizedBox(height: 16),

            // Duration selection
            _buildSectionTitle('Duration'),
            Card(
              child: Column(
                children: [
                  RadioListTile<int>(
                    title: const Text('30 minutes'),
                    value: 30,
                    groupValue: _selectedDuration,
                    onChanged: (value) => setState(() => _selectedDuration = value!),
                  ),
                  RadioListTile<int>(
                    title: const Text('1 hour'),
                    value: 60,
                    groupValue: _selectedDuration,
                    onChanged: (value) => setState(() => _selectedDuration = value!),
                  ),
                  RadioListTile<int>(
                    title: const Text('2 hours'),
                    value: 120,
                    groupValue: _selectedDuration,
                    onChanged: (value) => setState(() => _selectedDuration = value!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Price estimate
            _buildSectionTitle('Estimated Cost'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text('QAR ${(_calculatePrice()).toStringAsFixed(2)}'),
                subtitle: const Text('Estimated total'),
              ),
            ),
            const SizedBox(height: 24),

            // Error message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirm Booking', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  double _calculatePrice() {
    // Simple pricing: QAR 0.50 per minute
    return (_selectedDuration * 0.5);
  }

  Future<void> _confirmBooking() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Combine date and time
      final startTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final endTime = startTime.add(Duration(minutes: _selectedDuration));

      final client = Supabase.instance.client;
      final userId = client.auth.currentUser?.id;

      if (userId == null) {
        throw Exception('You must be logged in to make a booking');
      }

      // Create booking
      final response = await client.from('bookings').insert({
        'user_id': userId,
        'charger_id': widget.chargerId,
        'station_id': widget.stationId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'status': 'pending',
        'estimated_cost': _calculatePrice(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).select().single();

      if (response == null) {
        throw Exception('Failed to create booking');
      }

      // Show success dialog
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Booking Confirmed!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking ID: ${response['id'].toString().substring(0, 8).toUpperCase()}'),
                const SizedBox(height: 8),
                Text('Date: ${DateFormat('MMM d, yyyy').format(startTime)}'),
                Text('Time: ${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}'),
                Text('Cost: QAR ${_calculatePrice().toStringAsFixed(2)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Invalidate the bookings provider to refresh the list
                  ref.invalidate(upcomingBookingsProvider);
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to station detail
                  context.go('/bookings'); // Navigate to bookings
                },
                child: const Text('View My Bookings'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isProcessing = false;
      });
    }
  }
}
