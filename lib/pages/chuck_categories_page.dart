import 'package:NetworkingLayerDemo/cubit/chuck_category_cubit.dart';
import 'package:NetworkingLayerDemo/models/chuck_categories.dart';
import 'package:NetworkingLayerDemo/pages/show_chucky_joke_page.dart';
import 'package:NetworkingLayerDemo/system/status.dart';
import 'package:NetworkingLayerDemo/widgets/error_widget.dart' as errorWidget;
import 'package:NetworkingLayerDemo/widgets/loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChuckCategoriesPage extends StatefulWidget {
  const ChuckCategoriesPage({Key? key}) : super(key: key);

  @override
  _ChuckCategoriesPageState createState() => _ChuckCategoriesPageState();
}

class _ChuckCategoriesPageState extends State<ChuckCategoriesPage> {
  late ChuckCategoryCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = ChuckCategoryCubit();
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
        elevation: 0,
        title: Text('Chucky Categories'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _cubit.fetchCategories(),
        child: BlocBuilder<ChuckCategoryCubit, Status<ChuckCategories>>(
          bloc: _cubit,
          builder: (ctx, state) {
            switch (state.status) {
              case StatusType.LOADING:
                return LoadingWidget(loadingMessage: state.message);
              case StatusType.COMPLETED:
                return _CategoryListWidget(
                  categoryList: state.data,
                );
              case StatusType.ERROR:
                return errorWidget.ErrorWidget(
                  errorMessage: state.message,
                  onRetryPressed: _cubit.fetchCategories,
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

  List<String> get categories => categoryList?.categories ?? [];

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
              onTap: () => _didSelectCategory(
                ctx,
                categories[index],
              ),
              child: SizedBox(
                height: 60,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    categories[index],
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
        itemCount: categories.length,
        // shrinkWrap: true,
        // physics: ClampingScrollPhysics(),
      ),
    );
  }

  void _didSelectCategory(BuildContext context, String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        // fullscreenDialog: true,
        builder: (ctx) => ShowChuckyJoke(category),
      ),
    );
  }
}
