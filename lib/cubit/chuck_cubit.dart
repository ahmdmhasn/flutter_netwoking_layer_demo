import 'package:NetworkingLayerDemo/models/chuck.dart';
import 'package:NetworkingLayerDemo/repositories/chuck_category_repository.dart';
import 'package:NetworkingLayerDemo/system/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChuckCubit extends Cubit<Status<Chuck>> {
  ChuckCategoryRepository _repository;
  String _category;

  ChuckCubit({
    required String category,
    ChuckCategoryRepository? repository,
  })  : this._category = category,
        this._repository = repository ?? ChuckCategoryRepository(),
        super(Status.initial()) {
    fetchData();
  }

  fetchData() async {
    emit(Status.loading());
    try {
      final data = await _repository.fetchChuckJoke(_category);
      emit(Status.completed(data));
    } catch (error) {
      emit(Status.error(error.toString()));
    }
  }
}
