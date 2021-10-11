import 'package:NetworkingLayerDemo/models/chuck_categories.dart';
import 'package:NetworkingLayerDemo/networking/networking_exceptions.dart';
import 'package:NetworkingLayerDemo/repositories/chuck_category_repository.dart';
import 'package:NetworkingLayerDemo/system/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChuckCategoryCubit extends Cubit<Status<ChuckCategories>> {
  ChuckCategoryRepository _repository;

  ChuckCategoryCubit({
    ChuckCategoryRepository? repository,
  })  : this._repository = repository ?? ChuckCategoryRepository(),
        super(Status.initial()) {
    fetchCategories();
  }

  fetchCategories() async {
    final showLoading = state.data?.categories?.isEmpty ?? true;
    if (showLoading) emit(Status.loading());

    try {
      final data = await _repository.fetchCategories();
      if (data.categories.isEmpty) throw EmptyListException();
      emit(Status.completed(data));
    } catch (error) {
      emit(Status.error(error.toString()));
    }
  }
}
