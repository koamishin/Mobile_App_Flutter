import 'package:flutter/material.dart';

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
/// Exposed as a [ChangeNotifier] so screens can listen for changes. Wiring
/// this into [MaterialApp] lets theme mode and locale apply globally.
///
/// The values are kept in memory; persisting to `shared_preferences` is a
/// one-line change inside each setter when the user is ready.
class PreferencesService extends ChangeNotifier {
  // ---------- Appearance ----------
  AppThemeMode _themeMode = AppThemeMode.system;
  /// Whether the underlying device (Android 12+) returned a non-null
  /// Material You palette the last time [MyApp] built. The preferences
  /// page reads this so it can show a status hint next to the
  /// "Dynamic color" switch (e.g. "Not available on this device").
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

  // ---------- Accessibility to defaults ----------
  PreferencesService();

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
  void setThemeMode(AppThemeMode v) {
    if (_themeMode == v) return;
    _themeMode = v;
    notifyListeners();
  }

  void setActivePreset(AppThemePreset v) {
    if (_activePreset == v) return;
    _activePreset = v;
    // Picking a static preset also turns off dynamic color, since the two
    // are mutually exclusive — the OS wallpaper palette is its own thing.
    if (_useDynamicColor) {
      _useDynamicColor = false;
    }
    notifyListeners();
  }

  void setUseDynamicColor(bool v) {
    if (_useDynamicColor == v) return;
    _useDynamicColor = v;
    notifyListeners();
  }

  void setTextScale(double v) {
    v = v.clamp(0.85, 1.4);
    if ((_textScale - v).abs() < 0.001) return;
    _textScale = v;
    notifyListeners();
  }

  void setPushEnabled(bool v) => _set(() => _pushEnabled = v);
  void setEmailEnabled(bool v) => _set(() => _emailEnabled = v);
  void setSmsEnabled(bool v) => _set(() => _smsEnabled = v);
  void setInAppSounds(bool v) => _set(() => _inAppSounds = v);
  void setInAppBanners(bool v) => _set(() => _inAppBanners = v);
  void setLockScreenPreview(bool v) => _set(() => _lockScreenPreview = v);
  void setDoNotDisturb(bool v) => _set(() => _doNotDisturb = v);
  void setDndStart(TimeOfDay v) => _set(() => _dndStart = v);
  void setDndEnd(TimeOfDay v) => _set(() => _dndEnd = v);
  void setNotifyGrades(bool v) => _set(() => _notifyGrades = v);
  void setNotifyAttendance(bool v) => _set(() => _notifyAttendance = v);
  void setNotifySchedule(bool v) => _set(() => _notifySchedule = v);
  void setNotifyPayments(bool v) => _set(() => _notifyPayments = v);
  void setNotifyAnnouncements(bool v) => _set(() => _notifyAnnouncements = v);
  void setNotifyReminders(bool v) => _set(() => _notifyReminders = v);

  void setLanguage(AppLanguage v) => _set(() => _language = v);
  void setRegion(String v) => _set(() => _region = v);
  void setDateFormat(DateFormatStyle v) => _set(() => _dateFormat = v);
  void setDistanceUnit(DistanceUnit v) => _set(() => _distanceUnit = v);
  void setCurrencyFormat(CurrencyFormat v) => _set(() => _currencyFormat = v);
  void setCurrencyCode(String v) => _set(() => _currencyCode = v);
  void setWeekStart(WeekStartDay v) => _set(() => _weekStart = v);

  void setReduceMotion(bool v) => _set(() => _reduceMotion = v);
  void setReduceTransparency(bool v) => _set(() => _reduceTransparency = v);
  void setHighContrastText(bool v) => _set(() => _highContrastText = v);
  void setBoldText(bool v) => _set(() => _boldText = v);
  void setUnderlineLinks(bool v) => _set(() => _underlineLinks = v);
  void setScreenReaderOptimized(bool v) =>
      _set(() => _screenReaderOptimized = v);
  void setAnimationSpeed(double v) {
    v = v.clamp(0.5, 2.0);
    _set(() => _animationSpeed = v);
  }

  void setColorBlindAssist(bool v) => _set(() => _colorBlindAssist = v);

  void setAnalyticsEnabled(bool v) => _set(() => _analyticsEnabled = v);
  void setPersonalizationEnabled(bool v) =>
      _set(() => _personalizationEnabled = v);
  void setCrashReportsEnabled(bool v) => _set(() => _crashReportsEnabled = v);
  void setShareUsageWithSchool(bool v) =>
      _set(() => _shareUsageWithSchool = v);
  void setShowProfilePictureToClassmates(bool v) =>
      _set(() => _showProfilePictureToClassmates = v);
  void setShowOnlineStatus(bool v) => _set(() => _showOnlineStatus = v);
  void setAllowReadReceipts(bool v) => _set(() => _allowReadReceipts = v);

  void setTwoFactorEnabled(bool v) => _set(() => _twoFactorEnabled = v);
  void setBiometricLogin(bool v) => _set(() => _biometricLogin = v);
  void setAutoLogout(bool v) => _set(() => _autoLogout = v);
  void setAutoLogoutMinutes(int v) => _set(() => _autoLogoutMinutes = v);
  void setRememberMe(bool v) => _set(() => _rememberMe = v);

  void setAutoSync(bool v) => _set(() => _autoSync = v);
  void setWifiOnlyDownloads(bool v) => _set(() => _wifiOnlyDownloads = v);
  void setAutoClearCache(bool v) => _set(() => _autoClearCache = v);
  void setCacheRetentionDays(int v) => _set(() => _cacheRetentionDays = v);
  void setImageQuality(int v) {
    v = v.clamp(50, 100);
    _set(() => _imageQuality = v);
  }

  void setOfflineMode(bool v) => _set(() => _offlineMode = v);

  /// Resets every preference to its default value.
  void resetAll() {
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
    notifyListeners();
  }

  void _set(VoidCallback mutator) {
    mutator();
    notifyListeners();
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
