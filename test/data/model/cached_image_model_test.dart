import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:search_images/data/model/search_image_model.dart';

import '../../fixtures/fixture_reader.dart';

void main() {

  final tSearchImageModel = SearchImageModel(
    display_sitename: '네이버블로그',
    thumbnail_url: 'https://search3.kakaocdn.net/argon/130x130_85_c/9cTdlueUGcH',
    image_url: 'http://postfiles10.naver.net/MjAyMDA3MDFfMTQy/MDAxNTkzNjA2NzIxMzg5.UdmxClwQUGITlk-UOzMEG8XiDWwEv9J1ob2qcmfFZVUg.DJ9ZIcMNk9BZq2Y7iVbdo_KdF8OvzDN0-V_zavDwz4Yg.JPEG.fkdin/%ED%86%A0%EB%81%BC...jpg?type=w773',
  );

  test(
    'SearchImageModel 모델이 맞는지 테스트',
    () async {
      expect(tSearchImageModel, isA<SearchImageModel>());
    },
  );

  group('SearchImageModel fromJson 테스트', () {
    test(
      '유효한 모델인지 체크',
      () async {

        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('토끼_model.json'));

        // act
        final result = SearchImageModel.fromJson(jsonMap);

        // assert
        expect(result.thumbnail_url, tSearchImageModel.thumbnail_url);
        expect(result.image_url, tSearchImageModel.image_url);
        expect(result.display_sitename, tSearchImageModel.display_sitename);
      },
    );
  });
}
