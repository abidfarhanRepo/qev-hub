import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../../data/models/user.dart';
import '../../../data/models/vehicle.dart';
import '../data/models/user_vehicle.dart';

/// Profile state
class ProfileState {
  final AppUser? user;
  final List<Vehicle> availableVehicles;
  final UserVehicle? selectedVehicle;
  final bool isLoading;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String selectedLanguage;

  const ProfileState({
    this.user,
    this.availableVehicles = const [],
    this.selectedVehicle,
    this.isLoading = false,
    this.notificationsEnabled = true,
    this.darkModeEnabled = true,
    this.selectedLanguage = 'en',
  });

  ProfileState copyWith({
    AppUser? user,
    List<Vehicle>? availableVehicles,
    UserVehicle? selectedVehicle,
    bool? isLoading,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? selectedLanguage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      availableVehicles: availableVehicles ?? this.availableVehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      isLoading: isLoading ?? this.isLoading,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

/// Profile provider
class ProfileNotifier extends StateNotifier<ProfileState> {
  final Ref _ref;

  ProfileNotifier(this._ref) : super(const ProfileState()) {
    _initialize();
  }

  SupabaseClient get _supabase => _ref.read(supabaseClientProvider);

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      // Get current user
      final userAsync = _ref.read(currentUserProvider);
      final user = userAsync.value;

      // Load available vehicles
      final vehiclesResponse = await _supabase
          .from('vehicles')
          .select()
          .order('manufacturer');
      final vehicles = (vehiclesResponse as List)
          .cast<Map<String, dynamic>>()
          .map((v) => Vehicle.fromJson(v))
          .toList();

      // Load user's selected vehicle
      UserVehicle? selectedVehicle;
      if (user != null) {
        final userVehicleResponse = await _supabase
            .from('user_vehicles')
            .select()
            .eq('user_id', user.id)
            .eq('is_active', true)
            .maybeSingle();
        if (userVehicleResponse != null) {
          selectedVehicle = UserVehicle.fromJson(userVehicleResponse);
        }
      }

      state = state.copyWith(
        user: user,
        availableVehicles: vehicles,
        selectedVehicle: selectedVehicle,
        isLoading: false,
      );
    } catch (e) {
      print('Error initializing profile: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// Refresh profile data
  Future<void> refresh() async {
    await _initialize();
  }

  /// Update vehicle selection
  Future<void> selectVehicle(String vehicleId, Vehicle vehicle) async {
    if (state.user == null) return;

    state = state.copyWith(isLoading: true);
    try {
      final vehicleName = '${vehicle.manufacturer} ${vehicle.model}';

      // First deactivate all existing vehicles
      await _supabase
          .from('user_vehicles')
          .update({'is_active': false})
          .eq('user_id', state.user!.id);

      // Then insert or update the selected vehicle
      final existing = await _supabase
          .from('user_vehicles')
          .select()
          .eq('user_id', state.user!.id)
          .eq('vehicle_id', vehicleId)
          .maybeSingle();

      if (existing != null) {
        // Reactivate existing
        await _supabase
            .from('user_vehicles')
            .update({
              'is_active': true,
              'vehicle_name': vehicleName,
              'manufacturer': vehicle.manufacturer,
              'model': vehicle.model,
              'battery_capacity': vehicle.batteryCapacity ?? 60.0,
              'range': (vehicle.range ?? 400).toDouble(),
              'image_url': vehicle.imageUrl,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existing['id']);
      } else {
        // Insert new
        await _supabase.from('user_vehicles').insert({
          'user_id': state.user!.id,
          'vehicle_id': vehicleId,
          'vehicle_name': vehicleName,
          'manufacturer': vehicle.manufacturer,
          'model': vehicle.model,
          'battery_capacity': vehicle.batteryCapacity ?? 60.0,
          'range': (vehicle.range ?? 400).toDouble(),
          'image_url': vehicle.imageUrl,
          'is_active': true,
        });
      }

      final selectedVehicle = UserVehicle(
        id: '',
        userId: state.user!.id,
        vehicleId: vehicleId,
        vehicleName: vehicleName,
        manufacturer: vehicle.manufacturer,
        model: vehicle.model,
        batteryCapacity: vehicle.batteryCapacity ?? 60.0,
        range: (vehicle.range ?? 400).toDouble(),
        imageUrl: vehicle.imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        selectedVehicle: selectedVehicle,
        isLoading: false,
      );
    } catch (e) {
      print('Error selecting vehicle: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// Toggle notifications
  Future<void> toggleNotifications(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    // TODO: Save to user preferences
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode(bool enabled) async {
    state = state.copyWith(darkModeEnabled: enabled);
    // TODO: Save to user preferences
  }

  /// Update language
  Future<void> updateLanguage(String language) async {
    state = state.copyWith(selectedLanguage: language);
    // TODO: Save to user preferences
  }

  /// Logout
  Future<void> logout() async {
    await _supabase.auth.signOut();
    state = state.copyWith(user: null);
  }
}

/// Profile provider definition
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(ref),
);