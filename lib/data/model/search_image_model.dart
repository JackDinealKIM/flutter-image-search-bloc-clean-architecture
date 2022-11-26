/*
  {
    "collection": "blog",
    "datetime": "2020-07-01T22:48:00.000+09:00",
    "display_sitename": "네이버블로그",
    "doc_url": "http://blog.naver.com/fkdin/222018324074",
    "height": 429,
    "image_url": "http://postfiles10.naver.net/MjAyMDA3MDFfMTQy/MDAxNTkzNjA2NzIxMzg5.UdmxClwQUGITlk-UOzMEG8XiDWwEv9J1ob2qcmfFZVUg.DJ9ZIcMNk9BZq2Y7iVbdo_KdF8OvzDN0-V_zavDwz4Yg.JPEG.fkdin/%ED%86%A0%EB%81%BC...jpg?type=w773",
    "thumbnail_url": "https://search3.kakaocdn.net/argon/130x130_85_c/9cTdlueUGcH",
    "width": 640
  }
*/
class SearchImageModel {
  final String display_sitename;
  final String thumbnail_url;
  final String image_url;

  const SearchImageModel({
    required this.display_sitename,
    required this.thumbnail_url,
    required this.image_url,
  });

  factory SearchImageModel.fromJson(Map<String, dynamic> json) {
    return SearchImageModel(
      display_sitename: json['display_sitename'],
      thumbnail_url: json['thumbnail_url'],
      image_url: json['image_url'],
    );
  }
}
