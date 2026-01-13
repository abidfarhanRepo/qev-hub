/// Route path constants
class RouteConstants {
  RouteConstants._();

  // Root
  static const String root = '/';
  static const String splash = '/splash';

  // Auth
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';

  // Main App
  static const String home = '/home';
  static const String marketplace = '/marketplace';
  static const String charging = '/charging';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Marketplace
  static const String vehicleDetail = '/vehicle/:id';

  // Orders
  static const String orderDetail = '/order/:id';
  static const String orderTracking = '/order/:id/tracking';
}
