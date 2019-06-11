import 'package:auto_dad_joke/blocs/joke_bloc.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'blocs/joke.dart';
import 'blocs/database.dart';
=======
import 'joke.dart';
import 'database.dart';
>>>>>>> e23391c4b03a5a45b2e712689631bff8765b14cc

void main() {
  final jokeBloc = JokeBloc();
  runApp(MyApp(bloc: jokeBloc));
  }

class MyApp extends StatelessWidget {
  final JokeBloc bloc;

  MyApp({
    Key key,
    this.bloc
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Dad Joke',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(title: 'Auto Dad Joke', bloc: this.bloc ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);

  final String title;
  final JokeBloc bloc;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

<<<<<<< HEAD
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
=======
  bool _isFavorite = false;

  Future<bool> _checkFavorite(Joke joke) async {
    var favorite = await DBProvider.db.getJoke(joke.id);
    return favorite != null;
  }

  Future<bool> _checkFutureFavorite(Future<Joke> joke) async {
    var localJoke = await joke;
    var favorite = await DBProvider.db.getJoke(localJoke.id);
    return favorite != null;
  }

  @override
  void initState() {
    super.initState();
    _joke = fetchJoke();
  }

  void _newJoke() {
    setState(() {
      _joke = fetchJoke();
      _checkFutureFavorite(_joke).then((result) {
        _isFavorite = result;
      });
    });
  }

  void _handleFavorite(Joke joke) {
    bool condition;
    _checkFavorite(joke).then((result) {
      condition = result;
      setState(() {
        if (condition) {
          DBProvider.db.saveJoke(joke);
          print("Saving");
        } else {
          DBProvider.db.deleteJoke(joke.id);
          print("deleting");
        }
      });
    });
>>>>>>> e23391c4b03a5a45b2e712689631bff8765b14cc
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        leading: Padding(
          padding: EdgeInsets.all(10.0),
          child: Image.asset('assets/smiley.png', fit: BoxFit.contain),
        ),
      ),
      body: Center(
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
<<<<<<< HEAD
                        icon: (snapshot.data.isFavorite
=======
                        icon: (_isFavorite
>>>>>>> e23391c4b03a5a45b2e712689631bff8765b14cc
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => widget.bloc.getJoke.add(null),
        tooltip: 'New joke',
        icon: Icon(
          Icons.insert_emoticon,
          color: Colors.white,
        ),
        label: Text(
          'New joke',
          style: TextStyle(color: Colors.white),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
