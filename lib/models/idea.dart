import 'dart:core';

class Idea {
  double _timestamp;
  String _title;
  String _description;
  String _url;
  int _votes;

  Idea.fromJson(Map<String, dynamic> data) {
    _title = data['title'];
    _description = data['selftext'];
    _timestamp = data['created_utc'];
    _url = data['url'];
    _votes = data['ups'];
  }

  get title => _title;
}
