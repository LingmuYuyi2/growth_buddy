class Experience {
  int? id;
  int keikenchi;

  Experience({this.id, required this.keikenchi});

  Map<String, dynamic> toMap() {
    return {
      'experience': keikenchi,
    };
  }
}