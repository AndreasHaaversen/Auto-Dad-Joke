import 'package:auto_dad_joke/blocs/database.dart';
import 'package:auto_dad_joke/blocs/joke_bloc.dart';
import 'package:auto_dad_joke/models/joke.dart';
import 'package:flutter/material.dart';

class JokeWidget extends StatefulWidget {
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
      BlocProvider.of(context).bloc.getJokeList.add(null);
      joke.isFavorite = !joke.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(25.0),
        child: StreamBuilder<Joke>(
          stream: BlocProvider.of(context).bloc.joke,
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
