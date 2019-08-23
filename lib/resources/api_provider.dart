import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'dart:async';

import 'package:infinideas/models/idea.dart';
import 'package:rxdart/rxdart.dart';

class ApiProvider {
  Client client = Client();
  String lightBulbAfter;
  String newIdeaAfter;

  Future<List<Idea>> fetchNewLightbulb(bool refresh) async {
    String url =
        'https://www.reddit.com/r/lightbulb/new.json?sort=new&count=25&after=';
    if (lightBulbAfter != null && !refresh) url += lightBulbAfter;
    final response = await client.get(url);
    if (response.statusCode == 200) {
      List<Idea> ideas = new List();
      Map<String, dynamic> data = json.decode(response.body)['data'];
      lightBulbAfter = data['after'];
      data['children'].forEach((item) {
        ideas.add(RedditIdea.fromJson(item['data']));
      });
      return ideas;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<Idea>> fetchNewAppIdeas(bool refresh) async {
    String url =
        'https://www.reddit.com/r/AppIdeas/new.json?sort=new&count=25&after=';
    if (newIdeaAfter != null && !refresh) url += newIdeaAfter;
    final response = await client.get(url);
    if (response.statusCode == 200) {
      List<Idea> ideas = new List();
      Map<String, dynamic> data = json.decode(response.body)['data'];
      newIdeaAfter = data['after'];
      data['children'].forEach((item) {
        ideas.add(RedditIdea.fromJson(item['data']));
      });
      return ideas;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<Idea>> fetchNewStartupIdeas(bool refresh) async {
    String url =
        'https://www.reddit.com/r/Startup_ideas/new.json?sort=new&count=25&after=';
    if (newIdeaAfter != null && !refresh) url += newIdeaAfter;
    final response = await client.get(url);
    if (response.statusCode == 200) {
      List<Idea> ideas = new List();
      Map<String, dynamic> data = json.decode(response.body)['data'];
      newIdeaAfter = data['after'];
      data['children'].forEach((item) {
        ideas.add(RedditIdea.fromJson(item['data']));
      });
      return ideas;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
