import 'package:es_live/core/model/tour_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // key ในนี้ลอกจาก TournamentOut ของ backend ตรง ๆ
  // backend เลิกส่ง begin_at / end_at / region ในชั้นสเตจแล้ว
  // สามช่องนั้นย้ายไปอยู่ชั้น serie ซึ่งเป็นที่ที่มันหมายถึงจริง
  group('TournamentData.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final json = {
        "id": "uuid",
        "game_id": "game-uuid",
        "name": "Group A",
        "league_name": "VCT",
        "league_logo_url":
            "https://cdn-api.pandascore.co/images/league/image/4366/a6QwKq5.png",
        "type": "online",
        "team_count": 32,
        "has_bracket": true,
        "prizepool": "20 USD",
        "created_at": "2026-09-18T09:05:46.010391Z",
      };

      final data = TournamentData.fromjson(json);

      expect(data.tourId, "uuid");
      expect(data.tourName, "Group A");
      expect(data.leagueName, "VCT");
      expect(
        data.leagueLogoUrl,
        "https://cdn-api.pandascore.co/images/league/image/4366/a6QwKq5.png",
      );
      expect(data.type, "online");
      expect(data.teamCount, 32);
      expect(data.hasBracket, true);
      expect(data.prizePool, "20 USD");
    });

    test('ตรวจสอบข้อมูลที่เป็นแบบ null และ false สามารถรับได้ทั้งหมด', () {
      final json = {
        "id": "uuid",
        "game_id": "game-uuid",
        "name": "Group A",
        "league_name": null,
        "league_logo_url": null,
        "type": null,
        "team_count": null,
        "has_bracket": false,
        "prizepool": null,
        "created_at": "2026-09-18T09:05:46.010391Z",
      };

      final data = TournamentData.fromjson(json);

      expect(data.tourId, "uuid");
      expect(data.tourName, "Group A");
      expect(data.leagueName, isNull);
      expect(data.leagueLogoUrl, isNull);
      expect(data.type, isNull);
      expect(data.teamCount, isNull);
      expect(data.hasBracket, false);
      expect(data.prizePool, isNull);
    });
  });

  // SerieData คือชั้นที่ห่อสเตจไว้ ทุกช่องสเกลาร์เป็น null ได้ตาม SerieOut
  // ส่วนสองลิสต์ backend ส่ง [] มาเสมอ ไม่เคยส่ง null
  group('SerieData.fromjson', () {
    Map<String, dynamic> stage(String id, String name) => {
      "id": id,
      "game_id": "game-uuid",
      "name": name,
      "league_name": "VCT",
      "league_logo_url": null,
      "type": "offline",
      "team_count": 4,
      "has_bracket": true,
      "prizepool": null,
      "created_at": "2026-09-18T09:05:46.010391Z",
    };

    test('แปลง JSON ที่มีครบทุก field และแตกสองถังเป็นวัตถุ', () {
      final json = {
        "serie_id": 10953,
        "serie_name": "Champions 2026",
        "region": "ASIA",
        "begin_at": "2026-09-24T09:00:00Z",
        "end_at": "2026-10-18T11:00:00Z",
        "league_name": "VCT",
        "league_logo_url": "https://cdn-api.pandascore.co/logo.png",
        "type": "offline",
        "playoff_stages": [stage("p1", "Playoffs")],
        "group_stages": [stage("g1", "Group A"), stage("g2", "Group B")],
      };

      final data = SerieData.fromjson(json);

      expect(data.serieId, 10953);
      expect(data.serieName, "Champions 2026");
      expect(data.region, "ASIA");
      expect(data.beginAt, "2026-09-24T09:00:00Z");
      expect(data.endAt, "2026-10-18T11:00:00Z");
      expect(data.leagueName, "VCT");
      expect(data.leagueLogoUrl, "https://cdn-api.pandascore.co/logo.png");
      expect(data.type, "offline");

      // สองถังต้องถูกแปลงเป็น TournamentData ไม่ใช่ Map ดิบ
      expect(data.playoffStages.length, 1);
      expect(data.playoffStages[0].tourName, "Playoffs");
      expect(data.groupStages.length, 2);
      expect(data.groupStages[1].tourName, "Group B");
    });

    test('ถังว่างได้ทั้งสองข้าง และช่องสเกลาร์เป็น null ได้', () {
      // 5 serie ไม่มีรอบคัดออก และ 14 serie ไม่มีรอบกลุ่ม backend ส่ง [] มา
      final json = {
        "serie_id": null,
        "serie_name": null,
        "region": null,
        "begin_at": null,
        "end_at": null,
        "league_name": null,
        "league_logo_url": null,
        "type": null,
        "playoff_stages": [],
        "group_stages": [],
      };

      final data = SerieData.fromjson(json);

      expect(data.serieId, isNull);
      expect(data.serieName, isNull);
      expect(data.region, isNull);
      expect(data.beginAt, isNull);
      expect(data.endAt, isNull);
      expect(data.leagueName, isNull);
      expect(data.leagueLogoUrl, isNull);
      expect(data.type, isNull);
      expect(data.playoffStages, isEmpty);
      expect(data.groupStages, isEmpty);
    });
  });
}
