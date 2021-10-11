import 'dart:async';

import 'package:NetworkingLayerDemo/models/chuck_categories.dart';
import 'package:NetworkingLayerDemo/system/status.dart';
import 'package:NetworkingLayerDemo/repositories/chuck_category_repository.dart';

class ChuckCategoryBloc {
  ChuckCategoryRepository _repository;
  StreamController<Status<ChuckCategories>> _controller;
  ChuckCategories? _fetchedCategories;

  StreamSink<Status<ChuckCategories>> get sink => _controller.sink;

  Stream<Status<ChuckCategories>> get stream => _controller.stream;


  ChuckCategoryBloc()
      : _controller = StreamController<Status<ChuckCategories>>(),
        _repository = ChuckCategoryRepository() {
    fetchCategories();
  }

  fetchCategories() async {

    if (_fetchedCategories == null)
      sink.add(Status.loading());
    try {
      final data = await _repository.fetchCategories();
      _fetchedCategories = data;
      sink.add(Status.completed(data));
    } catch (error) {
      _fetchedCategories = null;
      sink.add(Status.error(error.toString()));
    }
  }

  dispose() {
    _controller.close();
  }
}
