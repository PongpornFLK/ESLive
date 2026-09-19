import 'package:es_live/core/model/match_data.dart';
import 'package:es_live/homelive/analyze/widgets/analysis_box.dart';
import 'package:es_live/homelive/analyze/widgets/history_match.dart';
import 'package:es_live/homelive/analyze/widgets/match_header.dart';
import 'package:es_live/homelive/analyze/widgets/winrate.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class MatchAnalyze extends StatefulWidget {
  final MatchData match;

  const MatchAnalyze({super.key, required this.match});

  @override
  State<MatchAnalyze> createState() => _MatchAnalyzeState();
}

class _MatchAnalyzeState extends State<MatchAnalyze> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
            MatchHeader(match: widget.match),
            SizedBox(height: 15),
            Winrate(),
            SizedBox(height: 15),
            AnalysisBox(),
            SizedBox(height: 15),
            HistoryMatch(),
          ],
        ),
      ),
    );
  }
}
