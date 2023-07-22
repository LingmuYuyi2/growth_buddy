class LastUpdate {
  int? id;
  String lastUpdatedID;

  LastUpdate({this.id, required this.lastUpdatedID});

  Map<String, dynamic> toMap() {
    return {
      'last_updated_id': lastUpdatedID,
    };
  }
}