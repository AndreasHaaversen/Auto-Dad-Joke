import 'dart:convert';

class Joke {
  final String id;
  final String joke;
  bool isFavorite;

  Joke({this.id, this.joke, this.isFavorite = false});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(id: json['id'], joke: json['joke'], );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "joke": joke,
      };
}

Joke jokeFromJson(String str) {
  final jsonData = json.decode(str);
  return Joke.fromJson(jsonData);
}

String jokeToJson(Joke data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}



