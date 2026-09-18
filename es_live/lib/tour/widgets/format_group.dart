import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ส่วนหัวของหน้ารอบแบ่งกลุ่ม : ปุ่มย้อนกลับ + ชื่อลีก + ข้อมูลทัวร์
///
/// คืน Column ไม่ใช่ Scaffold เพราะถูกวางอยู่ข้างใน group.dart ที่มี Scaffold แล้ว
/// ซ้อน Scaffold กันจะเจอ "Cannot hit test a render box that has never been laid out"
class FormatGroup extends StatelessWidget {
  final String tourName;
  final String? leagueName;
  final String? leagueLogo;
  final String? startDate;
  final String? endDate;
  final String? region;
  final String? type;
  final int? teamCount;
  final String? prizePool;

  const FormatGroup({
    super.key,
    required this.tourName,
    required this.leagueName,
    required this.leagueLogo,
    required this.startDate,
    required this.endDate,
    required this.region,
    required this.type,
    required this.teamCount,
    required this.prizePool,
  });

  /// แปลงวันที่จาก API เป็น dd/MM/yyyy ถ้าไม่มีค่าให้เป็นขีด
  String _fmt(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(iso).toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final info = TextStyle(color: onSurface, fontSize: 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: onSurface),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (leagueLogo != null && leagueLogo!.isNotEmpty) ...[
                    SizedBox(
                      width: 34,
                      height: 34,
                      child: Image.network(
                        leagueLogo!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      leagueName ?? "-",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                tourName,
                style: TextStyle(color: AppColors.grey, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [
                  Text('${_fmt(startDate)} - ${_fmt(endDate)}', style: info),
                  Text('$teamCount Teams', style: info),
                  Text(region ?? "-", style: info),
                  Text(type ?? "-", style: info),
                  if (prizePool != null && prizePool!.isNotEmpty)
                    Text(
                      prizePool!,
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Standings',
                style: TextStyle(
                  color: onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
