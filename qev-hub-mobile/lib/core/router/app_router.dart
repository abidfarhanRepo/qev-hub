import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/auth/presentation/auth_provider.dart';
import '../../core/constants/route_constants.dart';
import '../../data/models/user.dart';
import '../../shared/widgets/main_screen.dart';

/// App router configuration with auth guards
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router({required ProviderContainer container}) {
    return GoRouter(
      initialLocation: RouteConstants.splash,
      navigatorKey: _rootNavigatorKey,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final authState = container.read(authStateProvider);
        final isAuthenticated = authState.value == AppAuthState.authenticated;
        final isLoggingIn = state.matchedLocation == RouteConstants.login ||
            state.matchedLocation == RouteConstants.signUp ||
            state.matchedLocation == RouteConstants.forgotPassword;

        // Splash screen logic
        if (state.matchedLocation == RouteConstants.splash) {
          return null;
        }

        // Redirect to login if not authenticated
        if (!isAuthenticated && !isLoggingIn) {
          return RouteConstants.login;
        }

        // Redirect to home if authenticated and trying to access auth pages
        if (isAuthenticated && isLoggingIn) {
          return RouteConstants.home;
        }

        return null;
      },
      routes: [
        // Splash Screen
        GoRoute(
          path: RouteConstants.splash,
          name: 'splash',
          pageBuilder: (context, state) => const MaterialPage(
            child: SplashScreen(),
          ),
        ),

        // Auth Routes
        GoRoute(
          path: RouteConstants.login,
          name: 'login',
          pageBuilder: (context, state) => const MaterialPage(
            child: LoginScreen(),
          ),
        ),
        GoRoute(
          path: RouteConstants.signUp,
          name: 'sign-up',
          pageBuilder: (context, state) => const MaterialPage(
            child: SignUpScreen(),
          ),
        ),
        GoRoute(
          path: RouteConstants.forgotPassword,
          name: 'forgot-password',
          pageBuilder: (context, state) => const MaterialPage(
            child: ForgotPasswordScreen(),
          ),
        ),

        // Main App with Bottom Navigation - Shell Route
        ShellRoute(
          builder: (context, state, child) {
            return MainScreen();
          },
          routes: [
            // Home / Dashboard
            GoRoute(
              path: RouteConstants.home,
              name: 'home',
              pageBuilder: (context, state) => const MaterialPage(
                child: DashboardScreen(),
              ),
            ),

            // Marketplace (placeholder for now)
            GoRoute(
              path: RouteConstants.marketplace,
              name: 'marketplace',
              pageBuilder: (context, state) => MaterialPage(
                child: _PlaceholderScreen(
                  title: 'Marketplace',
                  message: 'Browse and purchase electric vehicles from verified manufacturers.',
                  phase: 'Phase 4',
                ),
              ),
            ),

            // Charging Stations (placeholder for now)
            GoRoute(
              path: RouteConstants.charging,
              name: 'charging',
              pageBuilder: (context, state) => MaterialPage(
                child: _PlaceholderScreen(
                  title: 'Charging Stations',
                  message: 'Find EV charging stations across Qatar with real-time availability.',
                  phase: 'Phase 5',
                ),
              ),
            ),

            // Orders (placeholder for now)
            GoRoute(
              path: RouteConstants.orders,
              name: 'orders',
              pageBuilder: (context, state) => MaterialPage(
                child: _PlaceholderScreen(
                  title: 'My Orders',
                  message: 'Track your vehicle orders from factory to delivery.',
                  phase: 'Phase 7',
                ),
              ),
            ),

            // Profile / Settings (placeholder for now)
            GoRoute(
              path: RouteConstants.profile,
              name: 'profile',
              pageBuilder: (context, state) => MaterialPage(
                child: _PlaceholderScreen(
                  title: 'Profile & Settings',
                  message: 'Manage your profile and application settings.',
                  phase: 'Phase 9',
                ),
              ),
            ),
          ],
        ),
      ],

      // Error page
      errorBuilder: (context, state) => const _ErrorScreen(),
    );
  }
}

/// Placeholder screen for unimplemented routes
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String message;
  final String phase;

  const _PlaceholderScreen({
    required this.title,
    required this.message,
    this.phase = 'Coming Soon',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  phase,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error screen for routing errors
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page not found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('The requested page does not exist.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
