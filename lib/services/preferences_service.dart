import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All possible theme modes the user can pick.
enum AppThemeMode { system, light, dark }

/// Static M3 theme presets the user can pick from. Each preset defines a
/// seed color that the [ColorScheme.fromSeed] generator turns into a full
/// Material 3 tonal palette for both light and dark modes.
enum AppThemePreset {
  /// The default brand blue — calm, trustworthy, professional.
  defaultBlue(
    label: 'Default',
    seed: Color(0xFF2F80ED),
    icon: Icons.water_drop_rounded,
  ),

  /// Cool teal/cyan — fresh, modern, ocean-like.
  oceanic(
    label: 'Oceanic',
    seed: Color(0xFF1F8FBF),
    icon: Icons.waves_rounded,
  ),

  /// Warm orange/red — energetic, friendly, sunset-like.
  sunset(
    label: 'Sunset',
    seed: Color(0xFFFF7043),
    icon: Icons.wb_twilight_rounded,
  ),

  /// Green/emerald — natural, calm, forest-like.
  forest(
    label: 'Forest',
    seed: Color(0xFF2E7D32),
    icon: Icons.forest_rounded,
  ),

  /// Purple/violet — creative, premium, lavender-like.
  lavender(
    label: 'Lavender',
    seed: Color(0xFF7B61FF),
    icon: Icons.local_florist_rounded,
  ),

  /// Pink/rose — playful, warm, rose-like.
  rose(
    label: 'Rose',
    seed: Color(0xFFD81B60),
    icon: Icons.local_florist_outlined,
  );

  const AppThemePreset({
    required this.label,
    required this.seed,
    required this.icon,
  });

  final String label;
  final Color seed;
  final IconData icon;
}

/// Language options. Add more locales here and the choice list updates.
enum AppLanguage { english, spanish, french, filipino, japanese }

/// Distance unit for any measurements shown in the app.
enum DistanceUnit { kilometers, miles }

/// Date format used throughout the app.
enum DateFormatStyle {
  systemDefault,
  usMdy, // 05/26/2026
  europeanDmy, // 26/05/2026
  iso, // 2026-05-26
  longText, // May 26, 2026
}

/// Currency display format.
enum CurrencyFormat { symbolBefore, symbolAfter, code }

/// First day of the week for calendar/attendance views.
enum WeekStartDay { sunday, monday, saturday }

/// A single, app-wide container for every user-configurable preference.
///
/// Exposed as a [ChangeNotifier] so screens can listen for changes.
/// Wiring this into [MaterialApp] lets theme mode and locale apply
/// globally.
///
/// ## Persistence
///
/// All values are mirrored to [SharedPreferences] under the
/// `school_app.prefs.*` key namespace. Writes are debounced (500 ms) so
/// rapid UI changes (e.g. dragging the text-size slider) only touch
/// disk once. To load previously-saved values, call
/// [PreferencesService.load] (async) before calling [runApp].
///
/// A full reset ([resetAll]) clears the corresponding keys from disk.
class PreferencesService extends ChangeNotifier {
  // ---------- Persistence key namespace ----------
  static const String _kPrefix = 'school_app.prefs.';

  // ---------- Appearance ----------
  AppThemeMode _themeMode = AppThemeMode.system;
  /// Whether the underlying device (Android 12+) returned a non-null
  /// Material You palette the last time [MyApp] built. The preferences
  /// page reads this so it can show a status hint next to the
  /// "Dynamic color" switch (e.g. "Not available on this device").
  /// This field is **runtime-only** — it is not persisted, because the
  /// platform capability is queried on every app launch.
  bool _dynamicColorAvailable = false;
  AppThemePreset _activePreset = AppThemePreset.defaultBlue;
  double _textScale = 1.0; // 0.85..1.4
  bool _useDynamicColor = true;

