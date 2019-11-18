import 'package:flutter/material.dart';
import 'package:infinideas/blocs/favorite_bloc.dart';
import 'package:infinideas/models/idea.dart';
import 'package:infinideas/idea_item.dart';




class FavoritesList extends StatefulWidget {
  final bool isDarkTheme;
  FavoritesList({Key key, @required this.isDarkTheme}) : super(key: key);

  @override
  _FavoritesListState createState() => _FavoritesListState(this.isDarkTheme);
}

class _FavoritesListState extends State<FavoritesList> {

  final bool isDarkTheme;
  _FavoritesListState(this.isDarkTheme);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Favorites')),
      body: StreamBuilder<List<Idea>>(
        stream: favoritesBloc.favoritesStream,
        initialData: favoritesBloc.favorites,
        builder: (context, snapshot) {
          List<Idea> favorites =
          (snapshot.connectionState == ConnectionState.waiting)
              ? favoritesBloc.favorites
              : snapshot.data;

          if (favorites == null || favorites.isEmpty) {
            return Center(child: Text('No Favorites'));
          }

          return ListView.builder (
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final idea = favorites[index];
              return IdeaItem(
                idea: idea,
                onFavoriteToggle: () => deleteFromFavorites(idea),
              );
            },
          );
        },
      ),
    );
  }

  void deleteFromFavorites(Idea idea) {
    print("PRINTING THIIIIIS!");
    setState(() {
      favoritesBloc.toggleIdea(idea);
    });
  }
}


//class FavoriteScreen extends StatelessWidget {
//  final bool isDarkTheme;
//
//  FavoriteScreen({Key key, @required this.isDarkTheme}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//          title: Text('Favorites')),
//      body: StreamBuilder<List<Idea>>(
//        stream: favoritesBloc.favoritesStream,
//        initialData: favoritesBloc.favorites,
//        builder: (context, snapshot) {
//          List<Idea> favorites =
//          (snapshot.connectionState == ConnectionState.waiting)
//              ? favoritesBloc.favorites
//              : snapshot.data;
//
//          if (favorites == null || favorites.isEmpty) {
//            return Center(child: Text('No Favorites'));
//          }
//
//          return ListView.builder (
//              itemCount: favorites.length,
//              itemBuilder: (context, index) {
//                final idea = favorites[index];
//                return IdeaItem(
//                  idea: idea,
//                  onDelete: ,
//                );
//            },
//          );
//        },
//      ),
//    );
//  }
//
//  void toggleFavoriteIcon(Idea idea) {
//    favoritesBloc.toggleIdea(idea);
//    setState(() {
//
//    });
//  }
//}