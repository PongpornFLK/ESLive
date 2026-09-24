import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th')
  ];

  /// No description provided for @navLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get navLive;

  /// No description provided for @navTour.
  ///
  /// In en, this message translates to:
  /// **'Tour'**
  String get navTour;

  /// No description provided for @navFollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get navFollow;

  /// No description provided for @navPatch.
  ///
  /// In en, this message translates to:
  /// **'Patch'**
  String get navPatch;

  /// No description provided for @navSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get navSetting;

  /// No description provided for @letsWatching.
  ///
  /// In en, this message translates to:
  /// **'LET\'S WATCHING'**
  String get letsWatching;

  /// No description provided for @game.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// No description provided for @match.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get match;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live!'**
  String get live;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get notFound;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @fillEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Fill in email and password'**
  String get fillEmailPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordNotMatch;

  /// No description provided for @checkEmailConfirm.
  ///
  /// In en, this message translates to:
  /// **'Check your email to confirm the account'**
  String get checkEmailConfirm;

  /// No description provided for @somethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWrong;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Sign up'**
  String get noAccountYet;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @notFollowingYet.
  ///
  /// In en, this message translates to:
  /// **'You are not following yet.'**
  String get notFollowingYet;

  /// No description provided for @cantLoadSchedule.
  ///
  /// In en, this message translates to:
  /// **'Can\'t load schedule. Showing teams only.'**
  String get cantLoadSchedule;

  /// No description provided for @noUpcomingMatch.
  ///
  /// In en, this message translates to:
  /// **'No upcoming match'**
  String get noUpcomingMatch;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @unfollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// เวลาเริ่มแมตช์ของวันนี้
  ///
  /// In en, this message translates to:
  /// **'{time}'**
  String matchAt(String time);

  /// นัดที่แข่งพรุ่งนี้
  ///
  /// In en, this message translates to:
  /// **'Tomorrow {time}'**
  String matchTomorrow(String time);

  /// วันเวลาของนัดที่ไกลกว่าพรุ่งนี้ ฟอร์แมตตามภาษา
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String matchOnDate(DateTime date);

  /// No description provided for @aiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysis;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win Rate'**
  String get winRate;

  /// หัวข้อประวัติการแข่ง
  ///
  /// In en, this message translates to:
  /// **'Latest {count} Matches'**
  String latestMatches(int count);

  /// No description provided for @streamUrl.
  ///
  /// In en, this message translates to:
  /// **'Stream URL'**
  String get streamUrl;

  /// No description provided for @cantOpenStream.
  ///
  /// In en, this message translates to:
  /// **'Can\'t open stream link'**
  String get cantOpenStream;

  /// No description provided for @noAnalysisYet.
  ///
  /// In en, this message translates to:
  /// **'No analysis yet'**
  String get noAnalysisYet;

  /// No description provided for @noAnalysisForMatch.
  ///
  /// In en, this message translates to:
  /// **'No analysis for this match yet'**
  String get noAnalysisForMatch;

  /// No description provided for @noHistoryInSystem.
  ///
  /// In en, this message translates to:
  /// **'No match history in the system'**
  String get noHistoryInSystem;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// หัวข้อแพตช์
  ///
  /// In en, this message translates to:
  /// **'Patch {version}'**
  String patchVersion(String version);

  /// จำนวนทีมในทัวร์นาเมนต์ รูปเอกพจน์พหูพจน์ต่างกันในภาษาอังกฤษ
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No teams} =1{1 Team} other{{count} Teams}}'**
  String teamCount(int count);

  /// No description provided for @noStandingYet.
  ///
  /// In en, this message translates to:
  /// **'No standings for this tournament yet'**
  String get noStandingYet;

  /// No description provided for @rankOnlyNoStats.
  ///
  /// In en, this message translates to:
  /// **'This tournament has no win/loss stats, rank only'**
  String get rankOnlyNoStats;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the app color mode'**
  String get themeSubtitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeSystemDetail.
  ///
  /// In en, this message translates to:
  /// **'Follow the device setting'**
  String get themeSystemDetail;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeLightDetail.
  ///
  /// In en, this message translates to:
  /// **'Light background'**
  String get themeLightDetail;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeDarkDetail.
  ///
  /// In en, this message translates to:
  /// **'Dark background'**
  String get themeDarkDetail;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language'**
  String get languageSubtitle;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langEnglishDetail.
  ///
  /// In en, this message translates to:
  /// **'Default language'**
  String get langEnglishDetail;

  /// No description provided for @langThai.
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get langThai;

  /// No description provided for @langThaiDetail.
  ///
  /// In en, this message translates to:
  /// **'Thai language'**
  String get langThaiDetail;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The account you are signed in with'**
  String get accountSubtitle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out of this account?'**
  String get signOutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notSignedIn;

  /// No description provided for @cantSignOut.
  ///
  /// In en, this message translates to:
  /// **'Can\'t sign out'**
  String get cantSignOut;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'th': return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
