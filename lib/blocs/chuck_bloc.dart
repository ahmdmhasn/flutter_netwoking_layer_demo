import 'dart:async';

import 'package:NetworkingLayerDemo/models/chuck.dart';
import 'package:NetworkingLayerDemo/system/status.dart';
import 'package:NetworkingLayerDemo/repositories/chuck_category_repository.dart';

class ChuckBloc {
  ChuckCategoryRepository _repository;
  StreamController<Status<Chuck>> _controller;
  String _category;

  StreamSink<Status<Chuck>> get sink => _controller.sink;

  Stream<Status<Chuck>> get stream => _controller.stream;

  ChuckBloc(this._category)
      : _repository = ChuckCategoryRepository(),
        _controller = StreamController() {
    fetchData();
  }

  fetchData() async {
    sink.add(Status.loading());
    try {
      final data = await _repository.fetchChuckJoke(_category);
      sink.add(Status.completed(data));
    } catch (error) {
      sink.add(Status.error(error.toString()));
    }
  }

  dispose() {
    _controller.close();
  }
}
