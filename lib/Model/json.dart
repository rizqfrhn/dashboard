class JsonModel {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  JsonModel({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory JsonModel.fromJson(Map<String, dynamic> json) {
    return JsonModel(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}