import 'package:auto_dad_joke/blocs/database.dart';
import 'package:auto_dad_joke/blocs/joke_bloc.dart';
import 'package:auto_dad_joke/models/joke.dart';
import 'package:flutter/material.dart';

import 'animators/fade_in.dart';

class JokeWidget extends StatelessWidget {
  const JokeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(25.0),
        child: StreamBuilder<bool>(
          stream: BlocProvider.of(context).bloc.isNetworkError,
          initialData: false,
          builder: (context, snapshot) {
            return StreamBuilder<bool>(
              stream: BlocProvider.of(context).bloc.isLoadingJoke,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FadeIn(delay: 0, child: JokeWidgetCard());
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class JokeWidgetCard extends StatefulWidget {
  const JokeWidgetCard({
    Key? key,
  }) : super(key: key);

  @override
  _JokeWidgetCardState createState() => _JokeWidgetCardState();
}

class _JokeWidgetCardState extends State<JokeWidgetCard> {
  void _handleFavorite(Joke joke) async {
    if (!joke.isFavorite) {
      await DBProvider.db.saveJoke(joke);
    } else {
      await DBProvider.db.deleteJoke(joke.id);
    }

    setState(() {
      BlocProvider.of(context).bloc.getJoke.add(JokeType.refreshJoke);
      BlocProvider.of(context)
          .bloc
          .getJokeList
          .add(JokeListType.refreshJokeList);
    });

    joke.isFavorite = !joke.isFavorite;

    final snackBar = SnackBar(
      content: joke.isFavorite
          ? Text('Joke added to favorites.')
          : Text('Joke removed from favorites'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Joke>(
      stream: BlocProvider.of(context).bloc.joke,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                snapshot.data!.joke,
              ),
              IconButton(
                icon: snapshot.data!.isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () => _handleFavorite(snapshot.data!),
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
