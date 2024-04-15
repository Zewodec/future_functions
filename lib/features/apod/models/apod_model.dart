class ApodModel {
  DateTime date;
  String explanation;
  String imageUrl;
  String title;

  ApodModel({
    required this.date,
    required this.explanation,
    required this.imageUrl,
    required this.title,
  });

  factory ApodModel.fromJson(Map<String, dynamic> json) {
    return ApodModel(
      date: DateTime.parse(json['date']),
      explanation: json['explanation'],
      imageUrl: json['url'],
      title: json['title'],
    );
  }
}
