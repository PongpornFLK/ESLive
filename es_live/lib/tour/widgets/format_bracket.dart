import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatBracket extends StatelessWidget {
  final String tourName;
  final String? leagueName;
  final String? startDate;
  final String? endDate;
  final String? region;
  final String? type;
  final int? teamCount;
  final String? prizePool;

  const FormatBracket({
    super.key,
    required this.tourName,
    required this.leagueName,
    required this.startDate,
    required this.endDate,
    required this.region,
    required this.type,
    required this.teamCount,
    required this.prizePool,
  });

  @override
  Widget build(BuildContext context) {
    final startTime =
        startDate == null
            ? "-"
            : DateFormat(
              'dd/MM/yyyy',
            ).format(DateTime.parse(startDate!).toLocal());
    final endTime =
        endDate == null
            ? "-"
            : DateFormat(
              'dd/MM/yyyy',
            ).format(DateTime.parse(endDate!).toLocal());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leagueName ?? "-",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [
                  Text(
                    "$startTime - $endTime",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "$teamCount Team",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    region ?? "-",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                    ),
                  ),
                  if (prizePool != null)
                    Text(
                      prizePool!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                "Bracket",
                style: TextStyle(
                  color: AppColors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
