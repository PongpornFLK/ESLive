import 'package:es_live/_service/auth_service/auth.dart';
import 'package:es_live/auth/widgets/auth_field.dart';
import 'package:es_live/auth/widgets/auth_shell.dart';
import 'package:es_live/auth/widgets/pill_button.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// หน้าสมัครสมาชิก ถูก push มาจาก Login
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _busy = false;
  String? _message;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;

    // เช็คในเครื่องก่อน ไม่ต้องเสียรอบเรียก server
    if (email.isEmpty || password.isEmpty) {
      setState(() => _message = "Fill in email and password");
      return;
    }
    if (password.length < 6) {
      setState(() => _message = "Password must be at least 6 characters");
      return;
    }
    if (password != _confirm.text) {
      setState(() => _message = "Passwords do not match");
      return;
    }

    setState(() {
      _busy = true;
      _message = null;
    });

    try {
      final res = await _auth.signUp(email, password);
      if (!mounted) return;

      if (res.session == null) {
        // ไม่ได้ session = Supabase ยังบังคับยืนยันอีเมลอยู่
        setState(() => _message = "Check your email to confirm the account");
      } else {
        // หน้านี้ถูก push ทับ AuthGate อยู่ ต้อง pop ออกเอง
        // ไม่งั้น gate สลับเป็น Screen แล้วแต่ผู้ใช้ยังค้างที่หน้านี้
        Navigator.pop(context);
        return;
      }
    } on AuthException catch (e) {
      if (mounted) setState(() => _message = e.message);
    } catch (e) {
      if (mounted) setState(() => _message = "Something went wrong");
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: "SIGN UP",
      children: [
        AuthField(
          controller: _email,
          hint: "Email",
          icon: Icons.mail_outline,
        ),
        const SizedBox(height: 12),
        AuthField(
          controller: _password,
          hint: "Password",
          icon: Icons.lock_outline,
          obscure: true,
        ),
        const SizedBox(height: 12),
        AuthField(
          controller: _confirm,
          hint: "Confirm password",
          icon: Icons.lock_outline,
          obscure: true,
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 34,
          child:
              _message == null
                  ? null
                  : Text(
                    _message!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.red,
                      fontSize: 12,
                    ),
                  ),
        ),

        _busy
            ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(color: AppColors.orange),
            )
            : PillButton(label: "SIGN UP", onTap: _submit),

        const SizedBox(height: 16),
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: const Text(
            "Already have an account? Sign in",
            style: TextStyle(color: AppColors.gold),
          ),
        ),
      ],
    );
  }
}
