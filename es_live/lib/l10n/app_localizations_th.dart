// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get navLive => 'สด';

  @override
  String get navTour => 'ทัวร์';

  @override
  String get navFollow => 'ติดตาม';

  @override
  String get navPatch => 'แพตช์';

  @override
  String get navSetting => 'ตั้งค่า';

  @override
  String get letsWatching => 'LET\'S WATCHING';

  @override
  String get game => 'เกม';

  @override
  String get match => 'แมตช์';

  @override
  String get live => 'สด!';

  @override
  String get comingSoon => 'กำลังจะแข่ง';

  @override
  String get notFound => 'ไม่พบข้อมูล';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get noNotiYet => 'ยังไม่มีการแจ้งเตือน';

  @override
  String get clearAll => 'ล้างทั้งหมด';

  @override
  String get notiSubtitle => 'แจ้งเตือนก่อนแมตช์เริ่ม';

  @override
  String get notiOn => 'เปิด';

  @override
  String get notiOnDetail => 'รับแจ้งเตือนบนเครื่องนี้';

  @override
  String get notiOff => 'ปิด';

  @override
  String get notiOffDetail => 'ไม่รับแจ้งเตือนบนเครื่องนี้';

  @override
  String get notiBefore => 'เวลาแจ้งเตือน';

  @override
  String get notiBeforeSubtitle => 'จะเตือนล่วงหน้ากี่นาทีก่อนแข่ง';

  @override
  String notiMinutes(int count) {
    return 'ก่อนเริ่ม $count นาที';
  }

  @override
  String get notiMinutesDetail => 'เตือนตอนใกล้จะเริ่มแข่ง';

  @override
  String get notiScope => 'เตือนแมตช์ไหน';

  @override
  String get notiScopeSubtitle => 'เลือกขอบเขตของการแจ้งเตือน';

  @override
  String get notiFollowOnly => 'ทีมที่ติดตาม';

  @override
  String get notiFollowOnlyDetail => 'เฉพาะแมตช์ของทีมที่ติดตาม';

  @override
  String get notiAllMatches => 'ทุกแมตช์';

  @override
  String get notiAllMatchesDetail => 'ทุกแมตช์ที่กำลังจะแข่ง';

  @override
  String get noLiveNow => 'ยังไม่มีการไลฟ์สดตอนนี้';

  @override
  String liveCountNow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'กำลังไลฟ์สด $count แมตช์!',
      zero: 'ยังไม่มีการไลฟ์สดตอนนี้!',
    );
    return '$_temp0';
  }

  @override
  String get signIn => 'เข้าสู่ระบบ';

  @override
  String get signUp => 'สมัครสมาชิก';

  @override
  String get email => 'อีเมล';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get confirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String get fillEmailPassword => 'กรอกอีเมลและรหัสผ่าน';

  @override
  String get passwordTooShort => 'รหัสผ่านต้องยาวอย่างน้อย 6 ตัว';

  @override
  String get passwordNotMatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get checkEmailConfirm => 'เช็คอีเมลเพื่อยืนยันบัญชี';

  @override
  String get somethingWrong => 'เกิดข้อผิดพลาด';

  @override
  String get noAccountYet => 'ยังไม่มีบัญชี? สมัครเลย';

  @override
  String get alreadyHaveAccount => 'มีบัญชีอยู่แล้ว? เข้าสู่ระบบ';

  @override
  String get following => 'กำลังติดตาม';

  @override
  String get notFollowingYet => 'ยังไม่ได้ติดตามทีมไหน';

  @override
  String get cantLoadSchedule => 'โหลดตารางแข่งไม่ได้ แสดงเฉพาะรายชื่อทีม';

  @override
  String get noUpcomingMatch => 'ไม่มีนัดที่จะแข่ง';

  @override
  String get follow => 'ติดตาม';

  @override
  String get unfollow => 'เลิกติดตาม';

  @override
  String matchAt(String time) {
    return '$time';
  }

  @override
  String matchTomorrow(String time) {
    return 'พรุ่งนี้ $time';
  }

  @override
  String matchOnDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get aiAnalysis => 'วิเคราะห์โดย AI';

  @override
  String get winRate => 'โอกาสชนะ';

  @override
  String latestMatches(int count) {
    return '$count นัดล่าสุด';
  }

  @override
  String get streamUrl => 'ดูถ่ายทอดสด';

  @override
  String get cantOpenStream => 'เปิดลิงก์ถ่ายทอดไม่ได้';

  @override
  String get noAnalysisYet => 'ยังไม่มีผลวิเคราะห์';

  @override
  String get noAnalysisForMatch => 'ยังไม่มีผลวิเคราะห์สำหรับแมตช์นี้';

  @override
  String get noHistoryInSystem => 'ไม่มีประวัติการแข่งในระบบ';

  @override
  String get viewAll => 'ดูทั้งหมด';

  @override
  String get viewSource => 'เปิดหน้าต้นฉบับ';

  @override
  String get cantOpenLink => 'เปิดลิงก์ไม่ได้';

  @override
  String patchVersion(String version) {
    return 'แพตช์ $version';
  }

  @override
  String get noSummaryYet => 'กำลังสรุปอยู่ รอสักครู่';

  @override
  String teamCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ทีม',
      zero: 'ไม่มีทีม',
    );
    return '$_temp0';
  }

  @override
  String get noStandingYet => 'ยังไม่มีตารางคะแนนของทัวร์นี้';

  @override
  String get rankOnlyNoStats => 'ทัวร์นี้ยังไม่มีสถิติแพ้ชนะ แสดงได้เฉพาะอันดับ';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get theme => 'ธีม';

  @override
  String get themeSubtitle => 'เลือกโหมดสีของแอป';

  @override
  String get themeSystem => 'ตามระบบ';

  @override
  String get themeSystemDetail => 'เปลี่ยนตามการตั้งค่าของเครื่อง';

  @override
  String get themeLight => 'สว่าง';

  @override
  String get themeLightDetail => 'พื้นหลังสีอ่อน';

  @override
  String get themeDark => 'มืด';

  @override
  String get themeDarkDetail => 'พื้นหลังสีเข้ม';

  @override
  String get language => 'ภาษา';

  @override
  String get languageSubtitle => 'เลือกภาษาของแอป';

  @override
  String get langEnglish => 'English';

  @override
  String get langEnglishDetail => 'ภาษาอังกฤษ';

  @override
  String get langThai => 'ไทย';

  @override
  String get langThaiDetail => 'ภาษาไทย';

  @override
  String get account => 'บัญชี';

  @override
  String get accountSubtitle => 'บัญชีที่เข้าสู่ระบบอยู่';

  @override
  String get signOut => 'ออกจากระบบ';

  @override
  String get signOutConfirm => 'ออกจากระบบใช่ไหม';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get notSignedIn => 'ยังไม่ได้เข้าสู่ระบบ';

  @override
  String get cantSignOut => 'ออกจากระบบไม่ได้';
}
