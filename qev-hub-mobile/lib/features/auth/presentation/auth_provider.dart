import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user.dart';

/// Provider for Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRepository(client);
});

/// Provider for current auth state
final authStateProvider = StreamProvider<AppAuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Provider for current user
final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getCurrentUser();
});

/// Provider for user profile
final userProfileProvider =
    FutureProvider.family<UserProfile?, String>((ref, userId) async {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getUserProfile(userId);
});

/// Auth state notifier for actions
class AuthNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final user = await _repository.getCurrentUser();
    state = AsyncValue.data(user);
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? name,
    AppUserRole? role,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.signUp(
      email: email,
      password: password,
      name: name,
      role: role,
    );

    if (result is Success) {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } else {
      state = const AsyncValue.data(null);
    }

    return result;
  }

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.signIn(
      email: email,
      password: password,
    );

    if (result is Success) {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } else {
      state = const AsyncValue.data(null);
    }

    return result;
  }

  Future<AuthResult> signOut() async {
    state = const AsyncValue.loading();
    final result = await _repository.signOut();
    state = const AsyncValue.data(null);
    return result;
  }

  Future<AuthResult> sendPasswordResetEmail(String email) async {
    return _repository.sendPasswordResetEmail(email);
  }

  Future<AuthResult> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final result = await _repository.updateProfile(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
    );

    if (result is Success) {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    }

    return result;
  }
}

/// Provider for AuthNotifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AppUser?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value == AppAuthState.authenticated;
});

/// Provider to get current user value synchronously
final currentUserSyncProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.value;
});
