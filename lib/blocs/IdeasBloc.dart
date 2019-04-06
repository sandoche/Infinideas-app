import 'package:infinidea/models/idea.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class IdeasBloc {
  final _repository = Repository();
  final _ideasSubject = PublishSubject<List<Idea>>();

  Observable<List<Idea>> get ideas => _ideasSubject.stream;

  fetchIdeas() async {
    List<Idea> ideas = await _repository.fetchIdeas();
    _ideasSubject.sink.add(ideas);
  }

  dispose() {
    _ideasSubject.close();
  }
}

final bloc = IdeasBloc();