  // ---------- Notifications ----------
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _smsEnabled = false;
  bool _inAppSounds = true;
  bool _inAppBanners = true;
  bool _lockScreenPreview = true;
  bool _doNotDisturb = false;
  TimeOfDay _dndStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _dndEnd = const TimeOfDay(hour: 7, minute: 0);
  bool _notifyGrades = true;
  bool _notifyAttendance = true;
  bool _notifySchedule = true;
  bool _notifyPayments = true;
  bool _notifyAnnouncements = true;
  bool _notifyReminders = true;

  // ---------- Language & Region ----------
  AppLanguage _language = AppLanguage.english;
  String _region = 'United States';
  DateFormatStyle _dateFormat = DateFormatStyle.longText;
  DistanceUnit _distanceUnit = DistanceUnit.kilometers;
  CurrencyFormat _currencyFormat = CurrencyFormat.symbolBefore;
  String _currencyCode = 'USD';
  WeekStartDay _weekStart = WeekStartDay.sunday;

  // ---------- Accessibility ----------
  bool _reduceMotion = false;
  bool _reduceTransparency = false;
  bool _highContrastText = false;
  bool _boldText = false;
  bool _underlineLinks = false;
  bool _screenReaderOptimized = false;
  double _animationSpeed = 1.0; // 0.5..2.0
  bool _colorBlindAssist = false;

  // ---------- Privacy ----------
  bool _analyticsEnabled = true;
  bool _personalizationEnabled = true;
  bool _crashReportsEnabled = true;
  bool _shareUsageWithSchool = false;
  bool _showProfilePictureToClassmates = true;
  bool _showOnlineStatus = true;
  bool _allowReadReceipts = true;

  // ---------- Account ----------
  bool _twoFactorEnabled = false;
  bool _biometricLogin = false;
  bool _autoLogout = true;
  int _autoLogoutMinutes = 15; // 5/15/30/60
  bool _rememberMe = true;

  // ---------- Data & Storage ----------
  bool _autoSync = true;
  bool _wifiOnlyDownloads = true;
  bool _autoClearCache = false;
  int _cacheRetentionDays = 30;
  int _imageQuality = 80; // 50..100
  bool _offlineMode = false;

  // ---------- Persistence internals ----------
  SharedPreferences? _prefs;
  Timer? _debounce;
  final Set<String> _dirtyKeys = <String>{};

  /// Async-load constructor. Read every persisted value from
  /// [SharedPreferences] into the in-memory fields, falling back to
  /// defaults for any missing key. Call once at app startup before
  /// [runApp].
  static Future<PreferencesService> load() async {
    final sp = await SharedPreferences.getInstance();
    final svc = PreferencesService._(sp);
    svc._hydrate();
    return svc;
  }

  /// Private constructor used by [load]. Direct instantiation falls
  /// back to defaults; values are not persisted.
  PreferencesService();
  PreferencesService._(this._prefs);

