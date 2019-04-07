import 'package:flutter/material.dart';
import 'package:infinidea/blocs/IdeasBloc.dart';
import 'package:infinidea/models/idea.dart';
import 'idea_item.dart';
import 'styles.dart';
import 'package:flutter/services.dart';

class IdeasFeed extends StatefulWidget {
  IdeasFeed({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IdeasFeedState createState() => _IdeasFeedState();
}

class _IdeasFeedState extends State<IdeasFeed> {
  @override
  void initState() {
    bloc.fetchIdeas();
    _updateStatusBar();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void _updateStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white10,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Idea>>(
          stream: bloc.ideasStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      flexibleSpace: const FlexibleSpaceBar(
                          centerTitle: false,
                          titlePadding: const EdgeInsets.only(left: 26, bottom: 40),
                          title: Text('InfinIdea', style: STYLE_APP_TITLE)
                      ),
                      backgroundColor: Colors.white10,
                      expandedHeight: 150.0,
                    ),
                    SliverList (
                      delegate: new SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return IdeaItem(
                            idea: snapshot.data[index],
                          );
                        },
                        childCount: snapshot.data.length
                      )
                    )
                ]
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
