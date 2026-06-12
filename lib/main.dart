import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dashboard/screens/dashboard_shell.dart';
import 'services/preferences_service.dart';

Future<void> main() async {
  // Ensures the Flutter engine is ready before we touch any plugins
  // (required by shared_preferences on cold start).
  WidgetsFlutterBinding.ensureInitialized();

  // Load all persisted preferences from disk. The service is fully
  // hydrated before the first frame so every screen sees the user's
  // saved choices from the very beginning.
  final prefs = await PreferencesService.load();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.prefs, super.key});

  final PreferencesService prefs;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _mapThemeMode(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };
  }

  Locale _mapLocale(AppLanguage lang) {
    return switch (lang) {
      AppLanguage.english => const Locale('en', 'US'),
      AppLanguage.spanish => const Locale('es', 'ES'),
      AppLanguage.french => const Locale('fr', 'FR'),
      AppLanguage.filipino => const Locale('fil', 'PH'),
      AppLanguage.japanese => const Locale('ja', 'JP'),
    };
  }

  /// Picks the right [ColorScheme] for the given brightness.
  ///
  /// Decision order:
  /// 1. If the user has "Dynamic color" enabled AND the device supplied
  ///    a Material You palette, use the harmonized dynamic scheme.
  /// 2. Otherwise, use the user's static [AppThemePreset.seed].
  ColorScheme _resolveScheme(
    ColorScheme? dynamicLight,
    ColorScheme? dynamicDark,
    Brightness brightness,
  ) {
    final seed = widget.prefs.activePreset.seed;
    if (!widget.prefs.useDynamicColor) {
      return ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
    }
    final dynamicScheme = brightness == Brightness.light
        ? dynamicLight
        : dynamicDark;
    if (dynamicScheme != null) {
      return dynamicScheme.harmonized();
    }
    if (kDebugMode) {
      // ignore: avoid_print
      print(
        '[DynamicColor] No $brightness palette available from the OS. '
        'Falling back to preset seed (${seed.toARGB32().toRadixString(16)}). '
        'This is normal on emulators without Material You wallpaper or '
        'when the user disabled Material You in system Settings.',
      );
    }
    return ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = widget.prefs;
    return PreferencesScope(
      notifier: prefs,
      child: AnimatedBuilder(
        animation: prefs,
        builder: (context, _) {
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              final dynamicAvailable =
                  lightDynamic != null || darkDynamic != null;
              // Surface availability to the rest of the app.
              prefs.setDynamicColorAvailable(dynamicAvailable);

              return MaterialApp(
                themeMode: _mapThemeMode(prefs.themeMode),
                theme: ThemeData(
                  useMaterial3: true,
                  fontFamily: 'Emberly',
                  colorScheme: _resolveScheme(
                    lightDynamic,
                    darkDynamic,
                    Brightness.light,
                  ),
                  textTheme: const TextTheme(
                    headlineLarge: TextStyle(fontWeight: FontWeight.w900),
                    headlineMedium: TextStyle(fontWeight: FontWeight.w800),
                    bodyLarge: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  fontFamily: 'Emberly',
                  colorScheme: _resolveScheme(
                    lightDynamic,
                    darkDynamic,
                    Brightness.dark,
                  ),
                ),
                locale: _mapLocale(prefs.language),
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('es', 'ES'),
                  Locale('fr', 'FR'),
                  Locale('fil', 'PH'),
                  Locale('ja', 'JP'),
                ],
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.linear(prefs.textScale),
                    ),
                    child: child ?? const SizedBox.shrink(),
                  );
                },
                debugShowCheckedModeBanner: false,
                home: const DashboardShell(),
              );
            },
          );
        },
      ),
    );
  }
}
