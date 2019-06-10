import 'package:flutter/material.dart';
import 'joke.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Joke>(
          future: _joke,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.joke);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newJoke,
        tooltip: 'New joke',
        child: Icon(Icons.text_fields),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
