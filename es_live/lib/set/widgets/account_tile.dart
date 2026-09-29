import 'package:es_live/_service/noti/noti.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/_service/auth_service/auth.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// Account + SignOut ( Stateful เพราะต้องมี _busy ระหว่างรอ server )
/// แยกออกมาเพื่อให้ rebuild แค่แถวนี้ ไม่ลากทั้งหน้า
class AccountTile extends StatefulWidget {
  const AccountTile({super.key});

  @override
  State<AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  final authen = AuthService();
  bool _busy = false;

  Future<void> _signOut() async {
    final l10n = AppLocalizations.of(context);
    // ถามก่อน กันกดพลาด
    final ok = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(l10n.signOut),
            content: Text(l10n.signOutConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  l10n.signOut,
                  style: const TextStyle(color: AppColors.red),
                ),
              ),
            ],
          ),
    );

    if (ok != true) return;

    setState(() => _busy = true);

    try {
      await removeNoti();
    } catch (_) {}

    try {
      // สำเร็จแล้วไม่ต้อง Navigator เพราะ AuthGate ฟัง onAuthStateChange
      await authen.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.cantSignOut)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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
                  email ?? l10n.notSignedIn,
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
                Expanded(
                  child: Text(
                    l10n.signOut,
                    style: const TextStyle(
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
