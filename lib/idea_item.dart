import 'package:flutter/material.dart';
import 'package:infinidea/models/idea.dart';
import 'styles.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

class IdeaItem extends StatelessWidget {
  final Idea idea;

  const IdeaItem({Key key, this.idea}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openWebView(context, idea);
      },
      child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Chip(
                  label: Text(idea.votes.toString() + ' UPVOTES'),
                  backgroundColor: getLabelBackgroundColor(idea.votes),
                  labelStyle: STYLE_TEXT_TAG),
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
          )),
    );
  }

  void _openWebView(BuildContext context, Idea idea) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return new WebviewScaffold(
            url: idea.url,
            appBar: new AppBar(
              title: new Text(idea.title),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share('Hey, I just discovered this cool repository '
                        'thanks to the Infinidea app (https://infinidea.learn.uno) '
                        '💡 ${idea.url}');
                  },
                )
              ],
            ));
      }),
    );
  }
}
