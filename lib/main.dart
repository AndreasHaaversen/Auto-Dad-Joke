import 'package:flutter/material.dart';
import 'joke.dart';

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

  @override
  void initState() {
    super.initState();
    this._joke = fetchJoke();
  }

  void _newJoke() {
    setState(() {
      this._joke = fetchJoke();
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
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: FutureBuilder<Joke>(
            future: _joke,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data.joke,
                  style: TextStyle(fontSize: 20),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
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
