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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w900
            )
          ),
          SizedBox(height: 10),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xff65638f)
            )
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