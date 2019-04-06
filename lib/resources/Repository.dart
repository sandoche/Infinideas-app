import 'dart:async';

import 'package:infinidea/models/idea.dart';
import 'package:infinidea/resources/api_provider.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<List<Idea>> fetchIdeas() => apiProvider.fetchIdeas();
}