import 'package:flutter/material.dart';

class IdeaItem extends StatelessWidget {
  const IdeaItem({
    Key key,
    this.title,
    this.description,
    this.url,
    this.ups,
    this.date
  }) : super(key: key);

  final String title;
  final String description;
  final String url;
  final String ups;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title),
        Text(description),
        Row (
          children: <Widget>[
            Text(date),
            Text(ups)
          ]
        )
      ],
    );
  }
}