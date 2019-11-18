import 'dart:async';
import 'package:infinideas/models/idea.dart';
import 'package:infinideas/models/ideas_db.dart';

abstract class Bloc {
  void dispose();
}

class FavoriteBloc implements Bloc {
  var _ideas = <Idea>[];
  IdeasDB ideas_db = IdeasDB.db;
  List<Idea> get favorites => _ideas;

  final _controller = StreamController<List<Idea>>.broadcast();
  Stream<List<Idea>> get favoritesStream => _controller.stream;

  FavoriteBloc() {
    getIdeas();
  }

  void getIdeas() async {
    List<Idea> ideas = await ideas_db.ideas();
    _ideas = ideas;
  }

  void toggleIdea(Idea idea) {
    var urls = _ideas.map((idea) => idea.url).toList();
    if (urls.contains(idea.url)) {
      _ideas.removeWhere((item) => item.url == idea.url);
      ideas_db.deleteIdea(idea.url);
    } else {
      _ideas.add(idea);
      ideas_db.insertIdea(idea);
    }
    _controller.sink.add(_ideas);
  }

  Future<bool> ideaAlreadyExists(Idea idea) async {
    await getIdeas();
    var urls = _ideas.map((idea) => idea.url).toList();
    return urls.contains(idea.url);
  }

  @override
  void dispose() {
    _controller.close();
  }
}

final favoritesBloc = FavoriteBloc();
