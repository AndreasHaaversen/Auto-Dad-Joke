import 'package:flutter/material.dart';
import 'joke.dart';
import 'database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Dad Joke',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(title: 'Auto Dad Joke'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Joke> _joke;

  bool _isFavorite = false;

  Future<bool> _checkFavorite(Joke joke) async {
    var favorite = await DBProvider.db.getJoke(joke.id);
    return favorite != null;
  }

  @override
  void initState() {
    super.initState();
    _joke = fetchJoke().then((joke) {
      _checkFavorite(joke).then((result) {
        _isFavorite = result;
      });
    });
    ;
  }

  void _newJoke() {
    setState(() {
      _joke = fetchJoke().then((joke) {
        _checkFavorite(joke).then((result) {
          _isFavorite = result;
        });
      });
    });
  }

  void _handleFavorite(Joke joke) {
    _checkFavorite(joke).then((condition) {
      setState(() {
        if (!condition) {
          DBProvider.db.saveJoke(joke);
          print("Saving");
        } else {
          DBProvider.db.deleteJoke(joke.id);
          print("deleting");
        }
        _isFavorite = !condition;
      });
    });
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
          child: FutureBuilder<Joke>(
            future: _joke,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
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
                        icon: (_isFavorite
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border)),
                        onPressed: () => _handleFavorite(snapshot.data),
                        color: Colors.red,
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return NoConnectionWidget();
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newJoke,
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
