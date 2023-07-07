class Counter {
  int? id;
  int count;

  Counter({this.id, required this.count});

  Map<String, dynamic> toMap() {
    return {
      'count': count,
    };
  }
}