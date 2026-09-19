import 'package:es_live/homelive/analyze/widgets/analysis_box.dart';
import 'package:es_live/homelive/analyze/widgets/history_match.dart';
import 'package:es_live/homelive/analyze/widgets/match_header.dart';
import 'package:es_live/homelive/analyze/widgets/winrate.dart';
import 'package:flutter/material.dart';

class MatchAnalyze extends StatefulWidget {
  const MatchAnalyze({super.key});

  @override
  State<MatchAnalyze> createState() => _MatchAnalyzeState();
}

class _MatchAnalyzeState extends State<MatchAnalyze> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          MatchHeader(),
          SizedBox(height: 15),
          Winrate(),
          SizedBox(height: 15),
          AnalysisBox(),
          SizedBox(height: 15),
          HistoryMatch(),
        ],
      ),
    );
  }
}
