import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

/// Main screen with bottom navigation
class MainScreen extends ConsumerStatefulWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  int _getIndexForRoute(String route) {
    final index = _tabs.indexWhere((tab) => route.startsWith(tab.route));
    return index >= 0 ? index : 0;
  }

  static const List<_TabItem> _tabs = [
    _TabItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home',
    ),
    _TabItem(
      icon: Icons.electric_car_outlined,
      activeIcon: Icons.electric_car,
      label: 'Marketplace',
      route: '/marketplace',
    ),
    _TabItem(
      icon: Icons.ev_station_outlined,
      activeIcon: Icons.ev_station,
      label: 'Charging',
      route: '/charging',
    ),
    _TabItem(
      icon: Icons.bookmark_outline,
      activeIcon: Icons.bookmark,
      label: 'Bookings',
      route: '/bookings',
    ),
    _TabItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Sync _currentIndex with current route
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final newIndex = _getIndexForRoute(currentRoute);
    if (_currentIndex != newIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentIndex = newIndex;
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.border,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final tab = entry.value;
                final isActive = _currentIndex == index;

                return _buildNavItem(
                  icon: isActive ? tab.activeIcon : tab.icon,
                  label: tab.label,
                  isActive: isActive,
                  onTap: () => _onTabTapped(index, tab.route),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index, String route) {
    setState(() {
      _currentIndex = index;
    });
    context.go(route);
  }
}

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
