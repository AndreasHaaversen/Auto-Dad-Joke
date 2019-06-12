import 'package:auto_dad_joke/blocs/joke_bloc.dart';
import 'package:flutter/material.dart';
import 'blocs/joke.dart';
import 'blocs/database.dart';

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
      body: JokeWidget(bloc: widget.bloc,),
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

