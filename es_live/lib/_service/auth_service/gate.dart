// gate = คอยฟังสถานะ auth ตลอดเวลา แล้วสลับหน้าให้เอง
//
/*  ยังไม่ล็อกอิน => Login
    ล็อกอินแล้ว   => Screen (แท็บหลักทั้งหมด)  */
import 'package:es_live/auth/login.dart';
import 'package:es_live/screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      // ยิงค่าใหม่ทุกครั้งที่ล็อกอิน ออกจากระบบ หรือ token ถูกต่ออายุ
      stream: Supabase.instance.client.auth.onAuthStateChange,

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // stream ยังไม่ยิงค่าแรกในบางจังหวะ ถอยไปอ่าน session ที่เก็บในเครื่อง
        final session =
            snapshot.data?.session ?? Supabase.instance.client.auth.currentSession;

        if (session != null) {
          return const Screen();
        } else {
          return const Login();
        }
      },
    );
  }
}
