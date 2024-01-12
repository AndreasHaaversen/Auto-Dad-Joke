import 'dart:convert';

class Joke implements Comparable<Joke> {
  final String id;
  final String joke;
  bool isFavorite;

  Joke({required this.id, required this.joke, this.isFavorite = false});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      joke: json['joke'],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "joke": joke,
      };

  @override
  int compareTo(Joke other) {
    return this.id.compareTo(other.id);
  }

  @override
  bool operator ==(other) => other is Joke && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

Joke jokeFromJson(String str) {
  final jsonData = json.decode(str);
  return Joke.fromJson(jsonData);
}

String jokeToJson(Joke data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
