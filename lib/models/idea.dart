import 'dart:core';

class Idea {
  double _timestamp;
  String _title;
  String _description;
  String _url;
  String source = "Reddit";
  int _votes;
  bool _isLast = false;

  Idea(bool isLast) {
    this._isLast = isLast;
  }

  Idea.fromJson(Map<String, dynamic> data) {
    _title = data['title'];
    _description = data['selftext'];
    _timestamp = data['created_utc'];
    _url = data['url'];
    _votes = data['ups'];
  }

  get title => _title;

  get description => _description;

  int get votes => _votes;

  String get url => _url;

  double get timestamp => _timestamp;

  bool get isLast => _isLast;
}
