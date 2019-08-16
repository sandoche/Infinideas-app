import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client, Response;
import 'dart:async';

import 'package:infinidea/models/idea.dart';

class TwitterClient {
  Client client = Client();

  Future<List<Idea>> fetch(String searchTerm) async {
    final response = await client.get(
      'https://api.twitter.com/1.1/search/tweets.json?q=$searchTerm',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer AAAAAAAAAAAAAAAAAAAAACai%2FQAAAAAAbeHNIe5ddwL89zeFSjEYlBJvjTo%3DcweXVS3aCi55Klpmy6ie6O7L2bJYHZZGrP4zjNQDPox0r0HzcF"
      },
    );

    if (response.statusCode == 200) {
      List<Idea> ideas = new List();
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
