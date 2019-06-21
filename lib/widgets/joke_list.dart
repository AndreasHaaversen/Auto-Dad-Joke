import 'package:auto_dad_joke/blocs/database.dart';
import 'package:auto_dad_joke/blocs/joke_bloc.dart';
import 'package:auto_dad_joke/models/joke.dart';
import 'package:flutter/material.dart';

class JokeListWidget extends StatefulWidget {
  @override
  _JokeListWidgetState createState() => _JokeListWidgetState();
}

class _JokeListWidgetState extends State<JokeListWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: StreamBuilder<bool>(
              stream: BlocProvider.of(context).bloc.isLoadingJokeList,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.data) {
                  return StreamBuilder<List<Joke>>(
                    stream: BlocProvider.of(context).bloc.jokes,
                    initialData: [],
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return JokeListCard(
                              joke: snapshot.data[index],
                              favoriteHandler: _handleFavorite,
                            );
                          },
                        );
                      } else {
                        return Text('Oups, an error has occured!');
                      }
                    }),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleFavorite(Joke handleJoke) {
    setState(() {
      if (!handleJoke.isFavorite) {
        DBProvider.db.saveJoke(handleJoke);
        print("Saving");
      } else {
        DBProvider.db.deleteJoke(handleJoke.id);
        print("deleting");
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
}

class JokeListCard extends StatefulWidget {
  final Joke joke;
  final Function favoriteHandler;

  const JokeListCard({Key key, this.joke, this.favoriteHandler})
      : super(key: key);

  @override
  _JokeListCardState createState() => _JokeListCardState();
}

class _JokeListCardState extends State<JokeListCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
