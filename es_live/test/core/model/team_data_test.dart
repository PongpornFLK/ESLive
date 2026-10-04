import 'package:es_live/core/model/team_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('TeamData.fromjson' , () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', (){
      final json = {
        "id": "uuid",
        "name": "Team Liquid",
        "logo_url": "https://cdn-api.pandascore.co/images/team/image/128796/600px_team_vitality_2023_darkmode.png",
      };

      final data = TeamData.fromjson(json);

      expect(data.teamId, "uuid");
      expect(data.teamName, "Team Liquid");
      expect(data.logoUrl, "https://cdn-api.pandascore.co/images/team/image/128796/600px_team_vitality_2023_darkmode.png");
    });

    test('ตรวจสอบข้อมูลที่เป็นแบบ null สามารถรับได้ทั้งหมด', (){
      final json = {
        "id": "uuid",
        "name": "Team Liquid",
        "logo_url": null,
      };

      final data = TeamData.fromjson(json);

      expect(data.teamId, "uuid");
      expect(data.teamName, "Team Liquid");
      expect(data.logoUrl, isNull);
    });
  });

}