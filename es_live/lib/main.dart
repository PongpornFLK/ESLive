import 'package:es_live/_service/auth_service/gate.dart';
import 'package:es_live/core/config/supabase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:es_live/core/theme/app_theme.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/core/lang/locale_pro.dart';
import 'package:es_live/core/theme/theme_pro.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ต้องเรียกก่อนแตะ Supabase.instance
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: "Homepage",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // ต่อระบบภาษา  AppLocalizations.of(context) อ่านค่าจาก 3 บรรทัดนี้
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);

          return Scaffold(
            backgroundColor: AppColors.secondmain,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assests/img/bg-app.png',
                  fit: BoxFit.cover,
                  opacity: const AlwaysStoppedAnimation(0.2),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        AppColors.orange,
                        AppColors.secondmain.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
                Center(child: Image.asset('assests/img/logo.png')),
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold,
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [AppColors.orange, AppColors.gold],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        // ใช้ AuthGate() แทน
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AuthGate(),
                              ),
                            ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          child: Text(
                            l10n.letsWatching,
                            style: TextStyle(
                              color: AppColors.secondmain,
                              fontFamily: "Genos",
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "2 MATCH LIVE STREAM NOW!",
                      style: TextStyle(
                        color: AppColors.red,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
