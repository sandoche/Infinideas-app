import 'package:infinideas/models/idea.dart';
import 'package:infinideas/resources/api_provider.dart';

import 'package:rxdart/rxdart.dart';

class IdeasBloc {
  final _apiProvider = ApiProvider();
  List<Idea> listIdeas = List();

  PublishSubject<List<Idea>> publishSubject = PublishSubject();

  Observable<List<Idea>> get ideasStream => publishSubject.stream;

  Future<Null> fetch(bool refresh) {
    if (refresh) {
      listIdeas.clear();
    }
    return Observable.combineLatest2(
        _apiProvider.fetchNewLightbulb(refresh).asStream(),
        _apiProvider.fetchNewAppIdeas(refresh).asStream(),
        (List<Idea> listA, List<Idea> listB) {
      List<Idea> merged = new List();
      merged.addAll(listA);
      merged.addAll(listB);
      merged.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return merged;
    }).listen((List<Idea> list) {
      listIdeas.addAll(list);
      publishSubject.sink.add(listIdeas);
    }).asFuture();
  }
}

final bloc = IdeasBloc();
