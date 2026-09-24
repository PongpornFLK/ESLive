import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/_service/auth_service/auth.dart';
import 'package:es_live/auth/register.dart';
import 'package:es_live/auth/widgets/auth_field.dart';
import 'package:es_live/auth/widgets/auth_shell.dart';
import 'package:es_live/auth/widgets/pill_button.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// หน้าเข้าสู่ระบบ
/// สำเร็จแล้วไม่ต้อง Navigator เพราะ AuthGate ฟัง onAuthStateChange แล้วสลับหน้าให้เอง
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final authen = AuthService();

  // Variable TextController Email , Password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // สถานะที่ build อ่านไปเลือกว่าจะวาดอะไร
  bool _busy = false; // กำลังยิงไป server อยู่ไหม
  String? _message; // ข้อความ error  null = ไม่มีอะไรผิด

  @override
  void dispose() {
    // controller จองหน่วยความจำไว้ ต้องคืนเมื่อหน้าถูกปิด
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Func loggin button
  Future<void> login() async {
    final l10n = AppLocalizations.of(context);
    final email = emailController.text.trim();
    final password = passwordController.text;

    // เช็คในเครื่องก่อน ไม่ต้องเสียรอบเรียก server
    if (email.isEmpty || password.isEmpty) {
      setState(() => _message = l10n.fillEmailPassword);
      return;
    }

    setState(() {
      _busy = true; // ปุ่มหาย วงหมุนขึ้น กดซ้ำไม่ได้
      _message = null; // ล้างข้อความ
    });

    // attempt to sign in
    try {
      await authen.signIn(email, password);
    } on AuthException catch (e) {
      if (mounted) setState(() => _message = e.message); // msg จาก Supabase
    } catch (e) {
      if (mounted) setState(() => _message = l10n.somethingWrong);
    } finally {
      // ทำเสมอไม่ว่าสำเร็จหรือพัง ปุ่มจะไม่ค้างหมุน
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AuthShell(
      title: l10n.signIn,
      children: [
        AuthField(
          controller: emailController,
          hint: l10n.email,
          icon: Icons.mail_outline,
        ),
        const SizedBox(height: 12),
        AuthField(
          controller: passwordController,
          hint: l10n.password,
          icon: Icons.lock_outline,
          obscure: true,
        ),
        const SizedBox(height: 16),

        // จองที่ไว้เสมอ ข้อความขึ้นแล้วปุ่มจะไม่กระโดด
        SizedBox(
          height: 34,
          child:
              _message == null
                  ? null
                  : Text(
                    _message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.red, fontSize: 12),
                  ),
        ),

        _busy
            ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(color: AppColors.orange),
            )
            : PillButton(label: l10n.signIn, onTap: login),

        const SizedBox(height: 16),
        TextButton(
          onPressed:
              _busy
                  ? null
                  : () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register()),
                  ),
          child: Text(
            l10n.noAccountYet,
            style: const TextStyle(color: AppColors.gold),
          ),
        ),
      ],
    );
  }
}
