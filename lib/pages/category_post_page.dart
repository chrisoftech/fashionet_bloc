import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPostPage extends StatefulWidget {
  final Category category;

  const CategoryPostPage({Key key, @required this.category}) : super(key: key);

  @override
  _CategoryPostPageState createState() => _CategoryPostPageState();
}

class _CategoryPostPageState extends State<CategoryPostPage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  CategoryPostBloc _postBloc;

  Category get _category => widget.category;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _postBloc = BlocProvider.of<CategoryPostBloc>(context);
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postBloc.onFetchPosts(categoryId: _category.categoryId);
    }
  }

  Widget _buildAppBarLeading() {
    return IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.arrow_back,
        ),
        color: Theme.of(context).primaryColor);
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0.0,
      expandedHeight: 100.0,
      automaticallyImplyLeading: false,
      leading: _buildAppBarLeading(),
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '${_category.title}',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStackBackground({@required double deviceWidth}) {
    return Positioned(
      top: 0.0,
      height: 200.0 * .80,
      child: Container(
        width: deviceWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Text(
            '${_category.title.substring(0, 1)}',
            style: Theme.of(context).textTheme.display1.copyWith(
                color: Colors.white30,
                fontSize: 180.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildStackCard(
      {@required double deviceWidth, @required double contentPadding}) {
    return Positioned(
      bottom: 0.0,
      height: 200.0 * .60,
      child: Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: contentPadding),
        child: Card(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0.0,
                left: 0.0,
                width: deviceWidth * .50,
                height: 200.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black12, shape: BoxShape.circle),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                width: deviceWidth * .50,
                height: 200.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black12, shape: BoxShape.circle),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: ListTile(
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${_category.title}',
                        style: Theme.of(context).textTheme.display1.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 5.0),
                    ],
                  ),
                  subtitle: Text(
                    '${_category.description}',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIntroStack() {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return Container(
      height: 200.0,
      width: _deviceWidth,
      child: Stack(
        children: <Widget>[
          _buildStackBackground(deviceWidth: _deviceWidth),
          _buildStackCard(
              deviceWidth: _deviceWidth, contentPadding: _contentPadding)
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)));
  }

  Widget _buildNoPosts() {
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
              Icons.new_releases,
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              'No posts for this category yet',
              style: Theme.of(context).textTheme.display1.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: _contentPadding),
              child: Text(
                'You can easily find all ${_category.title} related posts here',
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

  Widget _buildSliverDynamicContent({@required CategoryPostState state}) {
    if (state is CategoryPostUninitialized) {
      return _buildLoadingIndicator();
    }
    if (state is CategoryPostError) {
      return SliverFillRemaining(
        child: Center(
          child: Text('failed to fetch posts'),
        ),
      );
    }

    if (state is CategoryPostLoaded) {
      if (state.posts.isEmpty) {
        return _buildNoPosts();
      }

      final List<Post> _posts = state.posts;

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return index >= state.posts.length
              ? BottomLoader()
              : PostCardDefault(post: _posts[index]);
        },
            childCount: state.hasReachedMax
                ? state.posts.length
                : state.posts.length + 1),
      );
    }

    return SliverToBoxAdapter(child: Container());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CategoryPostBloc, CategoryPostState>(
        builder: (context, state) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              _buildSliverAppBar(),
              SliverToBoxAdapter(
                child: _buildCategoryIntroStack(),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.0)),
              _buildSliverDynamicContent(state: state),
            ],
          );
        },
      ),
    );
  }
}
