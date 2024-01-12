import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_dad_joke/models/joke.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'database.dart';

enum JokeType { newJoke, refreshJoke }

enum JokeListType { newJokeList, refreshJokeList }

class JokeBloc {
  Stream<Joke> get joke => _jokeSubject.stream;
  final _jokeSubject = BehaviorSubject<Joke>();

  Stream<bool> get isLoadingJoke => _jokeLoadingSubject.stream;
  final _jokeLoadingSubject = BehaviorSubject<bool>();

  Stream<bool> get isNetworkError => _networkErrorSubject.stream;
  final _networkErrorSubject = BehaviorSubject<bool>();

  StreamController<JokeType> _cmdController =
      StreamController<JokeType>.broadcast();
  StreamSink get getJoke => _cmdController.sink;

  StreamController<JokeListType> _listCmdController =
      StreamController<JokeListType>.broadcast();
  StreamSink get getJokeList => _listCmdController.sink;

  Stream<List<Joke>> get jokes => _jokeListSubject.stream;
  final _jokeListSubject = BehaviorSubject<List<Joke>>();

  Stream<bool> get isLoadingJokeList => _jokeListLoadingSubject.stream;
  final _jokeListLoadingSubject = BehaviorSubject<bool>();

  JokeBloc() {
    _updateJoke().then((joke) {
      if (joke != null) _jokeSubject.add(joke);
    });

    _cmdController.stream.listen((value) async {
      if (value == JokeType.newJoke) {
        final joke = await _updateJoke();
        if (joke != null) _jokeSubject.sink.add(joke);
      } else if (value == JokeType.refreshJoke) {
        final currentJoke = _jokeSubject.valueOrNull;
        if (currentJoke != null) {
          final isFavorite = await _checkFavorite(currentJoke);
          currentJoke.isFavorite = isFavorite;
          _jokeSubject.sink.add(currentJoke);
        }
      }
    });

    _listCmdController.stream.listen((value) async {
      if (value == JokeListType.newJokeList) {
        final newList = await _updateJokeList();
        _jokeListSubject.add(newList);
      } else if (value == JokeListType.refreshJokeList) {
        final newList = await _updateJokeList();
        _jokeListSubject.add(newList);
      }
    });
  }

  Future<Joke?> _updateJoke() async {
    _jokeLoadingSubject.add(true);
    _networkErrorSubject.add(false);
    try {
      final response =
          await http.get(Uri.parse('https://icanhazdadjoke.com/'), headers: {
        'Accept': 'application/json',
        'User-Agent':
            'Auto Dad Joke, https://github.com/AndreasHaaversen/Auto-Dad-Joke'
      });
      if (response.statusCode == 200) {
        Joke tmpJoke = Joke.fromJson(json.decode(response.body));
        bool isFavorite = await _checkFavorite(tmpJoke);
        if (isFavorite) {
          tmpJoke.isFavorite = true;
        }
        return tmpJoke;
      }
    } on SocketException catch (_) {
      _networkErrorSubject.add(true);
    }
    _jokeLoadingSubject.add(false);
  }

  Future<List<Joke>> _updateJokeList() async {
    final List<Joke> response = await DBProvider.db.getAllJokes();
    if (response.isNotEmpty) {
      response.forEach((joke) => joke.isFavorite = true);
      return response;
    } else {
      return [];
    }
  }

  dispose() {
    _jokeSubject.close();
    _jokeListSubject.close();
    _cmdController.close();
    _listCmdController.close();
    _jokeLoadingSubject.close();
    _jokeListLoadingSubject.close();
    _networkErrorSubject.close();
  }

  Future<bool> _checkFavorite(Joke joke) async {
    var favorite = await DBProvider.db.getJoke(joke.id);
    return favorite != null;
  }
}

class BlocProvider extends InheritedWidget {
  final JokeBloc bloc;
  final Widget child;

  BlocProvider({required this.bloc, required this.child}) : super(child: child);

  static BlocProvider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<BlocProvider>()
          as BlocProvider);

  @override
  bool updateShouldNotify(BlocProvider oldWidget) {
    return bloc != oldWidget.bloc;
  }
}
