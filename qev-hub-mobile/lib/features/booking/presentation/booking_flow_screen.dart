import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_loader.dart';
import '../../../data/models/charging_station.dart';
import '../../../data/models/charger.dart';
import '../../../data/models/booking.dart';

/// Booking flow steps
enum BookingStep {
  dateTime,
  confirmation,
  success,
}

/// Slot duration options
enum SlotDuration {
  minutes30,
  hour1,
  hours2,
}

extension SlotDurationExtension on SlotDuration {
  int get minutes {
    switch (this) {
      case SlotDuration.minutes30:
        return 30;
      case SlotDuration.hour1:
        return 60;
      case SlotDuration.hours2:
        return 120;
    }
  }

  String get label {
    switch (this) {
      case SlotDuration.minutes30:
        return '30 min';
      case SlotDuration.hour1:
        return '1 hour';
      case SlotDuration.hours2:
        return '2 hours';
    }
  }

  double get priceMultiplier {
    switch (this) {
      case SlotDuration.minutes30:
        return 0.5;
      case SlotDuration.hour1:
        return 1.0;
      case SlotDuration.hours2:
        return 1.8;
    }
  }
}

/// Booking flow state
class BookingFlowState {
  final BookingStep currentStep;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final SlotDuration? selectedDuration;
  final String? notes;
  final bool termsAccepted;
  final bool isLoading;
  final String? errorMessage;
  final Booking? createdBooking;

  const BookingFlowState({
    this.currentStep = BookingStep.dateTime,
    this.selectedDate,
    this.selectedTime,
    this.selectedDuration,
    this.notes,
    this.termsAccepted = false,
    this.isLoading = false,
    this.errorMessage,
    this.createdBooking,
  });

  BookingFlowState copyWith({
    BookingStep? currentStep,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    SlotDuration? selectedDuration,
    String? notes,
    bool? termsAccepted,
    bool? isLoading,
    String? errorMessage,
    Booking? createdBooking,
  }) {
    return BookingFlowState(
      currentStep: currentStep ?? this.currentStep,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      notes: notes ?? this.notes,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      createdBooking: createdBooking ?? this.createdBooking,
    );
  }

  bool get canProceedFromDateTime {
    return selectedDate != null && selectedTime != null && selectedDuration != null;
  }

  bool get canConfirm {
    return termsAccepted && canProceedFromDateTime;
  }
}

/// Booking flow screen - Multi-step wizard for booking charging sessions
class BookingFlowScreen extends ConsumerStatefulWidget {
  final ChargingStation station;
  final Charger? charger;

  const BookingFlowScreen({
    super.key,
    required this.station,
    this.charger,
  });

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late BookingFlowState _state;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _state = const BookingFlowState();

    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateState(BookingFlowState newState) {
    setState(() {
      _state = newState;
    });
  }

