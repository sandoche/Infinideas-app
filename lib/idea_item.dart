import 'package:flutter/material.dart';
import 'package:infinidea/models/idea.dart';
import 'styles.dart';

class IdeaItem extends StatelessWidget {
  final Idea idea;

  const IdeaItem({Key key, this.idea}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Chip(
                label: Text(idea.votes.toString() + ' UPVOTES'),
                backgroundColor: BACKGROUND_TAG_MEDIUM,
                labelStyle: STYLE_TEXT_TAG
            ),
            Text(idea.title, style: STYLE_TITLES),
            idea.description != ''
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(idea.description,
                        maxLines: 3, overflow: TextOverflow.ellipsis))
                : Container(),
            SizedBox(height: 10),
            Row(children: <Widget>[
              Text(idea.source, style: STYLE_METADATA),
              Text(' • ', style: STYLE_METADATA),
              Text(idea.timestamp.toString(), style: STYLE_METADATA),
            ])
          ],
        ));
  }
}