  /// Populate fields from the [SharedPreferences] instance. Any key
  /// that is not present (e.g. a brand-new install or after
  /// [resetAll]) keeps its in-memory default.
  void _hydrate() {
    final p = _prefs!;
    _themeMode = _readEnum(p, 'themeMode', AppThemeMode.values, _themeMode);
    _activePreset =
        _readEnum(p, 'activePreset', AppThemePreset.values, _activePreset);
    _textScale = p.getDouble('textScale') ?? _textScale;
    _useDynamicColor = p.getBool('useDynamicColor') ?? _useDynamicColor;

    _pushEnabled = p.getBool('pushEnabled') ?? _pushEnabled;
    _emailEnabled = p.getBool('emailEnabled') ?? _emailEnabled;
    _smsEnabled = p.getBool('smsEnabled') ?? _smsEnabled;
    _inAppSounds = p.getBool('inAppSounds') ?? _inAppSounds;
    _inAppBanners = p.getBool('inAppBanners') ?? _inAppBanners;
    _lockScreenPreview = p.getBool('lockScreenPreview') ?? _lockScreenPreview;
    _doNotDisturb = p.getBool('doNotDisturb') ?? _doNotDisturb;
    _dndStart = _readTimeOfDay(p, 'dndStart', _dndStart);
    _dndEnd = _readTimeOfDay(p, 'dndEnd', _dndEnd);
    _notifyGrades = p.getBool('notifyGrades') ?? _notifyGrades;
    _notifyAttendance = p.getBool('notifyAttendance') ?? _notifyAttendance;
    _notifySchedule = p.getBool('notifySchedule') ?? _notifySchedule;
    _notifyPayments = p.getBool('notifyPayments') ?? _notifyPayments;
    _notifyAnnouncements =
        p.getBool('notifyAnnouncements') ?? _notifyAnnouncements;
    _notifyReminders = p.getBool('notifyReminders') ?? _notifyReminders;

    _language = _readEnum(p, 'language', AppLanguage.values, _language);
    _region = p.getString('region') ?? _region;
    _dateFormat =
        _readEnum(p, 'dateFormat', DateFormatStyle.values, _dateFormat);
    _distanceUnit = _readEnum(
      p,
      'distanceUnit',
      DistanceUnit.values,
      _distanceUnit,
    );
    _currencyFormat = _readEnum(
      p,
      'currencyFormat',
      CurrencyFormat.values,
      _currencyFormat,
    );
    _currencyCode = p.getString('currencyCode') ?? _currencyCode;
    _weekStart =
        _readEnum(p, 'weekStart', WeekStartDay.values, _weekStart);

    _reduceMotion = p.getBool('reduceMotion') ?? _reduceMotion;
    _reduceTransparency =
        p.getBool('reduceTransparency') ?? _reduceTransparency;
    _highContrastText = p.getBool('highContrastText') ?? _highContrastText;
    _boldText = p.getBool('boldText') ?? _boldText;
    _underlineLinks = p.getBool('underlineLinks') ?? _underlineLinks;
    _screenReaderOptimized =
        p.getBool('screenReaderOptimized') ?? _screenReaderOptimized;
    _animationSpeed = p.getDouble('animationSpeed') ?? _animationSpeed;
    _colorBlindAssist = p.getBool('colorBlindAssist') ?? _colorBlindAssist;

    _analyticsEnabled = p.getBool('analyticsEnabled') ?? _analyticsEnabled;
    _personalizationEnabled =
        p.getBool('personalizationEnabled') ?? _personalizationEnabled;
    _crashReportsEnabled =
        p.getBool('crashReportsEnabled') ?? _crashReportsEnabled;
    _shareUsageWithSchool =
        p.getBool('shareUsageWithSchool') ?? _shareUsageWithSchool;
    _showProfilePictureToClassmates =
        p.getBool('showProfilePictureToClassmates') ??
            _showProfilePictureToClassmates;
    _showOnlineStatus = p.getBool('showOnlineStatus') ?? _showOnlineStatus;
    _allowReadReceipts =
        p.getBool('allowReadReceipts') ?? _allowReadReceipts;

    _twoFactorEnabled = p.getBool('twoFactorEnabled') ?? _twoFactorEnabled;
    _biometricLogin = p.getBool('biometricLogin') ?? _biometricLogin;
    _autoLogout = p.getBool('autoLogout') ?? _autoLogout;
    _autoLogoutMinutes = p.getInt('autoLogoutMinutes') ?? _autoLogoutMinutes;
    _rememberMe = p.getBool('rememberMe') ?? _rememberMe;

    _autoSync = p.getBool('autoSync') ?? _autoSync;
    _wifiOnlyDownloads = p.getBool('wifiOnlyDownloads') ?? _wifiOnlyDownloads;
    _autoClearCache = p.getBool('autoClearCache') ?? _autoClearCache;
    _cacheRetentionDays =
        p.getInt('cacheRetentionDays') ?? _cacheRetentionDays;
    _imageQuality = p.getInt('imageQuality') ?? _imageQuality;
    _offlineMode = p.getBool('offlineMode') ?? _offlineMode;
  }

  // ---------- Hydration helpers ----------

  static T _readEnum<T extends Enum>(
    SharedPreferences p,
    String key,
    List<T> values,
    T fallback,
  ) {
    final raw = p.getInt(key);
    if (raw == null || raw < 0 || raw >= values.length) return fallback;
    return values[raw];
  }