  Future<void> _createBooking() async {
    if (!_state.canConfirm) return;

    _updateState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Simulate booking creation (replace with actual API call)
      await Future.delayed(const Duration(seconds: 2));

      // Create a mock booking for demonstration
      final booking = Booking(
        id: 'BK${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_123', // Replace with actual user ID
        chargerId: widget.charger?.id ?? 'charger_123',
        stationId: widget.station.id,
        startTime: _combineDateTime(_state.selectedDate!, _state.selectedTime!),
        endTime: _combineDateTime(
          _state.selectedDate!,
          _state.selectedTime!,
        ).add(Duration(minutes: _state.selectedDuration!.minutes)),
        status: BookingStatus.confirmed,
        estimatedCost: _calculateEstimatedCost(),
        notes: _state.notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        charger: widget.charger,
        station: widget.station,
      );

      _updateState(_state.copyWith(
        isLoading: false,
        createdBooking: booking,
        currentStep: BookingStep.success,
      ));

      // Animate to success page
      _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      // Trigger success animation
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  DateTime _combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  double _calculateEstimatedCost() {
    final basePrice = 15.0; // Base price per hour (QAR)
    final duration = _state.selectedDuration;
    if (duration == null) return 0.0;
    return basePrice * duration.priceMultiplier;
  }

  void _goToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _nextStep() {
    if (_state.currentStep == BookingStep.dateTime && _state.canProceedFromDateTime) {
      _updateState(_state.copyWith(currentStep: BookingStep.confirmation));
      _goToStep(1);
    } else if (_state.currentStep == BookingStep.confirmation) {
      _createBooking();
    }
  }

  void _previousStep() {
    if (_state.currentStep == BookingStep.confirmation) {
      _updateState(_state.copyWith(currentStep: BookingStep.dateTime));
      _goToStep(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (_state.currentStep == BookingStep.dateTime) {
              context.pop();
            } else {
              _previousStep();
            }
          },
        ),
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          _buildProgressIndicator(),

          // PageView for steps
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                final step = BookingStep.values[page];
                _updateState(_state.copyWith(currentStep: step));
              },
              children: [
                _buildDateTimeStep(),
                _buildConfirmationStep(),
                _buildSuccessStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_state.currentStep) {
      case BookingStep.dateTime:
        return 'Book Charging Session';
      case BookingStep.confirmation:
        return 'Confirm Booking';
      case BookingStep.success:
        return 'Booking Confirmed';
    }
  }

