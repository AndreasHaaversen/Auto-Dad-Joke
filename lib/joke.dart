import 'package:http/http.dart' as http;
import 'dart:convert';

class Joke {
  final String id;
  final String joke;

  Joke({this.id, this.joke});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      joke: json['joke']
    );
  }
}

Future<Joke> fetchJoke() async {
  final response = await http.get('https://icanhazdadjoke.com/', headers: {'Accept': 'application/json', 'User-Agent': 'Auto Dad Joke, andreas.h.haaversen@gmail.com'});
  if (response.statusCode == 200) {
    return Joke.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load joke');
  }
}