import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'joke.dart';
import 'database.dart';

class JokeBloc {
  Joke _joke;

  List<Joke> _jokeList = [];

  Stream<Joke> get joke => _jokeSubject.stream;
  final _jokeSubject = BehaviorSubject<Joke>();


  StreamController<Joke> _cmdController = StreamController<Joke>.broadcast();
  StreamSink get getJoke => _cmdController.sink;

  Stream<List<Joke>> get jokes => _jokeListSubject.stream;
  final _jokeListSubject = BehaviorSubject<List<Joke>>();


  JokeBloc() {
    _updateJoke().then((_) {
      _jokeSubject.add(_joke);
    });

    _cmdController.stream.listen((_) {
      _updateJoke().then((_){
        _jokeSubject.sink.add(_joke);

      });
    });

    _updateJokeList().then((_) {
      _jokeListSubject.add(_jokeList);
    });


  }

  Future<Null> _updateJoke() async {
    final response = await http.get('https://icanhazdadjoke.com/', headers: {
      'Accept': 'application/json',
      'User-Agent': 'Auto Dad Joke, andreas.h.haaversen@gmail.com'
    }).catchError((onError) => throw Exception(onError));
    if (response.statusCode == 200) {
      Joke tmpJoke = Joke.fromJson(json.decode(response.body));
      bool isFavorite = await _checkFavorite(tmpJoke);
      if (isFavorite) {
        tmpJoke.isFavorite = true;
      }
      _joke = tmpJoke;
    }
  }

  getNewJoke() {
    _updateJoke();
  }

  Future<Null> _updateJokeList() async {
    final List<Joke> response = await DBProvider.db.getAllJokes();
    response.forEach((joke) => joke.isFavorite = true);
    _jokeList = response;
  }

  dispose() {
    _jokeSubject.close();
    _jokeListSubject.close();
    _cmdController.close();
  }

  Future<bool> _checkFavorite(Joke joke) async {
    var favorite = await DBProvider.db.getJoke(joke.id);
    return favorite != null;
  }
}

