import 'package:flutter/material.dart';
import 'package:infinidea/models/idea.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';
import 'styles.dart';
import 'themes.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'connectivity_check.dart';

class IdeaItem extends StatelessWidget {
  final Idea idea;
  final bool isDarkTheme;

  const IdeaItem({Key key, this.idea, this.isDarkTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        _openWebView(context, idea, isDarkTheme);
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
                Text(idea.source, style: getStyleMeta(isDarkTheme)),
                Text(' • ', style: getStyleMeta(isDarkTheme)),
                Text(timeago.format(new DateTime.fromMillisecondsSinceEpoch(idea.timestamp)), style: getStyleMeta(isDarkTheme)),
              ])
            ],
          )),
    );
  }

  Future<void> _openWebView(BuildContext context, Idea idea, bool isDarkTheme) async {
    var connected = await isConnectionActivated(context);
    if(connected) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return new WebviewScaffold(
              url: idea.url,
              appBar: new AppBar(
                title: new Text(idea.title),
                backgroundColor: getAppBarBackground(isDarkTheme),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share('Hey, I just discovered this cool idea '
                          'thanks to the Infinidea app (https://infinideas.learn.uno) '
                          '💡 ${idea.url}');
                    },
                  )
                ],
              ));
        }),
      );
    } else {
      displayAlertWhenNoConnection(context);
    }    
  }
}