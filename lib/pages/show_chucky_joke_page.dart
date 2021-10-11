import 'package:NetworkingLayerDemo/blocs/chuck_bloc.dart';
import 'package:flutter/material.dart';

class ShowChuckyJoke extends StatefulWidget {
  final String selectedCategory;

  ShowChuckyJoke(this.selectedCategory);

  @override
  State<StatefulWidget> createState() => _ShowChuckyJokeState();
}

class _ShowChuckyJokeState extends State<ShowChuckyJoke> {
  late ChuckBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = ChuckBloc(widget.selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chucky Joke'),
      ),
    );
  }
}
