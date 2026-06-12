import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dashboard/screens/dashboard_shell.dart';
import 'services/preferences_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Single shared instance. Every route accesses it via
  // [PreferencesScope.of] so changes propagate everywhere.
  final PreferencesService _prefs = PreferencesService();

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
  ///
  /// [dynamicAvailable] is true iff the device returned at least one
  /// non-null dynamic scheme (light or dark). It is exposed to the UI
  /// so the preferences page can show whether the toggle is actually
  /// taking effect.
  ColorScheme _resolveScheme(
    ColorScheme? dynamicLight,
    ColorScheme? dynamicDark,
    bool dynamicAvailable,
    Brightness brightness,
  ) {
    final seed = _prefs.activePreset.seed;
    if (!_prefs.useDynamicColor) {
      return ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
    }
    final dynamicScheme = brightness == Brightness.light
        ? dynamicLight
        : dynamicDark;
    if (dynamicScheme != null) {
      // Harmonize so any existing hard-coded brand accents (e.g. on
      // per-tab gradient cards) still feel cohesive with the wallpaper.
      return dynamicScheme.harmonized();
    }
    // Dynamic color is on but the device didn't supply a palette.
    // Fall back to the static preset so the app still has good colors.
    if (kDebugMode) {
      // Helpful diagnostic in `flutter run` console.
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
    return PreferencesScope(
      notifier: _prefs,
      child: AnimatedBuilder(
        animation: _prefs,
        builder: (context, _) {
          return DynamicColorBuilder(
            builder: (lightDynamic, darkDynamic) {
              final dynamicAvailable =
                  lightDynamic != null || darkDynamic != null;
              // Surface the availability to the rest of the app so the
              // preferences page can display a "Not available on this
              // device" hint when the platform doesn't return a palette.
              _prefs.setDynamicColorAvailable(dynamicAvailable);

              return MaterialApp(
                themeMode: _mapThemeMode(_prefs.themeMode),
                theme: ThemeData(
                  useMaterial3: true,
                  fontFamily: 'Emberly',
                  colorScheme: _resolveScheme(
                    lightDynamic,
                    darkDynamic,
                    dynamicAvailable,
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
                    dynamicAvailable,
                    Brightness.dark,
                  ),
                ),
                locale: _mapLocale(_prefs.language),
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
                      textScaler: TextScaler.linear(_prefs.textScale),
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
