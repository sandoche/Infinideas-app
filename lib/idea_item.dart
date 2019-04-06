import 'package:flutter/material.dart';
import 'styles.dart';

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
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: STYLE_TITLES
          ),
          SizedBox(height: 10),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis
          ),
          SizedBox(height: 10),
          Row (
            children: <Widget>[
              Text(date),
              Text(ups)
            ]
          )
        ],
      )
    );
  }
}