  static TimeOfDay _readTimeOfDay(
    SharedPreferences p,
    String key,
    TimeOfDay fallback,
  ) {
    final minutes = p.getInt(key);
    if (minutes == null || minutes < 0 || minutes >= 24 * 60) {
      return fallback;
    }
    return TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
  }

  // -------------------- GETTERS --------------------
  AppThemeMode get themeMode => _themeMode;
  Color get accentSeed => _activePreset.seed;
  AppThemePreset get activePreset => _activePreset;
  double get textScale => _textScale;
  bool get useDynamicColor => _useDynamicColor;
  bool get dynamicColorAvailable => _dynamicColorAvailable;

  /// Called by the app shell each time the platform's dynamic color
  /// query completes. Notifies listeners so the preferences page can
  /// update its status text in real-time.
  void setDynamicColorAvailable(bool available) {
    if (_dynamicColorAvailable == available) return;
    _dynamicColorAvailable = available;
    notifyListeners();
  }

  bool get pushEnabled => _pushEnabled;
  bool get emailEnabled => _emailEnabled;
  bool get smsEnabled => _smsEnabled;
  bool get inAppSounds => _inAppSounds;
  bool get inAppBanners => _inAppBanners;
  bool get lockScreenPreview => _lockScreenPreview;
  bool get doNotDisturb => _doNotDisturb;
  TimeOfDay get dndStart => _dndStart;
  TimeOfDay get dndEnd => _dndEnd;
  bool get notifyGrades => _notifyGrades;
  bool get notifyAttendance => _notifyAttendance;
  bool get notifySchedule => _notifySchedule;
  bool get notifyPayments => _notifyPayments;
  bool get notifyAnnouncements => _notifyAnnouncements;
  bool get notifyReminders => _notifyReminders;

  AppLanguage get language => _language;
  String get region => _region;
  DateFormatStyle get dateFormat => _dateFormat;
  DistanceUnit get distanceUnit => _distanceUnit;
  CurrencyFormat get currencyFormat => _currencyFormat;
  String get currencyCode => _currencyCode;
  WeekStartDay get weekStart => _weekStart;

  bool get reduceMotion => _reduceMotion;
  bool get reduceTransparency => _reduceTransparency;
  bool get highContrastText => _highContrastText;
  bool get boldText => _boldText;
  bool get underlineLinks => _underlineLinks;
  bool get screenReaderOptimized => _screenReaderOptimized;
  double get animationSpeed => _animationSpeed;
  bool get colorBlindAssist => _colorBlindAssist;

  bool get analyticsEnabled => _analyticsEnabled;
  bool get personalizationEnabled => _personalizationEnabled;
  bool get crashReportsEnabled => _crashReportsEnabled;
  bool get shareUsageWithSchool => _shareUsageWithSchool;
  bool get showProfilePictureToClassmates => _showProfilePictureToClassmates;
  bool get showOnlineStatus => _showOnlineStatus;
  bool get allowReadReceipts => _allowReadReceipts;

  bool get twoFactorEnabled => _twoFactorEnabled;
  bool get biometricLogin => _biometricLogin;
  bool get autoLogout => _autoLogout;
  int get autoLogoutMinutes => _autoLogoutMinutes;
  bool get rememberMe => _rememberMe;

  bool get autoSync => _autoSync;
  bool get wifiOnlyDownloads => _wifiOnlyDownloads;
  bool get autoClearCache => _autoClearCache;
  int get cacheRetentionDays => _cacheRetentionDays;
  int get imageQuality => _imageQuality;
  bool get offlineMode => _offlineMode;

  // -------------------- SETTERS --------------------
  // Every setter:
  //   1. Mutates the in-memory field (guarded by an equality check)
  //   2. Calls notifyListeners() so the UI rebuilds immediately
  //   3. Marks the corresponding key as dirty and schedules a debounced
  //      flush to disk.
  void setThemeMode(AppThemeMode v) {
    if (_themeMode == v) return;
    _themeMode = v;
    _set('themeMode', _themeMode.index);
    notifyListeners();
  }

