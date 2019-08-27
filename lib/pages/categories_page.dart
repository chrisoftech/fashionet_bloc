import 'package:fashionet_bloc/consts/consts.dart';
import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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

  Widget _buildCategories() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return CategoryCard();
      }, childCount: 20),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildCreateCategoryFAB(),
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            _buildSliverAppBar(),
            SliverToBoxAdapter(child: PageIndicator()),
            _buildCategories(),
          ],
        ),
      ),
    );
  }
}
