import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://wmumpqvvoydngcbffozu.supabase.co',
    anonKey: 'sb_publishable_X8w7x6ACuLE-UBQsoLnMIg_TvO4XxWZ',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Builder(
        builder: (context) {
          final container = ProviderScope.containerOf(context);
          final router = AppRouter.router(container: container);

          return MaterialApp.router(
            title: 'QEV Hub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