  void setActivePreset(AppThemePreset v) {
    if (_activePreset == v) return;
    _activePreset = v;
    // Picking a static preset also turns off dynamic color, since the two
    // are mutually exclusive — the OS wallpaper palette is its own thing.
    if (_useDynamicColor) {
      _useDynamicColor = false;
      _setBool('useDynamicColor', false);
    }
    _set('activePreset', _activePreset.index);
    notifyListeners();
  }

  void setUseDynamicColor(bool v) {
    if (_useDynamicColor == v) return;
    _useDynamicColor = v;
    _setBool('useDynamicColor', v);
    notifyListeners();
  }

  void setTextScale(double v) {
    v = v.clamp(0.85, 1.4);
    if ((_textScale - v).abs() < 0.001) return;
    _textScale = v;
    _setDouble('textScale', v);
    notifyListeners();
  }

  void setPushEnabled(bool v) => _setBool('pushEnabled', v);
  void setEmailEnabled(bool v) => _setBool('emailEnabled', v);
  void setSmsEnabled(bool v) => _setBool('smsEnabled', v);
  void setInAppSounds(bool v) => _setBool('inAppSounds', v);
  void setInAppBanners(bool v) => _setBool('inAppBanners', v);
  void setLockScreenPreview(bool v) => _setBool('lockScreenPreview', v);
  void setDoNotDisturb(bool v) => _setBool('doNotDisturb', v);
  void setDndStart(TimeOfDay v) {
    _dndStart = v;
    _set('dndStart', v.hour * 60 + v.minute);
  }
  void setDndEnd(TimeOfDay v) {
    _dndEnd = v;
    _set('dndEnd', v.hour * 60 + v.minute);
  }
  void setNotifyGrades(bool v) => _setBool('notifyGrades', v);
  void setNotifyAttendance(bool v) => _setBool('notifyAttendance', v);
  void setNotifySchedule(bool v) => _setBool('notifySchedule', v);
  void setNotifyPayments(bool v) => _setBool('notifyPayments', v);
  void setNotifyAnnouncements(bool v) => _setBool('notifyAnnouncements', v);
  void setNotifyReminders(bool v) => _setBool('notifyReminders', v);

  void setLanguage(AppLanguage v) {
    _language = v;
    _set('language', v.index);
  }
  void setRegion(String v) {
    _region = v;
    _setString('region', v);
  }
  void setDateFormat(DateFormatStyle v) {
    _dateFormat = v;
    _set('dateFormat', v.index);
  }
  void setDistanceUnit(DistanceUnit v) {
    _distanceUnit = v;
    _set('distanceUnit', v.index);
  }
  void setCurrencyFormat(CurrencyFormat v) {
    _currencyFormat = v;
    _set('currencyFormat', v.index);
  }
  void setCurrencyCode(String v) {
    _currencyCode = v;
    _setString('currencyCode', v);
  }
  void setWeekStart(WeekStartDay v) {
    _weekStart = v;
    _set('weekStart', v.index);
  }

  void setReduceMotion(bool v) => _setBool('reduceMotion', v);
  void setReduceTransparency(bool v) => _setBool('reduceTransparency', v);
  void setHighContrastText(bool v) => _setBool('highContrastText', v);
  void setBoldText(bool v) => _setBool('boldText', v);
  void setUnderlineLinks(bool v) => _setBool('underlineLinks', v);
  void setScreenReaderOptimized(bool v) =>
      _setBool('screenReaderOptimized', v);
  void setAnimationSpeed(double v) {
    v = v.clamp(0.5, 2.0);
    _animationSpeed = v;
    _setDouble('animationSpeed', v);
  }

  void setColorBlindAssist(bool v) => _setBool('colorBlindAssist', v);

