class Record {
  int? id;
  String category;
  String content;
  double effort;

  Record({this.id, required this.category, required this.content, required this.effort});

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'content': content,
      'effort': effort,
    };
  }
}
