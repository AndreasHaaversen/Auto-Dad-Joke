import 'package:auto_dad_joke/blocs/database.dart';
import 'package:auto_dad_joke/blocs/joke_bloc.dart';
import 'package:auto_dad_joke/models/joke.dart';
import 'package:animated_stream_list/animated_stream_list.dart';

import 'package:flutter/material.dart';

import 'show_up.dart';

class JokeListWidget extends StatefulWidget {
  @override
  _JokeListWidgetState createState() => _JokeListWidgetState();
}

class _JokeListWidgetState extends State<JokeListWidget> {
  void _handleFavorite(Joke handleJoke) {
    setState(() {
      if (!handleJoke.isFavorite) {
        DBProvider.db.saveJoke(handleJoke);
      } else {
        DBProvider.db.deleteJoke(handleJoke.id);
      }
      BlocProvider.of(context).bloc.getJokeList.add(null);
      handleJoke.isFavorite = !handleJoke.isFavorite;
    });

    final snackBar = SnackBar(
      content: handleJoke.isFavorite
          ? Text('Joke added to favorites.')
          : Text('Joke removed from favorites'),
      action: !handleJoke.isFavorite
          ? SnackBarAction(
              label: 'Undo', onPressed: () => _handleFavorite(handleJoke))
          : null,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget _buildStreamList(Stream<List<Joke>> jokeListStream) {
    return AnimatedStreamList(
      streamList: jokeListStream,
      itemBuilder: (Joke joke, int index, BuildContext context,
              Animation<double> animation) =>
          JokeListCard(
              joke: joke,
              favoriteHandler: _handleFavorite,
              animation: animation),
      itemRemovedBuilder: (Joke joke, int index, BuildContext context,
              Animation<double> animation) =>
          JokeListCard(
              joke: joke,
              favoriteHandler: _handleFavorite,
              animation: animation),
      equals: (joke, other) => joke == other,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 5),
          child: StreamBuilder<List<Joke>>(
              stream: BlocProvider.of(context).bloc.jokes,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.isEmpty) {
                  return ShowUp(
                    key: GlobalKey(),
                    delay: 500,
                    child: Text(
                      "There is nothing here yet!\nAdd some favorites first.",
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  return ShowUp(
                    delay: 500,
                    child: Text(
                      "Favorites",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 40),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ),
        Expanded(
          child: Scrollbar(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 5, 25, 25),
                child: _buildStreamList(BlocProvider.of(context).bloc.jokes)),
          ),
        ),
      ],
    );
  }
}

class JokeListCard extends StatefulWidget {
  final Joke joke;
  final Function favoriteHandler;
  final Animation<double> animation;

  const JokeListCard({Key key, this.joke, this.favoriteHandler, this.animation})
      : super(key: key);

  @override
  _JokeListCardState createState() => _JokeListCardState();
}

class _JokeListCardState extends State<JokeListCard> {
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      child: Card(
        margin: EdgeInsets.all(4.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16.0, 5.0, 14.0, 5.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        widget.joke.joke,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
            IconButton(
              icon: (widget.joke.isFavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border)),
              color: Colors.red,
              onPressed: () => widget.favoriteHandler(widget.joke),
            )
          ],
        ),
      ),
    );
  }
}
