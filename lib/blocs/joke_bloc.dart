import 'dart:async';
import 'dart:convert';

import 'package:auto_dad_joke/models/joke.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'database.dart';

class JokeBloc {
  Joke _joke;

  List<Joke> _jokeList = [];

  Stream<Joke> get joke => _jokeSubject.stream;
  final _jokeSubject = BehaviorSubject<Joke>();

  StreamController<Joke> _cmdController = StreamController<Joke>.broadcast();
  StreamSink get getJoke => _cmdController.sink;

  StreamController<Joke> _listCmdController = StreamController<Joke>.broadcast();
  StreamSink get getJokeList => _listCmdController.sink;

  Stream<List<Joke>> get jokes => _jokeListSubject.stream;
  final _jokeListSubject = BehaviorSubject<List<Joke>>();

  JokeBloc() {
    _updateJoke().then((_) {
      _jokeSubject.add(_joke);
    });

    _cmdController.stream.listen((_) {
      _updateJoke().then((_) {
        _jokeSubject.sink.add(_joke);
      });
    });

    _listCmdController.stream.listen((_) {
       _updateJokeList().then((_) {
          _jokeListSubject.add(_jokeList);
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

  Future<Null> _updateJokeList() async {
    final List<Joke> response = await DBProvider.db.getAllJokes();
    if (response != null) {
        response.forEach((joke) => joke.isFavorite = true);
        _jokeList = response;
    } else {
      _jokeList = [];
    }
  }

  dispose() {
    _jokeSubject.close();
    _jokeListSubject.close();
    _cmdController.close();
    _listCmdController.close();
  }

  Future<bool> _checkFavorite(Joke joke) async {
    var favorite = await DBProvider.db.getJoke(joke.id);
    return favorite != null;
  }
}

class BlocProvider extends InheritedWidget {
  final JokeBloc bloc;
  final Widget child;

  BlocProvider({this.bloc, this.child}) : super(child: child);

  static BlocProvider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider);

  @override
  bool updateShouldNotify(BlocProvider oldWidget) {
    return bloc != oldWidget.bloc;
  }
}
