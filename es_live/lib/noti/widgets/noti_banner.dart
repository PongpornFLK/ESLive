import 'package:es_live/core/config/nav_key.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// Topbar ใช้ตอนแจ้งเตือนเข้ามาขณะแอปเปิดค้างอยู่
/// ตัวนี้เรียกจาก provider ได้เลยผ่าน Overlay ของ Navigator ตัวหลัก
void showNotiBanner({
  required String title,
  required String body,
  VoidCallback? onTap,
}) {
  final overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) return;

  late OverlayEntry entry;

  void close() {
    if (entry.mounted) entry.remove();
  }

  entry = OverlayEntry(
    builder:
        (context) => _BannerCard(
          title: title,
          body: body,
          onClose: close,
          onTap: () {
            close();
            onTap?.call();
          },
        ),
  );

  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 5), close);
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.title,
    required this.body,
    required this.onTap,
    required this.onClose,
  });

  final String title;
  final String body;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 12,
      right: 12,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.orange, AppColors.gold],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications_active_rounded,
                  color: AppColors.secondmain,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.secondmain,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.secondmain,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: AppColors.secondmain),
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
