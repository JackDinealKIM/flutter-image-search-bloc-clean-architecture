import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:search_images/data/datasources/search_image_local_data_source.dart';
import 'package:mockito/mockito.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

void main() {
  late SearchImageLocalDataSourceImpl dataSource;
  MockHiveInterface mockHive;

  setUp(() async {
    dataSource = SearchImageLocalDataSourceImpl();
    // init hive
    // mockHive = MockHiveInterface();
    // mockHive.init(HIVE_DATABASE);
    // mockHive.registerAdapter(CachedImageModelAdapter());
  });

  group('Hive 로컬DB 테스트', () {
    test("로컬 DB 추가 후, 갯수가 늘어났는지 확인", () async {
      // const image = SearchImage(siteName: '네이버블로그', thumbnailUrl: 'https://search3.kakaocdn.net/argon/130x130_85_c/9cTdlueUGcH', imageUrl: 'http://postfiles10.naver.net/MjAyMDA3MDFfMTQy/MDAxNTkzNjA2NzIxMzg5.UdmxClwQUGITlk-UOzMEG8XiDWwEv9J1ob2qcmfFZVUg.DJ9ZIcMNk9BZq2Y7iVbdo_KdF8OvzDN0-V_zavDwz4Yg.JPEG.fkdin/%ED%86%A0%EB%81%BC...jpg?type=w773', isFavorited: true);
      //
      // final result = await dataSource.addImage(image);
      //
      // // 추가 후 갯수가 늘어났는지 확인
      // expect(result.length, greaterThan(1));
    });
  });
}