  Widget _buildProgressIndicator() {
    final steps = BookingStep.values.length - 1; // Exclude success step
    final currentStep = _state.currentStep == BookingStep.success
        ? steps
        : _state.currentStep.index;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: AppColors.surface,
      child: Row(
        children: List.generate(steps, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.primary
                          : isCurrent
                              ? AppColors.primary
                              : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < steps - 1) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDateTimeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Station info card
          _buildStationInfoCard(),

          const SizedBox(height: 32),

          // Date selection
          _buildDateSelection(),

          const SizedBox(height: 32),

          // Time slot selection
          _buildTimeSlotSelection(),

          const SizedBox(height: 32),

          // Duration selection
          _buildDurationSelection(),

          const SizedBox(height: 32),

          // Price estimate
          _buildPriceEstimate(),

          const SizedBox(height: 24),

          // Continue button
          AppButton(
            text: 'Continue',
            onPressed: _state.canProceedFromDateTime ? _nextStep : null,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStationInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.ev_station,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.station.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.station.address,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            itemCount: 14,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = _state.selectedDate != null &&
                  _isSameDay(date, _state.selectedDate!);
              final isToday = _isSameDay(date, DateTime.now());

              return GestureDetector(
                onTap: () {
                  _updateState(_state.copyWith(selectedDate: date));
                },
                child: Container(
                  width: 56,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.E().format(date).substring(0, 3),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isToday ? 'Today' : DateFormat.MMM().format(date),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white.withOpacity(0.9)
                              : AppColors.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    final slots = _generateTimeSlots();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time Slot',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.5,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            final isSelected = _state.selectedTime != null &&
                _state.selectedTime!.hour == slot.hour &&
                _state.selectedTime!.minute == slot.minute;

            return GestureDetector(
              onTap: () {
                _updateState(_state.copyWith(selectedTime: slot));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    _formatTime(slot),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDurationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Duration',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: SlotDuration.values.map((duration) {
            final isSelected = _state.selectedDuration == duration;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: duration != SlotDuration.values.last ? 12 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    _updateState(_state.copyWith(selectedDuration: duration));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          duration.label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(15 * duration.priceMultiplier).toStringAsFixed(0)} QAR',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceEstimate() {
    final cost = _calculateEstimatedCost();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Estimated Cost',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${cost.toStringAsFixed(2)} QAR',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    final cost = _calculateEstimatedCost();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Station details
          _buildConfirmSection('Station Details', [
            _buildConfirmRow(Icons.location_on, widget.station.name),
            _buildConfirmRow(Icons.place, widget.station.address, isSubtle: true),
          ]),

          const SizedBox(height: 24),

          // Charger details
          if (widget.charger != null)
            _buildConfirmSection('Charger Details', [
              _buildConfirmRow(Icons.ev_station, widget.charger!.name),
              _buildConfirmRow(Icons.bolt, '${widget.charger!.powerKw.toInt()} kW'),
              _buildConfirmRow(Icons.settings_input_component, widget.charger!.connectorTypes.join(', '), isSubtle: true),
            ]),

          const SizedBox(height: 24),

          // Booking details
          _buildConfirmSection('Booking Details', [
            _buildConfirmRow(
              Icons.calendar_today,
              DateFormat('EEE, MMM d, yyyy').format(_state.selectedDate!),
            ),
            _buildConfirmRow(
              Icons.access_time,
              _formatTime(_state.selectedTime!) +
                  ' (${_state.selectedDuration!.label})',
            ),
            _buildConfirmRow(Icons.attach_money, '${cost.toStringAsFixed(2)} QAR', isAccent: true),
          ]),

          const SizedBox(height: 24),

          // Notes field
          _buildNotesField(),

          const SizedBox(height: 24),

          // Terms checkbox
          _buildTermsCheckbox(),

          const SizedBox(height: 16),

          // Error message
          if (_state.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _state.errorMessage!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Back',
                  onPressed: _previousStep,
                  variant: AppButtonVariant.secondary,
                  isFullWidth: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  text: 'Confirm Booking',
                  onPressed: _state.canConfirm ? _nextStep : null,
                  isLoading: _state.isLoading,
                  isFullWidth: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildConfirmRow(IconData icon, String text, {bool isSubtle = false, bool isAccent = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: isAccent
                ? AppColors.primary
                : isSubtle
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isAccent
                    ? AppColors.primary
                    : isSubtle
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: isAccent ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes (Optional)',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            maxLines: 3,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
            decoration: const InputDecoration(
              hintText: 'Add any special instructions...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            onChanged: (value) {
              _updateState(_state.copyWith(notes: value.trim()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _state.termsAccepted,
            onChanged: (value) {
              _updateState(_state.copyWith(termsAccepted: value ?? false));
            },
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary;
              }
              return AppColors.border;
            }),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _updateState(_state.copyWith(termsAccepted: !_state.termsAccepted));
            },
            child: const Text.rich(
              TextSpan(
                text: 'I agree to the ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
                children: [
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Cancellation Policy',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessStep() {
    final booking = _state.createdBooking;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Success animation
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Your charging session has been booked successfully',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Booking details card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    // Booking ID
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Booking ID',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          booking?.id.substring(0, 12).toUpperCase() ?? 'N/A',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 16),

                    // Station
                    _buildSuccessRow(Icons.ev_station, widget.station.name),

                    const SizedBox(height: 12),

                    // Date & Time
                    _buildSuccessRow(
                      Icons.calendar_today,
                      DateFormat('MMM d, yyyy - h:mm a').format(
                        booking?.startTime ?? DateTime.now(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Duration
                    _buildSuccessRow(
                      Icons.schedule,
                      _state.selectedDuration?.label ?? 'N/A',
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 16),

                    // Cost
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Cost',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${_calculateEstimatedCost().toStringAsFixed(2)} QAR',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // QR Code placeholder
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_2,
                        size: 120,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Scan for check-in',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // View bookings button
              AppButton(
                text: 'View My Bookings',
                onPressed: () {
                  context.go('/home');
                  // TODO: Navigate to bookings tab when implemented
                },
                isFullWidth: true,
              ),

              const SizedBox(height: 16),

              // Book another button
              AppButton(
                text: 'Book Another Session',
                onPressed: () {
                  context.pop();
                },
                variant: AppButtonVariant.outline,
                isFullWidth: true,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  List<TimeOfDay> _generateTimeSlots() {
    final slots = <TimeOfDay>[];
    for (int hour = 6; hour < 22; hour++) {
      slots.add(TimeOfDay(hour: hour, minute: 0));
      slots.add(TimeOfDay(hour: hour, minute: 30));
    }
    return slots;
  }
}
