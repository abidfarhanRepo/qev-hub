import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User roles
enum AppUserRole {
  @JsonValue('consumer')
  consumer,
  @JsonValue('manufacturer')
  manufacturer,
  @JsonValue('admin')
  admin,
}

/// User model with freezed
@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String email,
    String? name,
    String? phone,
    @AppUserRoleConverter() AppUserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

/// UserRole converter for JSON serialization
class AppUserRoleConverter implements JsonConverter<AppUserRole, String> {
  const AppUserRoleConverter();

  @override
  AppUserRole fromJson(String json) {
    return AppUserRole.values.firstWhere(
      (e) => e.name == json,
      orElse: () => AppUserRole.consumer,
    );
  }

  @override
  String toJson(AppUserRole object) => object.name;
}

/// Extended user profile from profiles table
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    String? companyName,
    String? businessLicense,
    String? verificationStatus,
    DateTime? verifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

/// Auth state enum
enum AppAuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Auth result wrapper
@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult.success() = Success;
  const factory AuthResult.failure(String message) = Failure;
}
