import 'package:infinidea/models/idea.dart';
import 'package:infinidea/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class Repository {
  final apiProvider = ApiProvider();

  Observable<List<Idea>> fetchRedditIdeas() => apiProvider.fetchIdeas();
}
