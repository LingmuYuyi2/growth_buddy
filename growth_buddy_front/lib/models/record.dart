class Record {
  int? id;
  String category;
  String content;
  double effort;
  String date;

  Record({this.id, required this.category, required this.content, required this.effort, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'content': content,
      'effort': effort,
      'date': date,
    };
  }
}
