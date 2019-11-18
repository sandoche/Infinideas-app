import 'package:flutter/material.dart';
import 'package:infinideas/models/idea.dart';
import 'package:infinideas/idea_item.dart';
import 'package:infinideas/models/ideas_db.dart';

class FavoritesList extends StatefulWidget {
  FavoritesList({Key key}) : super(key: key);

  @override
  _FavoritesListState createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {

  List<Idea> _favorites = [];

  @override
  void initState() {
    super.initState();
    favoritesInitialState();
  }

  Future <void> favoritesInitialState() async {
    List<Idea> ideas = await IdeasDB.db.ideas();
    setState(() {
      _favorites = ideas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Favorites')),
        body: Center(
          child: ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              final idea = _favorites[index];
              return IdeaItem(
                key: ValueKey(idea.url),
                idea: idea,
                onFavoriteToggle: (favorited) => deleteFromFavorites(idea, index),
              );
            },
          ),
        )
    );
  }

  void deleteFromFavorites(Idea idea, int index) async {
    try {
      await IdeasDB.db.deleteIdea(idea.url);
      setState(() {
        this._favorites.removeAt(index);
      });
    } catch (_) {
      print('ERROR');
    }
  }
}