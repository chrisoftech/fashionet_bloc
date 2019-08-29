import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  CategoryBloc _categoryBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _categoryBloc = CategoryProvider.of(context);
  }

  Widget _buildFlexibleSpaceBarTitle() {
    return Text('Categories',
        style: Theme.of(context).textTheme.display2.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold));
  }

  Widget _buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
      title: _buildFlexibleSpaceBarTitle(),
      titlePadding: EdgeInsets.only(left: 20.0, bottom: 10.0),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0.0,
      expandedHeight: 150.0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: _buildFlexibleSpaceBar(),
    );
  }

  void _openCategoryForm() {
    showDialog(
        context: context,
        builder: (context) {
          return CategoryForm();
        });
  }

  Widget _buildCreateCategoryFAB() {
    return FloatingActionButton(
      onPressed: _openCategoryForm,
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 35.0,
      ),
    );
  }

  Widget _buildCategories({@required List<Category> categories}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final Category _category = categories[index];

        return CategoryCard(category: _category);
      }, childCount: categories.length),
    );
  }

  Widget _buildLoadingIndicator() {
    return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)));
  }

  Widget _buildNoCategory() {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return SliverFillRemaining(
      child: Container(
        alignment: Alignment(0.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.category,
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              'No categories yet',
              style: Theme.of(context).textTheme.display1.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: _contentPadding),
              child: Text(
                'Add categories in Fashionet so you can easily find them here',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.display1.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverDynamicContent(
      {@required AsyncSnapshot<List<Category>> snapshot}) {
    // return _buildNoCategory();
    if (!snapshot.hasData) {
      return _buildLoadingIndicator();
    } else {
      final List<Category> _categories = snapshot.data;

      if (_categories.isEmpty) {
        return _buildNoCategory();
      }

      return _buildCategories(categories: _categories);
    }
  }

  Widget _buildCategoryList(
      {@required AsyncSnapshot<List<Category>> snapshot}) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        _buildSliverAppBar(),
        SliverToBoxAdapter(child: PageIndicator()),
        _buildSliverDynamicContent(snapshot: snapshot)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildCreateCategoryFAB(),
      body: SafeArea(
        child: StreamBuilder<List<Category>>(
            stream: _categoryBloc.fetchCategories(),
            builder: (context, snapshot) {
              return _buildCategoryList(snapshot: snapshot);
            }),
      ),
    );
  }
}
