import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

/// Authentication repository interface
abstract class AuthRepository {
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? name,
    AppUserRole? role,
  });

  Future<AuthResult> signIn({
    required String email,
    required String password,
  });

  Future<AuthResult> signOut();

  Future<AuthResult> sendPasswordResetEmail(String email);

  Future<AppUser?> getCurrentUser();

  Future<UserProfile?> getUserProfile(String userId);

  Future<AuthResult> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  });

  Stream<AppAuthState> get authStateChanges;
}

/// Supabase implementation of AuthRepository
class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  @override
  Stream<AppAuthState> get authStateChanges {
    return _client.auth.onAuthStateChange.map((state) {
      // For initialSession, check if there's actually a session
      if (state.event == AuthChangeEvent.initialSession) {
        return state.session != null
            ? AppAuthState.authenticated
            : AppAuthState.unauthenticated;
      }

      switch (state.event) {
        case AuthChangeEvent.signedIn:
          return AppAuthState.authenticated;
        case AuthChangeEvent.signedOut:
          return AppAuthState.unauthenticated;
        case AuthChangeEvent.userUpdated:
          return AppAuthState.authenticated;
        case AuthChangeEvent.passwordRecovery:
          return AppAuthState.authenticated;
        case AuthChangeEvent.tokenRefreshed:
          return AppAuthState.authenticated;
        default:
          return state.session != null
              ? AppAuthState.authenticated
              : AppAuthState.unauthenticated;
      }
    });
  }

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? name,
    AppUserRole? role,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'role': role?.name ?? AppUserRole.consumer.name,
        },
      );

      if (response.user != null) {
        // Create profile in profiles table
        if (response.user != null) {
          await _client.from('profiles').insert({
            'id': response.user!.id,
            'full_name': name,
            'role': role?.name ?? AppUserRole.consumer.name,
          });
        }
        return const AuthResult.success();
      } else {
        return const AuthResult.failure('Failed to create account');
      }
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return const AuthResult.success();
      } else {
        return const AuthResult.failure('Invalid email or password');
      }
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<AuthResult> signOut() async {
    try {
      await _client.auth.signOut();
      return const AuthResult.success();
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return const AuthResult.success();
    } on AuthException catch (e) {
      return AuthResult.failure(e.message);
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) return null;

    // Parse createdAt and updatedAt - they might be strings or DateTime
    DateTime? parsedCreatedAt;
    DateTime? parsedUpdatedAt;

    if (currentUser.createdAt is DateTime) {
      parsedCreatedAt = currentUser.createdAt as DateTime;
    } else if (currentUser.createdAt is String) {
      parsedCreatedAt = DateTime.tryParse(currentUser.createdAt as String);
    }

    if (currentUser.updatedAt is DateTime) {
      parsedUpdatedAt = currentUser.updatedAt as DateTime;
    } else if (currentUser.updatedAt is String) {
      parsedUpdatedAt = DateTime.tryParse(currentUser.updatedAt as String);
    }

    return AppUser(
      id: currentUser.id,
      email: currentUser.email ?? '',
      name: currentUser.userMetadata?['name'] as String?,
      role: _parseUserRole(currentUser.userMetadata?['role']),
      createdAt: parsedCreatedAt,
      updatedAt: parsedUpdatedAt,
    );
  }

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      if (response == null) return null;

      return UserProfile.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthResult> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      await _client.from('profiles').update({
        'full_name': fullName,
        'phone_number': phoneNumber,
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      return const AuthResult.success();
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }

  AppUserRole? _parseUserRole(dynamic role) {
    if (role == null) return null;
    try {
      return AppUserRole.values.firstWhere(
        (e) => e.name == role.toString(),
        orElse: () => AppUserRole.consumer,
      );
    } catch (_) {
      return AppUserRole.consumer;
    }
  }
}