  void setAnalyticsEnabled(bool v) => _setBool('analyticsEnabled', v);
  void setPersonalizationEnabled(bool v) =>
      _setBool('personalizationEnabled', v);
  void setCrashReportsEnabled(bool v) => _setBool('crashReportsEnabled', v);
  void setShareUsageWithSchool(bool v) => _setBool('shareUsageWithSchool', v);
  void setShowProfilePictureToClassmates(bool v) =>
      _setBool('showProfilePictureToClassmates', v);
  void setShowOnlineStatus(bool v) => _setBool('showOnlineStatus', v);
  void setAllowReadReceipts(bool v) => _setBool('allowReadReceipts', v);

  void setTwoFactorEnabled(bool v) => _setBool('twoFactorEnabled', v);
  void setBiometricLogin(bool v) => _setBool('biometricLogin', v);
  void setAutoLogout(bool v) => _setBool('autoLogout', v);
  void setAutoLogoutMinutes(int v) {
    _autoLogoutMinutes = v;
    _setInt('autoLogoutMinutes', v);
  }
  void setRememberMe(bool v) => _setBool('rememberMe', v);

  void setAutoSync(bool v) => _setBool('autoSync', v);
  void setWifiOnlyDownloads(bool v) => _setBool('wifiOnlyDownloads', v);
  void setAutoClearCache(bool v) => _setBool('autoClearCache', v);
  void setCacheRetentionDays(int v) {
    _cacheRetentionDays = v;
    _setInt('cacheRetentionDays', v);
  }
  void setImageQuality(int v) {
    v = v.clamp(50, 100);
    _imageQuality = v;
    _setInt('imageQuality', v);
  }

  void setOfflineMode(bool v) => _setBool('offlineMode', v);

  // -------------------- Persist helpers --------------------

  /// Records [key] as dirty and (re)starts a debounce timer. The actual
  /// write happens in [_flush]. This keeps disk I/O minimal even when
  /// the user drags a slider or rapidly toggles switches.
  void _set(String key, int value) {
    _dirtyKeys.add(key);
    _dirtyValues[key] = value;
    _scheduleFlush();
    notifyListeners();
  }

  void _setBool(String key, bool value) {
    _dirtyKeys.add(key);
    _dirtyBoolValues[key] = value;
    _scheduleFlush();
    notifyListeners();
  }

  void _setDouble(String key, double value) {
    _dirtyKeys.add(key);
    _dirtyDoubleValues[key] = value;
    _scheduleFlush();
    notifyListeners();
  }

  void _setInt(String key, int value) {
    _dirtyKeys.add(key);
    _dirtyIntValues[key] = value;
    _scheduleFlush();
    notifyListeners();
  }

  void _setString(String key, String value) {
    _dirtyKeys.add(key);
    _dirtyStringValues[key] = value;
    _scheduleFlush();
    notifyListeners();
  }

  /// Buffers for the debounced flush.
  final Map<String, int> _dirtyValues = <String, int>{};
  final Map<String, bool> _dirtyBoolValues = <String, bool>{};
  final Map<String, double> _dirtyDoubleValues = <String, double>{};
  final Map<String, int> _dirtyIntValues = <String, int>{};
  final Map<String, String> _dirtyStringValues = <String, String>{};

