import 'package:flutter/material.dart';
import 'package:infinideas/blocs/favorite_bloc.dart';
import 'package:infinideas/models/idea.dart';
import 'package:infinideas/idea_item.dart';

class FavoriteScreen extends StatelessWidget {
  final bool isDarkTheme;

  FavoriteScreen({Key key, @required this.isDarkTheme}) : super(key: key);

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
                final reversedFavorites = favorites.reversed.toList();
                final idea = reversedFavorites[index];
                return IdeaItem(
                  idea: idea,
                );
            },
          );
        },
      ),
    );
  }
}