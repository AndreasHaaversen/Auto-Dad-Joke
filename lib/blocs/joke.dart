import 'dart:convert';

import 'package:auto_dad_joke/blocs/joke_bloc.dart';
import 'package:flutter/material.dart';

import 'database.dart';

class Joke {
  final String id;
  final String joke;
  bool isFavorite;

  Joke({this.id, this.joke, this.isFavorite = false});

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
}

Joke jokeFromJson(String str) {
  final jsonData = json.decode(str);
  return Joke.fromJson(jsonData);
}

String jokeToJson(Joke data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class JokeWidget extends StatefulWidget {
  final JokeBloc bloc;

  const JokeWidget({Key key, this.bloc}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JokeWidgetState();
}

class _JokeWidgetState extends State<JokeWidget> {
  void _handleFavorite(Joke joke) {
    setState(() {
      if (!joke.isFavorite) {
        DBProvider.db.saveJoke(joke);
        print("Saving");
      } else {
        DBProvider.db.deleteJoke(joke.id);
        print("deleting");
      }
      joke.isFavorite = !joke.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(25.0),
        child: StreamBuilder<Joke>(
          stream: widget.bloc.joke,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    snapshot.data.joke,
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: (snapshot.data.isFavorite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border)),
                    onPressed: () => _handleFavorite(snapshot.data),
                    color: Colors.red,
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return NoConnectionWidget();
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class NoConnectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 60.0,
          child: Container(
            child: Icon(
              Icons.signal_wifi_off,
              size: 50,
            ),
          ),
        ),
        new Text("No Internet Connection", style: TextStyle(fontSize: 20)),
      ],
    );
  }
}
