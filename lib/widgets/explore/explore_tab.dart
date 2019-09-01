import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreTab extends StatefulWidget {
  final ScrollController scrollController;

  const ExploreTab({Key key, @required this.scrollController})
      : super(key: key);
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  CategoryBloc _categoryBloc;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  PostBloc _postBloc;

  // ScrollController get _scrollController => widget.scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // _postBloc = PostFormProvider.of(context);
    _categoryBloc = CategoryProvider.of(context);
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
      _postBloc.onFetchPosts();
    }
  }

  Widget _buildFlexibleSpaceBarTitle() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Explore',
                  style: Theme.of(context).textTheme.display2.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
            ),
            PageIndicator()
          ],
        ),
      ),
    );
  }

  Widget _buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(background: _buildFlexibleSpaceBarTitle());
  }

  Widget _buildSearchField() {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _contentPadding),
      child: Material(
        elevation: 8.0,
        child: Container(
            child: TextField(
          style: Theme.of(context).textTheme.display1.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.mic),
            hintText: 'Search Posts',
            border: UnderlineInputBorder(borderSide: BorderSide.none),
          ),
        )),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0.0,
      expandedHeight: 190.0,
      backgroundColor: Colors.transparent,
      flexibleSpace: _buildFlexibleSpaceBar(),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0), child: _buildSearchField()),
    );
  }

  Widget _buildSectionLabel({@required String label}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, bottom: 5.0),
      child: Text('$label',
          style: Theme.of(context).textTheme.display1.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildNoCategory() {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return Container(
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
    );
  }

  Widget _buildCategories() {
    return SliverToBoxAdapter(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionLabel(label: 'Categories'),
        StreamBuilder<List<Category>>(
            stream: _categoryBloc.fetchCategories(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0));
              }

              final List<Category> _categories = snapshot.data;

              return _categories.length == 0
                  ? _buildNoCategory()
                  : Container(
                      height: 100.0,
                      child: ListView.builder(
                        itemCount: _categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final Category _category = _categories[index];

                          return Row(
                            children: <Widget>[
                              index == 0 ? SizedBox(width: 20.0) : Container(),
                              CategoryLabel(category: _category),
                              SizedBox(width: 10.0),
                            ],
                          );
                        },
                      ),
                    );
            }),
      ],
    ));
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
              'No posts yet',
              style: Theme.of(context).textTheme.display1.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: _contentPadding),
              child: Text(
                'You can easily find all users posts here',
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

  Widget _buildSliverDynamicContent({@required PostState state}) {
    if (state is PostUninitialized) {
      return _buildLoadingIndicator();
    }
    if (state is PostError) {
      return SliverFillRemaining(
        child: Center(
          child: Text('failed to fetch posts'),
        ),
      );
    }

    if (state is PostLoaded) {
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
    // final double _deviceWidth = MediaQuery.of(context).size.width;
    // final double _contentMaxWidth =
    //     _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      return CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          _buildSliverAppBar(),
          _buildCategories(),
          SliverToBoxAdapter(child: _buildSectionLabel(label: 'Post Feed')),
          _buildSliverDynamicContent(state: state),
          SliverToBoxAdapter(
            child: SizedBox(height: 100.0),
          ),
        ],
      );
    });
  }
}
