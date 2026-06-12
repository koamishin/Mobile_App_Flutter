import 'package:flutter/material.dart';

import '../../services/preferences_service.dart';
import '../widgets/page_components.dart';
import '../widgets/preference_tile.dart';

/// Comprehensive preferences page covering every major area a user can
/// configure: appearance, notifications, language/region, accessibility,
/// privacy, account security, data & storage, and an about section.
class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  late final PreferencesService _prefs;

  // Used by the section scaffold layout.
  static const _blue = Color(0xFF2F80ED);
  static const _purple = Color(0xFF6D5DFB);
  static const _teal = Color(0xFF32A89D);
  static const _orange = Color(0xFFFF8E53);
  static const _indigo = Color(0xFF7B61FF);
  static const _red = Color(0xFFEB5757);
  static const _green = Color(0xFF27AE60);
  static const _amber = Color(0xFFFFB86B);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Resolve the shared PreferencesService from the nearest
    // [PreferencesScope] ancestor (set up by [MyApp]). Using a single
    // shared instance ensures changes here propagate to the theme
    // bound by [MaterialApp].
    _prefs = PreferencesScope.of(context);
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the body in [AnimatedBuilder] so every part of this page
    // explicitly subscribes to [_prefs] and rebuilds when any setting
    // changes. Without this, widgets that read _prefs.* inside their
    // own build method (like the radio-dialog current selection, the
    // preset "selected" check mark, and the dropdown's valueLabel)
    // would only update on the next hot reload.
    return AnimatedBuilder(
      animation: _prefs,
      builder: (context, _) {
        return StudentPageScaffold(
          title: 'Preferences',
          subtitle: 'Customize your app experience',
          icon: Icons.tune_rounded,
          children: _buildSections(context),
        );
      },
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    return [
        // ============================================================
        // APPEARANCE
        // ============================================================
        _SectionHeader(
          icon: Icons.palette_rounded,
          color: _blue,
          title: 'Appearance',
          subtitle: 'Theme, color, and text size',
        ),
        // Theme mode selector (single M3 dropdown — replaces the previous
        // "Use system theme" + "Dark mode" toggle pair, which duplicated
        // state with this picker).
        ChoicePreferenceTile<AppThemeMode>(
          icon: Icons.brightness_6_rounded,
          iconColor: _amber,
          title: 'Theme mode',
          subtitle: _themeModeSubtitle(_prefs.themeMode),
          valueLabel: _themeModeLabel(_prefs.themeMode),
          onTap: () => _pickThemeMode(),
        ),

        // M3 SegmentedButton-driven static theme preset picker.
        _ThemePresetPicker(
          current: _prefs.activePreset,
          onChanged: _prefs.setActivePreset,
        ),

        // Dynamic color (Android 12+ Material You). When this is on,
        // the OS wallpaper drives the seed. Mutually exclusive with
        // a manual preset selection.
        SwitchPreferenceTile(
          icon: _prefs.dynamicColorAvailable
              ? Icons.auto_awesome_rounded
              : Icons.auto_awesome_outlined,
          iconColor: _prefs.dynamicColorAvailable ? _purple : _amber,
          title: 'Dynamic color (Android 12+)',
          subtitle: _dynamicColorSubtitle(_prefs.dynamicColorAvailable,
              _prefs.useDynamicColor),
          value: _prefs.useDynamicColor,
          onChanged: (v) {
            _prefs.setUseDynamicColor(v);
            // Re-enabling dynamic color implicitly turns off the manual
            // preset; turning it off restores the user's last preset.
            // We keep the current preset in storage so toggling back
            // brings the same color back.
          },
        ),

        // Text size slider (kept from the original design).
        SliderPreferenceTile(
          icon: Icons.format_size_rounded,
          iconColor: _blue,
          title: 'Text size',
          subtitle: 'Scale app text larger or smaller',
          value: _prefs.textScale,
          min: 0.85,
          max: 1.4,
          divisions: 11,
          valueLabel: '${(_prefs.textScale * 100).round()}%',
          onChanged: _prefs.setTextScale,
        ),

        // ============================================================
        // NOTIFICATIONS
        // ============================================================
        _SectionHeader(
          icon: Icons.notifications_active_rounded,
          color: _orange,
          title: 'Notifications',
          subtitle: 'How and when the app notifies you',
        ),
        SwitchPreferenceTile(
          icon: Icons.notifications_rounded,
          iconColor: _blue,
          title: 'Push notifications',
          subtitle: 'Receive alerts on your device',
          value: _prefs.pushEnabled,
          onChanged: _prefs.setPushEnabled,
        ),
        SwitchPreferenceTile(
          icon: Icons.email_rounded,
          iconColor: _purple,
          title: 'Email notifications',
          subtitle: 'Get a daily or weekly email digest',
          value: _prefs.emailEnabled,
          onChanged: _prefs.setEmailEnabled,
        ),
        SwitchPreferenceTile(
          icon: Icons.sms_rounded,
          iconColor: _green,
          title: 'SMS notifications',
          subtitle: 'Urgent alerts via text message',
          value: _prefs.smsEnabled,
          onChanged: _prefs.setSmsEnabled,
        ),
        SwitchPreferenceTile(
          icon: Icons.volume_up_rounded,
          iconColor: _teal,
          title: 'In-app sounds',
          subtitle: 'Play a sound when a notification arrives',
          value: _prefs.inAppSounds,
          onChanged: _prefs.setInAppSounds,
        ),
        SwitchPreferenceTile(
          icon: Icons.notifications_paused_rounded,
          iconColor: _indigo,
          title: 'In-app banners',
          subtitle: 'Show pop-up banners at the top of the screen',
          value: _prefs.inAppBanners,
          onChanged: _prefs.setInAppBanners,
        ),
        SwitchPreferenceTile(
          icon: Icons.lock_rounded,
          iconColor: _blue,
          title: 'Lock screen preview',
          subtitle: 'Show notification content on the lock screen',
          value: _prefs.lockScreenPreview,
          onChanged: _prefs.setLockScreenPreview,
        ),
        SwitchPreferenceTile(
          icon: Icons.do_not_disturb_on_rounded,
          iconColor: _red,
          title: 'Do Not Disturb',
          subtitle:
              'Silence notifications between ${_prefs.dndStart.format(context)} and ${_prefs.dndEnd.format(context)}',
          value: _prefs.doNotDisturb,
          onChanged: _prefs.setDoNotDisturb,
        ),
        if (_prefs.doNotDisturb) ...[
          ChoicePreferenceTile<TimeOfDay>(
            icon: Icons.nights_stay_rounded,
            iconColor: _indigo,
            title: 'DND start',
            valueLabel: _prefs.dndStart.format(context),
            onTap: () => _pickDndStart(),
          ),
          ChoicePreferenceTile<TimeOfDay>(
            icon: Icons.wb_sunny_rounded,
            iconColor: _amber,
            title: 'DND end',
            valueLabel: _prefs.dndEnd.format(context),
            onTap: () => _pickDndEnd(),
          ),
        ],
        _SectionSubHeader(title: 'Notify me about'),
        SwitchPreferenceTile(
          icon: Icons.assessment_rounded,
          iconColor: _purple,
          title: 'Grades & assessments',
          value: _prefs.notifyGrades,
          onChanged: _prefs.setNotifyGrades,
        ),
        SwitchPreferenceTile(
          icon: Icons.how_to_reg_rounded,
          iconColor: _orange,
          title: 'Attendance alerts',
          value: _prefs.notifyAttendance,
          onChanged: _prefs.setNotifyAttendance,
        ),
        SwitchPreferenceTile(
          icon: Icons.calendar_month_rounded,
          iconColor: _blue,
          title: 'Schedule changes',
          value: _prefs.notifySchedule,
          onChanged: _prefs.setNotifySchedule,
        ),
        SwitchPreferenceTile(
          icon: Icons.monetization_on_rounded,
          iconColor: _teal,
          title: 'Payment reminders',
          value: _prefs.notifyPayments,
          onChanged: _prefs.setNotifyPayments,
        ),
        SwitchPreferenceTile(
          icon: Icons.campaign_rounded,
          iconColor: _indigo,
          title: 'School announcements',
          value: _prefs.notifyAnnouncements,
          onChanged: _prefs.setNotifyAnnouncements,
        ),
        SwitchPreferenceTile(
          icon: Icons.alarm_rounded,
          iconColor: _green,
          title: 'Assignment reminders',
          value: _prefs.notifyReminders,
          onChanged: _prefs.setNotifyReminders,
        ),

        // ============================================================
        // LANGUAGE & REGION
        // ============================================================
        _SectionHeader(
          icon: Icons.language_rounded,
          color: _teal,
          title: 'Language & Region',
          subtitle: 'Localization and formatting',
        ),
        ChoicePreferenceTile<AppLanguage>(
          icon: Icons.translate_rounded,
          iconColor: _teal,
          title: 'App language',
          valueLabel: _languageLabel(_prefs.language),
          onTap: _pickLanguage,
        ),
        ChoicePreferenceTile<String>(
          icon: Icons.public_rounded,
          iconColor: _blue,
          title: 'Region',
          valueLabel: _prefs.region,
          onTap: _pickRegion,
        ),
        ChoicePreferenceTile<DateFormatStyle>(
          icon: Icons.calendar_today_rounded,
          iconColor: _purple,
          title: 'Date format',
          valueLabel: _dateFormatLabel(_prefs.dateFormat),
          onTap: _pickDateFormat,
        ),
        ChoicePreferenceTile<DistanceUnit>(
          icon: Icons.straighten_rounded,
          iconColor: _orange,
          title: 'Distance unit',
          valueLabel: _prefs.distanceUnit == DistanceUnit.kilometers
              ? 'Kilometers (km)'
              : 'Miles (mi)',
          onTap: _pickDistanceUnit,
        ),
        ChoicePreferenceTile<CurrencyFormat>(
          icon: Icons.attach_money_rounded,
          iconColor: _green,
          title: 'Currency format',
          valueLabel:
              '${_currencyFormatLabel(_prefs.currencyFormat)} (${_prefs.currencyCode})',
          onTap: _pickCurrencyFormat,
        ),
        ChoicePreferenceTile<String>(
          icon: Icons.payments_rounded,
          iconColor: _amber,
          title: 'Currency code',
          valueLabel: _prefs.currencyCode,
          onTap: _pickCurrencyCode,
        ),
        ChoicePreferenceTile<WeekStartDay>(
          icon: Icons.event_note_rounded,
          iconColor: _indigo,
          title: 'Week starts on',
          valueLabel: _weekStartLabel(_prefs.weekStart),
          onTap: _pickWeekStart,
        ),

        // ============================================================
        // ACCESSIBILITY
        // ============================================================
        _SectionHeader(
          icon: Icons.accessibility_new_rounded,
          color: _indigo,
          title: 'Accessibility',
          subtitle: 'Make the app work better for you',
        ),
        SwitchPreferenceTile(
          icon: Icons.motion_photos_off_rounded,
          iconColor: _blue,
          title: 'Reduce motion',
          subtitle: 'Minimize animations and transitions',
          value: _prefs.reduceMotion,
          onChanged: _prefs.setReduceMotion,
        ),
        SwitchPreferenceTile(
          icon: Icons.opacity_rounded,
          iconColor: _teal,
          title: 'Reduce transparency',
          subtitle: 'Use solid backgrounds instead of blur',
          value: _prefs.reduceTransparency,
          onChanged: _prefs.setReduceTransparency,
        ),
        SwitchPreferenceTile(
          icon: Icons.contrast_rounded,
          iconColor: _purple,
          title: 'High-contrast text',
          subtitle: 'Increase text legibility',
          value: _prefs.highContrastText,
          onChanged: _prefs.setHighContrastText,
        ),
        SwitchPreferenceTile(
          icon: Icons.format_bold_rounded,
          iconColor: _orange,
          title: 'Bold text',
          subtitle: 'Use bolder font weights',
          value: _prefs.boldText,
          onChanged: _prefs.setBoldText,
        ),
        SwitchPreferenceTile(
          icon: Icons.link_rounded,
          iconColor: _blue,
          title: 'Underline links',
          subtitle: 'Always show underlines on links',
          value: _prefs.underlineLinks,
          onChanged: _prefs.setUnderlineLinks,
        ),
        SwitchPreferenceTile(
          icon: Icons.record_voice_over_rounded,
          iconColor: _green,
          title: 'Screen reader optimizations',
          subtitle: 'Extra hints for TalkBack / VoiceOver',
          value: _prefs.screenReaderOptimized,
          onChanged: _prefs.setScreenReaderOptimized,
        ),
        SwitchPreferenceTile(
          icon: Icons.colorize_rounded,
          iconColor: _red,
          title: 'Color-blind assist',
          subtitle: 'Use shapes alongside colors in charts',
          value: _prefs.colorBlindAssist,
          onChanged: _prefs.setColorBlindAssist,
        ),
        SliderPreferenceTile(
          icon: Icons.speed_rounded,
          iconColor: _indigo,
          title: 'Animation speed',
          subtitle: 'Faster or slower motion',
          value: _prefs.animationSpeed,
          min: 0.5,
          max: 2.0,
          divisions: 6,
          valueLabel: '${(_prefs.animationSpeed * 100).round()}%',
          onChanged: _prefs.setAnimationSpeed,
        ),

        // ============================================================
        // PRIVACY
        // ============================================================
        _SectionHeader(
          icon: Icons.shield_rounded,
          color: _green,
          title: 'Privacy',
          subtitle: 'What we collect and how it is used',
        ),
        SwitchPreferenceTile(
          icon: Icons.analytics_rounded,
          iconColor: _blue,
          title: 'Anonymous analytics',
          subtitle: 'Help us improve the app',
          value: _prefs.analyticsEnabled,
          onChanged: _prefs.setAnalyticsEnabled,
        ),
        SwitchPreferenceTile(
          icon: Icons.psychology_rounded,
          iconColor: _purple,
          title: 'Personalized suggestions',
          subtitle: 'Tailor tips based on your activity',
          value: _prefs.personalizationEnabled,
          onChanged: _prefs.setPersonalizationEnabled,
        ),
        SwitchPreferenceTile(
          icon: Icons.bug_report_rounded,
          iconColor: _red,
          title: 'Crash reports',
          subtitle: 'Send anonymous crash diagnostics',
          value: _prefs.crashReportsEnabled,
          onChanged: _prefs.setCrashReportsEnabled,
        ),
        SwitchPreferenceTile(
          icon: Icons.school_rounded,
          iconColor: _teal,
          title: 'Share usage with school',
          subtitle: 'Aggregated engagement data for teachers',
          value: _prefs.shareUsageWithSchool,
          onChanged: _prefs.setShareUsageWithSchool,
        ),
        SwitchPreferenceTile(
          icon: Icons.portrait_rounded,
          iconColor: _orange,
          title: 'Profile picture visible to classmates',
          value: _prefs.showProfilePictureToClassmates,
          onChanged: _prefs.setShowProfilePictureToClassmates,
        ),
        SwitchPreferenceTile(
          icon: Icons.circle_rounded,
          iconColor: _green,
          title: 'Show online status',
          subtitle: 'Let others see when you are active',
          value: _prefs.showOnlineStatus,
          onChanged: _prefs.setShowOnlineStatus,
        ),
        SwitchPreferenceTile(
          icon: Icons.done_all_rounded,
          iconColor: _indigo,
          title: 'Read receipts',
          subtitle: 'Let others know when you have read their message',
          value: _prefs.allowReadReceipts,
          onChanged: _prefs.setAllowReadReceipts,
        ),
        ActionPreferenceTile(
          icon: Icons.privacy_tip_rounded,
          iconColor: _blue,
          title: 'Privacy policy',
          subtitle: 'Read the full policy',
          onTap: _openPrivacyPolicy,
        ),
        ActionPreferenceTile(
          icon: Icons.cookie_rounded,
          iconColor: _amber,
          title: 'Manage cookies',
          subtitle: 'Configure cookie preferences',
          onTap: _manageCookies,
        ),

        // ============================================================
        // ACCOUNT & SECURITY
        // ============================================================
        _SectionHeader(
          icon: Icons.account_circle_rounded,
          color: _purple,
          title: 'Account & Security',
          subtitle: 'Login, password, and devices',
        ),
        SwitchPreferenceTile(
          icon: Icons.security_rounded,
          iconColor: _green,
          title: 'Two-factor authentication',
          subtitle: 'Add an extra layer at sign-in',
          value: _prefs.twoFactorEnabled,
          onChanged: _prefs.setTwoFactorEnabled,
        ),
        SwitchPreferenceTile(
          icon: Icons.fingerprint_rounded,
          iconColor: _blue,
          title: 'Biometric login',
          subtitle: 'Use fingerprint or face to unlock',
          value: _prefs.biometricLogin,
          onChanged: _prefs.setBiometricLogin,
        ),
        SwitchPreferenceTile(
          icon: Icons.remember_me_rounded,
          iconColor: _indigo,
          title: 'Remember me',
          subtitle: 'Stay signed in on this device',
          value: _prefs.rememberMe,
          onChanged: _prefs.setRememberMe,
        ),
        SwitchPreferenceTile(
          icon: Icons.logout_rounded,
          iconColor: _orange,
          title: 'Auto-logout',
          subtitle: _prefs.autoLogout
              ? 'After ${_prefs.autoLogoutMinutes} minutes of inactivity'
              : 'Disabled',
          value: _prefs.autoLogout,
          onChanged: _prefs.setAutoLogout,
        ),
        if (_prefs.autoLogout)
          ChoicePreferenceTile<int>(
            icon: Icons.timer_rounded,
            iconColor: _red,
            title: 'Auto-logout timeout',
            valueLabel: '${_prefs.autoLogoutMinutes} min',
            onTap: _pickAutoLogout,
          ),
        ActionPreferenceTile(
          icon: Icons.password_rounded,
          iconColor: _blue,
          title: 'Change password',
          onTap: _changePassword,
        ),
        ActionPreferenceTile(
          icon: Icons.devices_rounded,
          iconColor: _teal,
          title: 'Manage devices',
          subtitle: '2 active sessions',
          onTap: _manageDevices,
        ),
        ActionPreferenceTile(
          icon: Icons.download_rounded,
          iconColor: _purple,
          title: 'Download my data',
          subtitle: 'Export your account data',
          onTap: _downloadData,
        ),

        // ============================================================
        // DATA & STORAGE
        // ============================================================
        _SectionHeader(
          icon: Icons.storage_rounded,
          color: _amber,
          title: 'Data & Storage',
          subtitle: 'Sync, downloads, and cache',
        ),
        SwitchPreferenceTile(
          icon: Icons.sync_rounded,
          iconColor: _blue,
          title: 'Auto-sync',
          subtitle: 'Keep your data up to date',
          value: _prefs.autoSync,
          onChanged: _prefs.setAutoSync,
        ),
        SwitchPreferenceTile(
          icon: Icons.wifi_rounded,
          iconColor: _teal,
          title: 'Download on Wi-Fi only',
          subtitle: 'Save mobile data',
          value: _prefs.wifiOnlyDownloads,
          onChanged: _prefs.setWifiOnlyDownloads,
        ),
        SwitchPreferenceTile(
          icon: Icons.cleaning_services_rounded,
          iconColor: _orange,
          title: 'Auto-clear cache',
          subtitle: 'Periodically free up space',
          value: _prefs.autoClearCache,
          onChanged: _prefs.setAutoClearCache,
        ),
        ChoicePreferenceTile<int>(
          icon: Icons.history_rounded,
          iconColor: _purple,
          title: 'Cache retention',
          valueLabel: '${_prefs.cacheRetentionDays} days',
          onTap: _pickCacheRetention,
        ),
        SliderPreferenceTile(
          icon: Icons.high_quality_rounded,
          iconColor: _green,
          title: 'Image quality',
          subtitle: 'Higher quality uses more storage',
          value: _prefs.imageQuality.toDouble(),
          min: 50,
          max: 100,
          divisions: 10,
          valueLabel: '${_prefs.imageQuality}%',
          onChanged: (v) => _prefs.setImageQuality(v.round()),
        ),
        SwitchPreferenceTile(
          icon: Icons.cloud_off_rounded,
          iconColor: _indigo,
          title: 'Offline mode',
          subtitle: 'Use cached data only',
          value: _prefs.offlineMode,
          onChanged: _prefs.setOfflineMode,
        ),
        ActionPreferenceTile(
          icon: Icons.delete_sweep_rounded,
          iconColor: _red,
          title: 'Clear cache now',
          subtitle: 'Free up space immediately',
          onTap: _clearCache,
        ),

        // ============================================================
        // ABOUT
        // ============================================================
        _SectionHeader(
          icon: Icons.info_rounded,
          color: _blue,
          title: 'About',
          subtitle: 'App information and help',
        ),
        ActionPreferenceTile(
          icon: Icons.system_update_rounded,
          iconColor: _green,
          title: 'Check for updates',
          trailingText: 'v1.0.0',
          onTap: _checkUpdates,
        ),
        ActionPreferenceTile(
          icon: Icons.help_rounded,
          iconColor: _orange,
          title: 'Help center',
          subtitle: 'FAQs and tutorials',
          onTap: _openHelp,
        ),
        ActionPreferenceTile(
          icon: Icons.feedback_rounded,
          iconColor: _purple,
          title: 'Send feedback',
          subtitle: 'Tell us what you think',
          onTap: _sendFeedback,
        ),
        ActionPreferenceTile(
          icon: Icons.star_rounded,
          iconColor: _amber,
          title: 'Rate this app',
          subtitle: 'Leave a review on the store',
          onTap: _rateApp,
        ),
        ActionPreferenceTile(
          icon: Icons.description_rounded,
          iconColor: _teal,
          title: 'Terms of service',
          onTap: _openTerms,
        ),
        ActionPreferenceTile(
          icon: Icons.gavel_rounded,
          iconColor: _indigo,
          title: 'Open source licenses',
          onTap: _openLicenses,
        ),

        // ============================================================
        // DANGER ZONE
        // ============================================================
        _SectionHeader(
          icon: Icons.warning_amber_rounded,
          color: _red,
          title: 'Danger zone',
          subtitle: 'Irreversible actions',
        ),
        ActionPreferenceTile(
          icon: Icons.restart_alt_rounded,
          iconColor: _orange,
          title: 'Reset preferences to defaults',
          subtitle: 'Restore every setting to its original value',
          onTap: _resetPrefs,
        ),
        ActionPreferenceTile(
          icon: Icons.delete_forever_rounded,
          iconColor: _red,
          title: 'Delete account',
          subtitle: 'Permanently delete your account and data',
          onTap: _deleteAccount,
        ),
        const SizedBox(height: 24),
      ];
  }

  // _buildSections helper that returns the children list passed to
  // StudentPageScaffold. Split out from build() so we can wrap the
  // body in an [AnimatedBuilder] that subscribes to the prefs service.

  // ============================================================
  // Picker helpers
  // ============================================================
  Future<void> _pickThemeMode() async {
    final v = await _showChoiceDialog<AppThemeMode>(
      title: 'Theme mode',
      current: _prefs.themeMode,
      options: const {
        AppThemeMode.system: 'Follow system',
        AppThemeMode.light: 'Light',
        AppThemeMode.dark: 'Dark',
      },
    );
    if (v != null) _prefs.setThemeMode(v);
  }

  Future<void> _pickLanguage() async {
    final v = await _showChoiceDialog<AppLanguage>(
      title: 'App language',
      current: _prefs.language,
      options: const {
        AppLanguage.english: 'English',
        AppLanguage.spanish: 'Español',
        AppLanguage.french: 'Français',
        AppLanguage.filipino: 'Filipino',
        AppLanguage.japanese: '日本語',
      },
    );
    if (v != null) _prefs.setLanguage(v);
  }

  Future<void> _pickRegion() async {
    const regions = [
      'United States',
      'Philippines',
      'United Kingdom',
      'Canada',
      'Australia',
      'Japan',
      'France',
      'Spain',
      'Germany',
      'Singapore',
      'India',
      'Brazil',
      'Mexico',
    ];
    final v = await _showChoiceDialog<String>(
      title: 'Region',
      current: _prefs.region,
      options: {for (final r in regions) r: r},
    );
    if (v != null) _prefs.setRegion(v);
  }

  Future<void> _pickDateFormat() async {
    final v = await _showChoiceDialog<DateFormatStyle>(
      title: 'Date format',
      current: _prefs.dateFormat,
      options: const {
        DateFormatStyle.systemDefault: 'System default',
        DateFormatStyle.longText: 'May 26, 2026',
        DateFormatStyle.usMdy: '05/26/2026',
        DateFormatStyle.europeanDmy: '26/05/2026',
        DateFormatStyle.iso: '2026-05-26',
      },
    );
    if (v != null) _prefs.setDateFormat(v);
  }

  Future<void> _pickDistanceUnit() async {
    final v = await _showChoiceDialog<DistanceUnit>(
      title: 'Distance unit',
      current: _prefs.distanceUnit,
      options: const {
        DistanceUnit.kilometers: 'Kilometers (km)',
        DistanceUnit.miles: 'Miles (mi)',
      },
    );
    if (v != null) _prefs.setDistanceUnit(v);
  }

  Future<void> _pickCurrencyFormat() async {
    final v = await _showChoiceDialog<CurrencyFormat>(
      title: 'Currency format',
      current: _prefs.currencyFormat,
      options: const {
        CurrencyFormat.symbolBefore: 'Symbol before (\$10.00)',
        CurrencyFormat.symbolAfter: 'Symbol after (10.00\$)',
        CurrencyFormat.code: 'Code (USD 10.00)',
      },
    );
    if (v != null) _prefs.setCurrencyFormat(v);
  }

  Future<void> _pickCurrencyCode() async {
    const codes = [
      'USD',
      'EUR',
      'GBP',
      'JPY',
      'PHP',
      'CAD',
      'AUD',
      'SGD',
      'INR',
      'BRL',
      'MXN',
      'CNY',
      'KRW',
    ];
    final v = await _showChoiceDialog<String>(
      title: 'Currency code',
      current: _prefs.currencyCode,
      options: {for (final c in codes) c: c},
    );
    if (v != null) _prefs.setCurrencyCode(v);
  }

  Future<void> _pickWeekStart() async {
    final v = await _showChoiceDialog<WeekStartDay>(
      title: 'Week starts on',
      current: _prefs.weekStart,
      options: const {
        WeekStartDay.sunday: 'Sunday',
        WeekStartDay.monday: 'Monday',
        WeekStartDay.saturday: 'Saturday',
      },
    );
    if (v != null) _prefs.setWeekStart(v);
  }

  Future<void> _pickAutoLogout() async {
    final v = await _showChoiceDialog<int>(
      title: 'Auto-logout timeout',
      current: _prefs.autoLogoutMinutes,
      options: const {
        5: '5 minutes',
        15: '15 minutes',
        30: '30 minutes',
        60: '1 hour',
      },
    );
    if (v != null) _prefs.setAutoLogoutMinutes(v);
  }

  Future<void> _pickCacheRetention() async {
    final v = await _showChoiceDialog<int>(
      title: 'Cache retention',
      current: _prefs.cacheRetentionDays,
      options: const {
        7: '7 days',
        14: '14 days',
        30: '30 days',
        60: '60 days',
        90: '90 days',
      },
    );
    if (v != null) _prefs.setCacheRetentionDays(v);
  }

  Future<void> _pickDndStart() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _prefs.dndStart,
    );
    if (t != null) _prefs.setDndStart(t);
  }

  Future<void> _pickDndEnd() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _prefs.dndEnd,
    );
    if (t != null) _prefs.setDndEnd(t);
  }

  Future<T?> _showChoiceDialog<T>({
    required String title,
    required T current,
    required Map<T, String> options,
  }) async {
    return showDialog<T>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text(title),
          children: [
            RadioGroup<T>(
              groupValue: current,
              onChanged: (v) => Navigator.of(ctx).pop(v),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.entries
                    .map(
                      (e) => RadioListTile<T>(
                        title: Text(e.value),
                        value: e.key,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  // Placeholder actions
  void _openPrivacyPolicy() => _toast('Opening privacy policy…');
  void _manageCookies() => _toast('Manage cookies…');
  void _changePassword() => _toast('Opening password reset…');
  void _manageDevices() => _toast('Manage devices…');
  void _downloadData() => _toast('Preparing data export…');
  void _clearCache() => _toast('Cache cleared (24.5 MB freed)');
  void _checkUpdates() => _toast('You are on the latest version');
  void _openHelp() => _toast('Opening help center…');
  void _sendFeedback() => _toast('Opening feedback form…');
  void _rateApp() => _toast('Opening store listing…');
  void _openTerms() => _toast('Opening terms of service…');
  void _openLicenses() => showLicensePage(context: context);

  Future<void> _resetPrefs() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Reset preferences?'),
            content: const Text(
              'This will restore every setting to its default value. '
              'Your account data will not be affected.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Reset'),
              ),
            ],
          ),
    );
    if (confirm == true) {
      setState(() => _prefs.resetAll());
      _toast('Preferences reset to defaults');
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete account?'),
            content: const Text(
              'This is permanent. Your account, grades, and history will '
              'be erased within 30 days.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: _red),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (confirm == true) {
      _toast('Account deletion scheduled');
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  // ============================================================
  // Label helpers
  // ============================================================
  String _themeModeLabel(AppThemeMode m) => switch (m) {
    AppThemeMode.system => 'System',
    AppThemeMode.light => 'Light',
    AppThemeMode.dark => 'Dark',
  };
  String _themeModeSubtitle(AppThemeMode m) => switch (m) {
    AppThemeMode.system => 'Follow your device setting',
    AppThemeMode.light => 'Always use the light scheme',
    AppThemeMode.dark => 'Always use the dark scheme',
  };
  String _dynamicColorSubtitle(bool available, bool enabled) {
    if (!available) {
      return 'Not available on this device — try setting a Material '
          'You wallpaper in system Settings';
    }
    return enabled
        ? 'Using your wallpaper as the color seed'
        : 'Use your wallpaper as the color seed';
  }
  String _languageLabel(AppLanguage l) => switch (l) {
    AppLanguage.english => 'English',
    AppLanguage.spanish => 'Español',
    AppLanguage.french => 'Français',
    AppLanguage.filipino => 'Filipino',
    AppLanguage.japanese => '日本語',
  };
  String _dateFormatLabel(DateFormatStyle s) => switch (s) {
    DateFormatStyle.systemDefault => 'System default',
    DateFormatStyle.longText => 'May 26, 2026',
    DateFormatStyle.usMdy => '05/26/2026',
    DateFormatStyle.europeanDmy => '26/05/2026',
    DateFormatStyle.iso => '2026-05-26',
  };
  String _currencyFormatLabel(CurrencyFormat c) => switch (c) {
    CurrencyFormat.symbolBefore => 'Symbol before',
    CurrencyFormat.symbolAfter => 'Symbol after',
    CurrencyFormat.code => 'Code',
  };
  String _weekStartLabel(WeekStartDay d) => switch (d) {
    WeekStartDay.sunday => 'Sunday',
    WeekStartDay.monday => 'Monday',
    WeekStartDay.saturday => 'Saturday',
  };
}

// =============================================================
// Section header
// =============================================================
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionSubHeader extends StatelessWidget {
  const _SectionSubHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 4, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: scheme.onSurfaceVariant,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// =============================================================
// M3 static theme preset picker
// =============================================================
class _ThemePresetPicker extends StatelessWidget {
  const _ThemePresetPicker({
    required this.current,
    required this.onChanged,
  });

  final AppThemePreset current;
  final ValueChanged<AppThemePreset> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: current.seed.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(current.icon, color: current.seed, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme color',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pick a static M3 seed color for the app',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 2-column grid of preview cards.
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AppThemePreset.values.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final preset = AppThemePreset.values[index];
              return _PresetPreviewCard(
                preset: preset,
                selected: preset == current,
                onTap: () => onChanged(preset),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A square preview card for a single [AppThemePreset]. Renders a tiny
/// stylized "phone screen" mockup using the preset's [AppThemePreset.seed]
/// as the source of a full M3 tonal palette (primary / onPrimary /
/// surface / onSurface / primaryContainer / onPrimaryContainer), then
/// shows the preset name with a check-mark when selected.
class _PresetPreviewCard extends StatelessWidget {
  const _PresetPreviewCard({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final AppThemePreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Build a full M3 ColorScheme from the seed for both light and
    // dark; we always render the light preview in the picker card so
    // the user can clearly see the brand color.
    final light = ColorScheme.fromSeed(
      seedColor: preset.seed,
      brightness: Brightness.light,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: 'Theme preset: ${preset.label}',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: light.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? preset.seed : light.outlineVariant,
            width: selected ? 2.5 : 1,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: preset.seed.withValues(alpha: 0.30),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: light.shadow.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Mini "phone" preview frame — uses the preset's
                  // M3 tonal palette so the user can see exactly what
                  // they're picking.
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: light.surface,
                          border: Border.all(
                            color: light.outlineVariant
                                .withValues(alpha: 0.6),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Mini app bar
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 18,
                                color: light.primary,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Container(
                                  width: 36,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: light.onPrimary
                                        .withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                            // Mini primary card
                            Positioned(
                              top: 26,
                              left: 8,
                              right: 8,
                              child: Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: light.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: light.onPrimaryContainer,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    Container(
                                      width: 44,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: light.onPrimaryContainer
                                            .withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Mini filled button + outline button row
                            Positioned(
                              bottom: 10,
                              left: 8,
                              right: 8,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: light.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Container(
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: light.surface,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: light.primary,
                                          width: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Tiny check badge in the top-right corner
                            if (selected)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: preset.seed,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: preset.seed
                                            .withValues(alpha: 0.4),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Preset name
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: preset.seed,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          preset.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: selected ? preset.seed : light.onSurface,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
