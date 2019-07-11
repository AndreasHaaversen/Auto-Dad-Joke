import 'package:auto_dad_joke/blocs/joke_bloc.dart';
import 'package:auto_dad_joke/widgets/joke.dart';
import 'package:auto_dad_joke/widgets/joke_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(AutoDadJoke());

class AutoDadJoke extends StatelessWidget {
  AutoDadJoke({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: JokeBloc(),
      child: MaterialApp(
        title: 'Auto Dad Joke',
        theme: ThemeData(
            primarySwatch: Colors.amber,
            fontFamily: 'Roboto',
            textTheme: TextTheme(body1: TextStyle(fontSize: 20))),
        home: MyHomePage(title: 'Auto Dad Joke'),
      ),
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
  int _currentIndex = 0;

  final List<Widget> _children = [JokeWidget(), JokeListWidget()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              title: Text('Joke'), icon: Icon(Icons.insert_emoticon)),
          BottomNavigationBarItem(
              title: Text('Favorite jokes'), icon: Icon(Icons.list))
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 0) {
              BlocProvider.of(context).bloc.getJoke.add(JokeType.refreshJoke);
            }
          });
        },
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () =>
                  BlocProvider.of(context).bloc.getJoke.add(JokeType.newJoke),
              tooltip: 'New joke',
              icon: Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              label: Text(
                'New joke',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
