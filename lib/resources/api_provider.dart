import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'dart:async';

import 'package:infinidea/models/idea.dart';
import 'package:rxdart/rxdart.dart';

class ApiProvider {
  Client client = Client();

  Observable<List<Idea>> fetchIdeas() {
    return Observable.combineLatest2(
      _fetchNewLightbulb().asStream(),
      _fetchNewAppIdeas().asStream(),
          (List<Idea> listA, List<Idea> listB) {
        List<Idea> merged = new List();
        merged.addAll(listA);
        merged.addAll(listB);
        merged.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        return merged;
      },
    );
  }

  Future<List<Idea>> _fetchNewLightbulb() async {
    return await _fetch('https://www.reddit.com/r/lightbulb/new.json?sort=new');
  }

  Future<List<Idea>> _fetchNewAppIdeas() async {
    return await _fetch('https://www.reddit.com/r/AppIdeas/new.json?sort=new');
  }

  Future<List<Idea>> _fetch(String url) async {
    final response = await client.get(url);
    if (response.statusCode == 200) {
      List<Idea> ideas = new List();
      json.decode(response.body)['data']['children'].forEach((item) {
        ideas.add(Idea.fromJson(item['data']));
      });
      return ideas;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
