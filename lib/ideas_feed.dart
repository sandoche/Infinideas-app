import 'package:flutter/material.dart';
import 'idea_item.dart';

class IdeasFeed extends StatefulWidget {
  IdeasFeed({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IdeasFeedState createState() => _IdeasFeedState();
}

class _IdeasFeedState extends State<IdeasFeed> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.16),
        children: <Widget>[
          new IdeaItem(title: "Super title", description: "Super description", url: "https://google.com", ups: "15", date: "1 day ago"),
          new IdeaItem(title: "Super title 2", description: "Super description A", url: "https://google.com", ups: "2", date: "2 day ago"),
          new IdeaItem(title: "Super title 3", description: "Super description C", url: "https://google.com", ups: "5", date: "3 day ago")
        ],
      ),
    );
  }
}
