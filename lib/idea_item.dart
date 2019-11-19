import 'package:flutter/material.dart';
import 'package:infinideas/models/dark_theme_handler.dart';
import 'package:infinideas/models/idea.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:infinideas/models/ideas_db.dart';
import 'package:share/share.dart';
import 'styles.dart';
import 'themes.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'connectivity_check.dart';

class IdeaItem extends StatefulWidget {

  IdeaItem({Key key, this.idea, this.onFavoriteToggle}) : super(key: key);
  final Idea idea;
  final void Function(bool) onFavoriteToggle;

  @override
  _IdeaItemState createState() => _IdeaItemState(this.idea, this.onFavoriteToggle);
}

class _IdeaItemState extends State<IdeaItem> {

  _IdeaItemState(this.idea, this.onFavoriteToggle);

  final Idea idea;
  final void Function(bool) onFavoriteToggle;
  DarkTheme darkTheme;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    darkTheme = DarkTheme(context);
    favoriteInitialState(idea);
  }

  Future <void> favoriteInitialState(Idea idea) async {
    bool ideaExists = await IdeasDB.db.existIdeaWithUrl(idea.url); //avoritesBloc.ideaAlreadyExists(idea);
    setState(() {
      isFavorite = ideaExists;
    });
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        _openWebView(context, idea, darkTheme.isDarkTheme());
      },
      child: Padding(
          padding: const EdgeInsets.only(left: 18, top: 28, right: 28, bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
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
                      SizedBox(height: 10)
                    ]),
              ),
              Row(children: <Widget>[
                IconButton(
                  icon: getIconForIdea(),
                  color: getMenuIconColor(darkTheme.isDarkTheme()),
                  tooltip: 'Favorite',
                  alignment: Alignment.centerLeft,
                  onPressed: () {
                    toggleFavoriteIcon(idea);
                  },),
                Text(idea.source, style: getStyleMeta(darkTheme.isDarkTheme())),
                Text(' • ', style: getStyleMeta(darkTheme.isDarkTheme())),
                Text(timeago.format(new DateTime.fromMillisecondsSinceEpoch(idea.timestamp)), style: getStyleMeta(darkTheme.isDarkTheme())),
              ])
            ],
          )),
    );
  }

  Icon getIconForIdea() {
    if (isFavorite) {
      return Icon(Icons.favorite);
    }
    return Icon(Icons.favorite_border);
  }

  void toggleFavoriteIcon(Idea idea) {
    setState(() {
      this.isFavorite = !this.isFavorite;
    });
    this.onFavoriteToggle(this.isFavorite);
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
                          'thanks to the Infinideas app (https://infinideas.learn.uno) '
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


