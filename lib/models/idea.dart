import 'dart:core';
import 'package:intl/intl.dart';

class Idea {
  int _timestamp;
  String _title;
  String _description;
  String _url;
  String _source;
  int _votes;
  bool _isLast = false;

  Idea.fromDB(this._url, this._title, this._description, this._source, this._votes, this._timestamp);

  Idea(bool isLast) {
    this._isLast = isLast;
  }

  get title => _title;
  get description => _description;
  int get votes => _votes;
  String get url => _url;
  int get timestamp => _timestamp;
  bool get isLast => _isLast;
  String get source => _source;


  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'title': title,
      'description': description,
      'source' : source,
      'votes': votes,
      'timestamp': timestamp
    };
  }

  @override
  String toString() {
    return 'Idea{url: $url, title: $title, description: $description, source: $source, votes: $votes}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Idea && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;
}

class RedditIdea extends Idea {
  RedditIdea.fromJson(Map<String, dynamic> data) : super(false) {
    _title = data['title'];
    _description = data['selftext'];
    _timestamp = data['created_utc'].toInt() * 1000;
    _url = data['url'];
    _votes = data['ups'];
    _source = "Reddit";
  }
}

class TwitterIdea extends Idea {
  TwitterIdea.fromJson(Map<String, dynamic> data) : super(false) {
    _title = data['text'];
    _description = "";
    DateFormat format = new DateFormat("EEE MMM dd HH:mm:ss yyyy");
    var date = data['created_at'].split(' ');
    date.removeAt(4);
    DateTime time = format.parse(date.join(' '));
    _timestamp = time.millisecondsSinceEpoch;
    _url =
        "https://twitter.com/${data['user']['screen_name']}/status/${data['id_str']}";
    _votes = data['favorite_count'] + data['retweet_count'];
    _source = "Twitter";
  }
}
