// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navLive => 'Live';

  @override
  String get navTour => 'Tour';

  @override
  String get navFollow => 'Follow';

  @override
  String get navPatch => 'Patch';

  @override
  String get navSetting => 'Setting';

  @override
  String get letsWatching => 'LET\'S WATCHING';

  @override
  String get game => 'Game';

  @override
  String get match => 'Match';

  @override
  String get live => 'Live!';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get notFound => 'Not Found';

  @override
  String get signIn => 'SIGN IN';

  @override
  String get signUp => 'SIGN UP';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get fillEmailPassword => 'Fill in email and password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordNotMatch => 'Passwords do not match';

  @override
  String get checkEmailConfirm => 'Check your email to confirm the account';

  @override
  String get somethingWrong => 'Something went wrong';

  @override
  String get noAccountYet => 'No account yet? Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get following => 'Following';

  @override
  String get notFollowingYet => 'You are not following yet.';

  @override
  String get cantLoadSchedule => 'Can\'t load schedule. Showing teams only.';

  @override
  String get noUpcomingMatch => 'No upcoming match';

  @override
  String get follow => 'Follow';

  @override
  String get unfollow => 'Unfollow';

  @override
  String matchAt(String time) {
    return '$time';
  }

  @override
  String matchTomorrow(String time) {
    return 'Tomorrow $time';
  }

  @override
  String matchOnDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get aiAnalysis => 'AI Analysis';

  @override
  String get winRate => 'Win Rate';

  @override
  String latestMatches(int count) {
    return 'Latest $count Matches';
  }

  @override
  String get streamUrl => 'Stream URL';

  @override
  String get cantOpenStream => 'Can\'t open stream link';

  @override
  String get noAnalysisYet => 'No analysis yet';

  @override
  String get noAnalysisForMatch => 'No analysis for this match yet';

  @override
  String get noHistoryInSystem => 'No match history in the system';

  @override
  String get viewAll => 'View All';

  @override
  String get viewSource => 'Open source page';

  @override
  String get cantOpenLink => 'Can\'t open link';

  @override
  String patchVersion(String version) {
    return 'Patch $version';
  }

  @override
  String teamCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Teams',
      one: '1 Team',
      zero: 'No teams',
    );
    return '$_temp0';
  }

  @override
  String get noStandingYet => 'No standings for this tournament yet';

  @override
  String get rankOnlyNoStats => 'This tournament has no win/loss stats, rank only';

  @override
  String get settings => 'SETTINGS';

  @override
  String get theme => 'Theme';

  @override
  String get themeSubtitle => 'Choose the app color mode';

  @override
  String get themeSystem => 'System';

  @override
  String get themeSystemDetail => 'Follow the device setting';

  @override
  String get themeLight => 'Light';

  @override
  String get themeLightDetail => 'Light background';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeDarkDetail => 'Dark background';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Choose the app language';

  @override
  String get langEnglish => 'English';

  @override
  String get langEnglishDetail => 'Default language';

  @override
  String get langThai => 'ไทย';

  @override
  String get langThaiDetail => 'Thai language';

  @override
  String get account => 'Account';

  @override
  String get accountSubtitle => 'The account you are signed in with';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Sign out of this account?';

  @override
  String get cancel => 'Cancel';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get cantSignOut => 'Can\'t sign out';
}
