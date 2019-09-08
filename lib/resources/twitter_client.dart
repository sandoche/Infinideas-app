import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client, Response;
import 'dart:async';

import 'package:infinideas/models/idea.dart';

class TwitterClient {
  Client client = Client();
  String nextResults;
  bool noMoreResults = false;

  Future<List<Idea>> fetch(bool refresh) async {
    if (noMoreResults && !refresh) {
      return new List();
    }
    noMoreResults = false;
    String url = 'https://api.twitter.com/1.1/search/tweets.json';
    if (nextResults != null && !refresh) {
      url += nextResults;
    } else {
      url += "?q=from%3Astartupideabot+OR+from%3Ahotteststartups+OR+from%3Afiveideasaday&result_type=recent&count=50";
    }
    final response = await client.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer AAAAAAAAAAAAAAAAAAAAACai%2FQAAAAAAbeHNIe5ddwL89zeFSjEYlBJvjTo%3DcweXVS3aCi55Klpmy6ie6O7L2bJYHZZGrP4zjNQDPox0r0HzcF"
      },
    );

    if (response.statusCode == 200) {
      List<Idea> ideas = new List();
      nextResults =
          json.decode(response.body)['search_metadata']['next_results'];
      if (nextResults == null) {
        noMoreResults = true;
      }
      List<dynamic> data = json.decode(response.body)['statuses'];
      data.forEach((item) {
        ideas.add(TwitterIdea.fromJson(item));
      });
      return ideas;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
