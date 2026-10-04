import 'package:es_live/core/model/tour_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TournamentData.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final json = {
        "id": "uuid",
        "name": "pubg-continental-series-asia-1-2020-finals",
        "league_name": "VCT",
        "league_logo_url":
            "https://cdn-api.pandascore.co/images/league/image/4366/a6QwKq5.png",
        "begin_at": "2020-06-26 10:00:00+00",
        "end_at": "2026-07-04 10:30:00+00",
        "region": "ASIA",
        "type": "online",
        "team_count": 32,
        "has_bracket": true,
        "prizepool": "20 USD",
      };

      final data = TournamentData.fromjson(json);

      expect(data.tourId, "uuid");
      expect(data.tourName, "pubg-continental-series-asia-1-2020-finals");
      expect(data.leagueName, "VCT");
      expect(
        data.leagueLogo,
        "https://cdn-api.pandascore.co/images/league/image/4366/a6QwKq5.png",
      );
      expect(data.startDate, "2020-06-26 10:00:00+00");
      expect(data.endDate, "2026-07-04 10:30:00+00");
      expect(data.region, "ASIA");
      expect(data.type, "online");
      expect(data.teamCount, 32);
      expect(data.hasBracket, true);
      expect(data.prizePool, "20 USD");
    });

    test('ตรวจสอบข้อมูลที่เป็นแบบ null และ false สามารถรับได้ทั้งหมด', () {
      final json = {
        "id": "uuid",
        "name": "pubg-continental-series-asia-1-2020-finals",
        "league_name": null,
        "league_logo_url": null,
        "begin_at": null,
        "end_at": null,
        "region": null,
        "type": null,
        "team_count": null,
        "has_bracket": false,
        "prizepool": null,
      };

      final data = TournamentData.fromjson(json);

      expect(data.tourId, "uuid");
      expect(data.tourName, "pubg-continental-series-asia-1-2020-finals");
      expect(data.leagueName, isNull);
      expect(data.leagueLogo, isNull);
      expect(data.startDate, isNull);
      expect(data.endDate, isNull);
      expect(data.region, isNull);
      expect(data.type, isNull);
      expect(data.teamCount, isNull);
      expect(data.hasBracket, false);
      expect(data.prizePool, isNull);
    });
  });
}
