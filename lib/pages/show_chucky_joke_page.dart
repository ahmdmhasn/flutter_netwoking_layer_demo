import 'package:NetworkingLayerDemo/cubit/chuck_cubit.dart';
import 'package:NetworkingLayerDemo/models/chuck.dart';
import 'package:NetworkingLayerDemo/styles/assets.dart';
import 'package:NetworkingLayerDemo/system/status.dart';
import 'package:NetworkingLayerDemo/widgets/error_widget.dart' as errorWidget;
import 'package:NetworkingLayerDemo/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowChuckyJoke extends StatefulWidget {
  final String selectedCategory;

  ShowChuckyJoke(this.selectedCategory);

  @override
  State<StatefulWidget> createState() => _ShowChuckyJokeState();
}

class _ShowChuckyJokeState extends State<ShowChuckyJoke> {
  late ChuckCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChuckCubit(category: widget.selectedCategory);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chucky Joke'),
      ),
      body: BlocBuilder<ChuckCubit, Status<Chuck>>(
        bloc: _cubit,
        builder: (ctx, state) {
          switch (state.status) {
            case StatusType.LOADING:
              return LoadingWidget();
            case StatusType.COMPLETED:
              return _ChuckJokeWidget(state.data);
            case StatusType.ERROR:
              return errorWidget.ErrorWidget(
                errorMessage: state.message,
                onRetryPressed: () => _cubit.fetchData(),
              );
          }
        },
      ),
    );
  }
}

class _ChuckJokeWidget extends StatelessWidget {
  final Chuck? chuck;

  _ChuckJokeWidget(this.chuck);

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints.expand(),
      child: Stack(
        children: [
          _getBackground(),
          _getGradient(context),
          _getContent(context),
        ],
      ),
    );
  }

  Container _getBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _getGradient(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x00736AB7), Color(0xFF333333)],
          stops: [0.0, 1.0],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Widget _getContent(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        // height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 10,
            children: [
              Container(
                child: Image.network(
                  chuck?.iconUrl ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                chuck?.value ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
