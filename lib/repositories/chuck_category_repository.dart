import 'package:NetworkingLayerDemo/models/chuck.dart';
import 'package:NetworkingLayerDemo/models/chuck_categories.dart';
import 'package:NetworkingLayerDemo/networking/api_provider.dart';
import 'package:NetworkingLayerDemo/networking/request_type.dart';
import 'package:NetworkingLayerDemo/system/constants.dart';

class ChuckCategoryRepository {
  ApiProvider provider = ApiProvider(baseUrl: Constants.baseUrl);

  Future<ChuckCategories> fetchCategories() async {
    final json = await provider.request(
        requestType: RequestType.GET, path: 'jokes/categories');
    return ChuckCategories.fromJson(json);
  }

  Future<Chuck> fetchChuckJoke(String category) async {
    final json = await provider.request(
        requestType: RequestType.GET, path: 'jokes/random?category=$category');
    return Chuck.fromJson(json);
  }
}
