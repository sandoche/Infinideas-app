import 'package:flutter/material.dart';
import 'package:infinideas/blocs/IdeasBloc.dart';
import 'package:infinideas/models/idea.dart';
import 'idea_item.dart';
import 'styles.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'themes.dart';

class IdeasFeed extends StatefulWidget {
  IdeasFeed({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IdeasFeedState createState() => _IdeasFeedState();
}

class _IdeasFeedState extends State<IdeasFeed> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    bloc.fetch(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.fetch(false);
      }
    });
  }

  Future<Null> _refresh() {
    return bloc.fetch(true);
  }

  bool isDarkTheme() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  void toggleTheme() {
    DynamicTheme.of(context)
        .setThemeData(isDarkTheme() ? lightTheme : darkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Idea>>(
          stream: bloc.ideasStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                  onRefresh: _refresh,
                  child: CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        SliverAppBar(
                            flexibleSpace: FlexibleSpaceBar(
                                centerTitle: false,
                                titlePadding:
                                    const EdgeInsets.only(left: 26, bottom: 40),
                                title: Text('Infinideas', style: getSliverAppBarTitleStyle(isDarkTheme()))),
                            backgroundColor:
                                getSliverAppBarBackground(isDarkTheme()),
                            expandedHeight: 150.0,
                            actions: <Widget>[
                              IconButton(
                                icon: Icon(Icons.brightness_6),
                                color: getMenuIconColor(isDarkTheme()),
                                tooltip: 'Toggle Theme',
                                onPressed: () {
                                  toggleTheme();
                                },
                              ),
                            ]),
                        SliverList(
                            delegate: new SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                          return IdeaItem(
                            isDarkTheme: isDarkTheme(),
                            idea: snapshot.data[index],
                          );
                        }, childCount: snapshot.data.length))
                      ]));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}