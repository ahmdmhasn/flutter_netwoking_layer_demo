import 'dart:async';

import 'package:NetworkingLayerDemo/models/chuck_categories.dart';
import 'package:NetworkingLayerDemo/networking/response.dart';
import 'package:NetworkingLayerDemo/repositories/chuck_category_repository.dart';

class ChuckCategoryBloc {
  ChuckCategoryRepository _repository;
  StreamController<Response<ChuckCategories>> _controller;

  StreamSink<Response<ChuckCategories>> get sink => _controller.sink;

  Stream<Response<ChuckCategories>> get stream => _controller.stream;

  ChuckCategoryBloc()
      : _controller = StreamController<Response<ChuckCategories>>(),
        _repository = ChuckCategoryRepository() {
    fetchCategories();
  }

  fetchCategories() async {
    sink.add(Response.loading());
    try {
      final data = await _repository.fetchCategories();
      sink.add(Response.completed(data));
    } catch (error) {
      sink.add(Response.error(error.toString()));
    }
  }

  dispose() {
    _controller.close();
  }
}
