import 'package:auto_dad_joke/blocs/database.dart';
import 'package:auto_dad_joke/blocs/joke_bloc.dart';
import 'package:auto_dad_joke/models/joke.dart';
import 'package:flutter/material.dart';

class JokeListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(25.0),
        child: StreamBuilder(
          stream: BlocProvider.of(context).bloc.jokes,
          initialData: [],
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return JokeListCard(
                    joke: snapshot.data[index],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Oups, an error has occured!');
            } else {
              return CircularProgressIndicator();
            }
          }),
        ),
      ),
    );
  }
}

class JokeListCard extends StatefulWidget {
  final Joke joke;

  const JokeListCard({Key key, this.joke}) : super(key: key);

  @override
  _JokeListCardState createState() => _JokeListCardState();
}

class _JokeListCardState extends State<JokeListCard> {
  int changedCounter = 0;

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
            onPressed: () => _handleFavorite(widget.joke),
          )
        ],
      ),
    );
  }
}
