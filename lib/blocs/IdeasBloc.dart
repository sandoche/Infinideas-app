import 'package:infinidea/models/idea.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class IdeasBloc {
  final _repository = Repository();

  Observable<List<Idea>> get ideasStream => _repository.fetchRedditIdeas();
}

final bloc = IdeasBloc();
