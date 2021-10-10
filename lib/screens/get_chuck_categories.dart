import 'package:NetworkingLayerDemo/blocs/chuck_category_bloc.dart';
import 'package:NetworkingLayerDemo/models/chuck_categories.dart';
import 'package:NetworkingLayerDemo/networking/response.dart';
import 'package:NetworkingLayerDemo/widgets/error_widget.dart' as errorWidget;
import 'package:NetworkingLayerDemo/widgets/loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GetChuckCategories extends StatefulWidget {
  const GetChuckCategories({Key? key}) : super(key: key);

  @override
  _GetChuckCategoriesState createState() => _GetChuckCategoriesState();
}

class _GetChuckCategoriesState extends State<GetChuckCategories> {
  late ChuckCategoryBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = ChuckCategoryBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Chucky Categories'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _bloc.fetchCategories(),
        child: StreamBuilder<Response<ChuckCategories>>(
          stream: _bloc.stream,
          builder: (ctx, snapshot) {
            final data = snapshot.data;
            if (data == null) return Container();

            switch (data.status) {
              case Status.LOADING:
                return LoadingWidget(loadingMessage: data.message);
              case Status.COMPLETED:
                return _CategoryListWidget(
                  categoryList: data.data,
                );
              case Status.ERROR:
                return errorWidget.ErrorWidget(
                  errorMessage: data.message,
                  onRetryPressed: _bloc.fetchCategories,
                );
            }
          },
        ),
      ),
    );
  }
}

class _CategoryListWidget extends StatelessWidget {
  final ChuckCategories? categoryList;

  const _CategoryListWidget({
    Key? key,
    this.categoryList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.0,
              vertical: 1.0,
            ),
            child: InkWell(
              onTap: () {
// Navigator.of(ctx).pushNamed('routeName');
                print('object');
              },
              child: SizedBox(
                height: 60,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    categoryList?.categories[index] ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: categoryList?.categories.length,
        // shrinkWrap: true,
        // physics: ClampingScrollPhysics(),
      ),
    );
  }
}
