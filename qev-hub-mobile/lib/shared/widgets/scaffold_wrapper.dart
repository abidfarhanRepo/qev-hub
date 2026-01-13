import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'app_loader.dart';

/// Base scaffold wrapper with consistent styling
class ScaffoldWrapper extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final bool showAppBar;
  final bool centerTitle;
  final Widget? leading;
  final bool isLoading;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;

  const ScaffoldWrapper({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.showAppBar = true,
    this.centerTitle = true,
    this.leading,
    this.isLoading = false,
    this.backgroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: showAppBar
          ? AppBar(
              title: title != null
                  ? Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
              centerTitle: centerTitle,
              actions: actions,
              leading: leading,
              bottom: bottom,
            )
          : null,
      body: Stack(
        children: [
          body,
          if (isLoading) const AppLoaderOverlay(),
        ],
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
    );
  }
}

/// Scaffold with refresh indicator
class RefreshableScaffold extends StatefulWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Future<void> Function() onRefresh;
  final Widget? bottomNavigationBar;

  const RefreshableScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    required this.onRefresh,
    this.bottomNavigationBar,
  });

  @override
  State<RefreshableScaffold> createState() => _RefreshableScaffoldState();
}

class _RefreshableScaffoldState extends State<RefreshableScaffold> {
  final Key _refreshKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return ScaffoldWrapper(
      title: widget.title,
      actions: widget.actions,
      bottomNavigationBar: widget.bottomNavigationBar,
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: widget.onRefresh,
        child: widget.body,
      ),
    );
  }
}
