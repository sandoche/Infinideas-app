import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'dart:async';

import 'package:infinidea/models/idea.dart';

class ApiProvider {
  Client client = Client();

  Future<List<Idea>> fetchIdeas() async {
    final response = await client
        .get("https://www.reddit.com/r/lightbulb/new.json?sort=new");
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
