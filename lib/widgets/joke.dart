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
      } else {
        DBProvider.db.deleteJoke(joke.id);
      }
      BlocProvider.of(context).bloc.getJokeList.add(null);
      joke.isFavorite = !joke.isFavorite;
    });

    final snackBar = SnackBar(
      content: joke.isFavorite
          ? Text('Joke added to favorites.')
          : Text('Joke removed from favorites'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(25.0),
        child: StreamBuilder<bool>(
          stream: BlocProvider.of(context).bloc.isNetworkError,
          initialData: false,
          builder: (context, snapshot) {
            if (!snapshot.data) {
              return StreamBuilder<bool>(
                stream: BlocProvider.of(context).bloc.isLoadingJoke,
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.data) {
                    return StreamBuilder<Joke>(
                      stream: BlocProvider.of(context).bloc.joke,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                snapshot.data.joke,
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
                          return Text(
                              'Oups! Something has gone terribly wrong. Please try again later.');
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            } else {
              return NoConnectionWidget();
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
        new Text("No Internet Connection"),
      ],
    );
  }
}
