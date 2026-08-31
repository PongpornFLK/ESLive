import 'package:es_live/screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Homepage",
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
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
                        AppColors.secondmain.withOpacity(0),
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
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Screen()),
                            ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          child: Text(
                            "LET’S WATCHING",
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