  void _scheduleFlush() {
    if (_prefs == null) return; // No persistence — nothing to flush.
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _flush);
  }

  Future<void> _flush() async {
    if (_prefs == null) return;
    final p = _prefs!;
    // Snapshot and clear dirty maps so further edits during the await
    // get re-scheduled.
    final ints = Map<String, int>.from(_dirtyValues);
    final bools = Map<String, bool>.from(_dirtyBoolValues);
    final doubles = Map<String, double>.from(_dirtyDoubleValues);
    final extraInts = Map<String, int>.from(_dirtyIntValues);
    final strings = Map<String, String>.from(_dirtyStringValues);
    _dirtyValues.clear();
    _dirtyBoolValues.clear();
    _dirtyDoubleValues.clear();
    _dirtyIntValues.clear();
    _dirtyStringValues.clear();
    _dirtyKeys.clear();

    for (final e in ints.entries) {
      await p.setInt(_kPrefix + e.key, e.value);
    }
    for (final e in bools.entries) {
      await p.setBool(_kPrefix + e.key, e.value);
    }
    for (final e in doubles.entries) {
      await p.setDouble(_kPrefix + e.key, e.value);
    }
    for (final e in extraInts.entries) {
      await p.setInt(_kPrefix + e.key, e.value);
    }
    for (final e in strings.entries) {
      await p.setString(_kPrefix + e.key, e.value);
    }
  }

  /// Resets every preference to its default value AND clears the
  /// corresponding keys from [SharedPreferences] so the next launch
  /// sees the defaults.
  Future<void> resetAll() async {
    _themeMode = AppThemeMode.system;
    _activePreset = AppThemePreset.defaultBlue;
    _textScale = 1.0;
    _useDynamicColor = true;
    _pushEnabled = true;
    _emailEnabled = true;
    _smsEnabled = false;
    _inAppSounds = true;
    _inAppBanners = true;
    _lockScreenPreview = true;
    _doNotDisturb = false;
    _dndStart = const TimeOfDay(hour: 22, minute: 0);
    _dndEnd = const TimeOfDay(hour: 7, minute: 0);
    _notifyGrades = true;
    _notifyAttendance = true;
    _notifySchedule = true;
    _notifyPayments = true;
    _notifyAnnouncements = true;
    _notifyReminders = true;
    _language = AppLanguage.english;
    _region = 'United States';
    _dateFormat = DateFormatStyle.longText;
    _distanceUnit = DistanceUnit.kilometers;
    _currencyFormat = CurrencyFormat.symbolBefore;
    _currencyCode = 'USD';
    _weekStart = WeekStartDay.sunday;
    _reduceMotion = false;
    _reduceTransparency = false;
    _highContrastText = false;
    _boldText = false;
    _underlineLinks = false;
    _screenReaderOptimized = false;
    _animationSpeed = 1.0;
    _colorBlindAssist = false;
    _analyticsEnabled = true;
    _personalizationEnabled = true;
    _crashReportsEnabled = true;
    _shareUsageWithSchool = false;
    _showProfilePictureToClassmates = true;
    _showOnlineStatus = true;
    _allowReadReceipts = true;
    _twoFactorEnabled = false;
    _biometricLogin = false;
    _autoLogout = true;
    _autoLogoutMinutes = 15;
    _rememberMe = true;
    _autoSync = true;
    _wifiOnlyDownloads = true;
    _autoClearCache = false;
    _cacheRetentionDays = 30;
    _imageQuality = 80;
    _offlineMode = false;
    // Clear every stored key so we don't re-hydrate stale values.
    if (_prefs != null) {
      final p = _prefs!;
      for (final key in p.getKeys()) {
        if (key.startsWith(_kPrefix)) {
          await p.remove(key);
        }
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // Flush any pending writes synchronously so nothing is lost if the
    // app is killed shortly after the last edit.
    _debounce?.cancel();
    // Fire-and-forget flush; the OS may not give us time to await, but
    // the SharedPreferences plugin is fast enough that this is safe.
    _flush();
    super.dispose();
  }
}

/// An [InheritedNotifier] that exposes the shared [PreferencesService]
/// instance to every widget in the subtree.
///
/// Use [PreferencesScope.of] to read the service from any descendant.
/// The InheritedNotifier auto-rebuilds dependents whenever the service
/// fires `notifyListeners()`, so widgets that read prefs (such as the
/// preferences page) stay in sync with the values that the [MyApp]
/// builder is also reading.
class PreferencesScope extends InheritedNotifier<PreferencesService> {
  const PreferencesScope({
    required PreferencesService super.notifier,
    required super.child,
    super.key,
  });

  /// Returns the shared [PreferencesService] from the nearest
  /// [PreferencesScope] ancestor. Throws if none is found.
  static PreferencesService of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<PreferencesScope>();
    assert(
      scope != null,
      'PreferencesScope.of() called with a context that does not contain '
      'a PreferencesScope ancestor.',
    );
    return scope!.notifier!;
  }
}
