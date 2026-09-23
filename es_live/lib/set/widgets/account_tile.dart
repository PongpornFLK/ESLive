import 'package:es_live/_service/auth_service/auth.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// แถวบัญชี + ปุ่มออกจากระบบ ใช้ใน _SectionCard ของหน้า Setting
///
/// เป็น StatefulWidget เพราะต้องมี _busy ระหว่างรอ server
/// แยกออกมาเพื่อให้ rebuild แค่แถวนี้ ไม่ลากทั้งหน้า Setting
class AccountTile extends StatefulWidget {
  const AccountTile({super.key});

  @override
  State<AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  final authen = AuthService();
  bool _busy = false;

  Future<void> _signOut() async {
    // ถามก่อน กันกดพลาด
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Sign out'),
            content: const Text('ออกจากระบบใช่ไหม'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'ออกจากระบบ',
                  style: TextStyle(color: AppColors.red),
                ),
              ),
            ],
          ),
    );

    if (ok != true) return;

    setState(() => _busy = true);
    try {
      // สำเร็จแล้วไม่ต้อง Navigator เพราะ AuthGate ฟัง onAuthStateChange
      // แล้วสลับกลับไปหน้า Login ให้เอง
      await authen.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Can't sign out")));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = authen.getUserEmail();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(
                Icons.account_circle_rounded,
                size: 22,
                color: AppColors.orange,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  email ?? 'ยังไม่ได้เข้าสู่ระบบ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: _busy ? null : _signOut,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.logout_rounded,
                  size: 22,
                  color: AppColors.red,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'ออกจากระบบ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.red,
                    ),
                  ),
                ),
                if (_busy)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
