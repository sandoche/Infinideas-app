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
        children: <Widget>[
          new IdeaItem(title: "We need a TV series with re-enacted Florida Man stories", description: "Each episode could have a re-enactment of the events with live actors. I imagine the production quality would be pretty close the “1000 ways to die” where things are presented in a semi-humorous or outrageous way.", url: "https://google.com", ups: "15", date: "1 day ago", source: "Reddit"),
          new IdeaItem(title: "Closed captions for horror movies should be hard to read when indicating a quiet noise.", url: "https://google.com", ups: "2", date: "2 day ago", source: "Reddit"),
          new IdeaItem(title: "There should be an app that identifies the species of plants and/or animals in a given picture.", description: "Currently its possible to do this manually be hiding each post, but thats not convenient and a lot of clicking when viewing as a Website on PC or Mobile.", url: "https://google.com", ups: "5", date: "3 day ago", source: "Reddit")
        ],
      ),
    );
  }
}
