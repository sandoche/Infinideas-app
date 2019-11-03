import 'package:flutter/material.dart';
import 'package:infinideas/blocs/favorite_bloc.dart';
import 'package:infinideas/models/idea.dart';
import 'package:infinideas/idea_item.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final bloc = BlocProvider.of<FavoriteBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: StreamBuilder<List<Idea>>(
        stream: favoritesBloc.favoritesStream,
        // 1
        initialData: favoritesBloc.favorites,
        builder: (context, snapshot) {
          // 2
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
                isDarkTheme: true,
                idea: idea,
              );
            },
          );
        },
      ),
    );
  }
}