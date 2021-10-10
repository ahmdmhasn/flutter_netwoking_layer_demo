import 'dart:async';

import 'package:NetworkingLayerDemo/models/chuck.dart';
import 'package:NetworkingLayerDemo/networking/response.dart';
import 'package:NetworkingLayerDemo/repositories/chuck_category_repository.dart';

class ChuckBloc {
  ChuckCategoryRepository _repository;
  StreamController<Response<Chuck>> _controller;
  String _category;

  StreamSink<Response<Chuck>> get sink => _controller.sink;

  Stream<Response<Chuck>> get stream => _controller.stream;

  ChuckBloc(this._category)
      : _repository = ChuckCategoryRepository(),
        _controller = StreamController() {
    fetchData();
  }

  fetchData() async {
    sink.add(Response.loading());
    try {
      final data = await _repository.fetchChuckJoke(_category);
      sink.add(Response.completed(data));
    } catch (error) {
      sink.add(Response.error(error.toString()));
    }
  }

  dispose() {
    _controller.close();
  }
}
