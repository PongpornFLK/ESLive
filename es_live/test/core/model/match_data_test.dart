import 'package:es_live/core/model/match_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // MatchData ประกอบจากโมเดลอื่นถึง 4 ตัว ก้อน JSON จึงซ้อนกันหลายชั้น
  final teamAJson = {
    'id': 'team-a',
    'name': 'Catboys',
    'logo_url': 'https://example.com/catboys.png',
  };
  final teamBJson = {
    'id': 'team-b',
    'name': 'HooK Esport',
    'logo_url': null,
  };
  final tourJson = {
    'id': 'tour-1',
    'name': 'VCT Pacific',
    'league_name': 'VCT',
    'league_logo_url': null,
    'begin_at': '2026-10-01T00:00:00+00:00',
    'end_at': '2026-10-20T00:00:00+00:00',
    'region': 'ASIA',
    'type': 'online',
    'team_count': 12,
    'has_bracket': true,
    'prizepool': '20 USD',
  };

  Map<String, dynamic> baseJson() => {
    'id': 'match-1',
    'status': 'live',
    'team_a': teamAJson,
    'team_b': teamBJson,
    'score_a': 1,
    'score_b': 0,
    'stream_url': 'https://twitch.tv/valorant',
    'tournament': tourJson,
    'game': {'name': 'Valorant'},
    'begin_at': '2026-10-04T12:00:00+00:00',
    'analysis': {
      'win_pct_a': 60.0,
      'win_pct_b': 40.0,
      'reasoning_eng': 'Catboys favoured.',
      'reasoning_th': 'Catboys ได้เปรียบ',
      'status': 'ready',
    },
  };

  group('MatchData.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final match = MatchData.fromjson(baseJson());

      expect(match.id, 'match-1');
      expect(match.status, 'live');
      expect(match.scoreA, 1);
      expect(match.scoreB, 0);
      expect(match.streamUrl, 'https://twitch.tv/valorant');
      expect(match.beginAt, '2026-10-04T12:00:00+00:00');
    });

    test('ก้อนซ้อนทั้ง 4 ถูกแปลงเป็นวัตถุ ไม่ใช่ Map ดิบ', () {
      final match = MatchData.fromjson(baseJson());

      expect(match.teamA.teamName, 'Catboys');
      expect(match.teamB.teamName, 'HooK Esport');
      expect(match.game.gameName, 'Valorant');
      expect(match.tournament.tourName, 'VCT Pacific');
      expect(match.matchAnalyze?.winRateA, 60.0);
    });

    test('analysis เป็น null ตอนยังไม่ได้วิเคราะห์ ต้องไม่แครช', () {
      final json = baseJson();
      json['analysis'] = null;

      final match = MatchData.fromjson(json);

      // บรรทัด analysis == null ? null : ... ใน fromjson ทำหน้าที่ตรงนี้
      expect(match.matchAnalyze, isNull);
      // ที่เหลือต้องยังอ่านได้ตามปกติ
      expect(match.teamA.teamName, 'Catboys');
      expect(match.status, 'live');
    });

    test('stream_url เป็น null ได้ เพราะแมตช์ที่ยังไม่เริ่มยังไม่มีลิงก์ไลฟ์', () {
      final json = baseJson();
      json['stream_url'] = null;
      json['status'] = 'upcoming';

      final match = MatchData.fromjson(json);

      expect(match.streamUrl, isNull);
      expect(match.status, 'upcoming');
    });
  });
}
