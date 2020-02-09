import 'package:infinideas/models/idea.dart';
import 'package:infinideas/resources/api_provider.dart';
import 'package:infinideas/resources/twitter_client.dart';
import 'dart:async';

import 'package:rxdart/rxdart.dart';

class IdeasBloc {
  final _apiProvider = ApiProvider();
  final _twitterClient = TwitterClient();
  List<Idea> listIdeas = List();

  PublishSubject<List<Idea>> publishSubject = PublishSubject();

  Observable<List<Idea>> get ideasStream => publishSubject.stream;

  Future<bool> fetch(bool refresh) async {
    if (refresh) {
      listIdeas.clear();
    }
    return Observable.combineLatest4(
        _apiProvider.fetchNewLightbulb(refresh).asStream(),
        _apiProvider.fetchNewAppIdeas(refresh).asStream(),
        _apiProvider.fetchNewStartupIdeas(refresh).asStream(),
        _twitterClient.fetch(refresh).asStream(), (List<Idea> listA,
            List<Idea> listB, List<Idea> listC, List<Idea> listD) {
      List<Idea> merged = new List();
      merged.addAll(listA);
      merged.addAll(listB);
      merged.addAll(listC);
      merged.addAll(listD);
      merged.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      merged.add(Idea(true));
      return merged;
    }).listen((List<Idea> list) {
      listIdeas.addAll(list);
      publishSubject.sink.add(listIdeas);
    }).asFuture(true);
  }
}

final bloc = IdeasBloc();