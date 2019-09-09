import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostForm extends StatefulWidget {
  final Post post;

  const PostForm({Key key, this.post}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  PostFormBloc _postFormBloc;
  CategoryBloc _categoryBloc;

  final ScrollController _scrollController = ScrollController();
  final _categoryScrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _availabilityController = TextEditingController();

  int _currentPostImageIndex = 0;

  final List<String> _selectedCategories = [];
  bool _isItemAvailable = false;

  List<Asset> _images = List<Asset>();
  String _error = 'No Error Dectected';

  Post get _post => widget.post;
  PostFormState _postFormState = PostFormState.Default;

  @override
  void initState() {
    super.initState();

    // initialize form if post exists
    if (_post != null) {
      _titleController.text = _post.title;
      _descriptionController.text = _post.description;
      _priceController.text = _post.price.toString();
      _isItemAvailable = _post.isAvailable;
      _availabilityController.text = _isItemAvailable ? 'YES' : 'NO';

      _selectedCategories.addAll(Iterable.castFrom(_post.categories));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _categoryBloc = CategoryProvider.of(context);
    _postFormBloc = PostFormProvider.of(context);
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  void _hideKeyPad() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "fashioNet",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
          backButtonDrawable: "ic_back_arrow",
        ),
      );

      for (var r in resultList) {
        var t = await r.filePath;
        print(t);
      }
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _images = resultList;
      // _profileBloc.onProfileImageChanged(resultList[0]);
      _error = error;
    });
  }

  Widget _buildActivePostImage() {
    return Container(
      width: 9.0,
      height: 9.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(width: 2.0, color: Theme.of(context).accentColor),
      ),
    );
  }

  Widget _buildInactivePostImage() {
    return Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey));
  }

  Widget _buildPostImageCarouselIndicator() {
    List<Widget> dots = [];

    // final int _imageCount = _images.length;
    final int _imageCount =
        _images.isEmpty ? _post.imageUrls.length : _images.length;

    for (int i = 0; i < _imageCount; i++) {
      dots.add(i == _currentPostImageIndex
          ? _buildActivePostImage()
          : _buildInactivePostImage());
    }

    return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dots,
        ));
  }

  Widget _buildPostImageCarousel() {
    return CarouselSlider(
        height: 400.0,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        onPageChanged: (int index) {
          setState(() {
            _currentPostImageIndex = index;
          });
        },
        items: _images.isEmpty
            ? _post.imageUrls.map((dynamic postImageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return CachedNetworkImage(
                      imageUrl: '${postImageUrl.toString()}',
                      placeholder: (context, imageUrl) => Center(
                          child: CircularProgressIndicator(strokeWidth: 2.0)),
                      errorWidget: (context, imageUrl, error) =>
                          Center(child: Icon(Icons.error)),
                      imageBuilder:
                          (BuildContext context, ImageProvider image) {
                        return Hero(
                          tag: '${_post.postId}_${_post.imageUrls[0]}',
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: image, fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                  decoration:
                                      BoxDecoration(color: Colors.black12)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList()
            : _images.map((Asset asset) {
                return Builder(
                  builder: (BuildContext context) {
                    return AssetThumb(
                      asset: asset,
                      width: 300,
                      height: 300,
                    );
                  },
                );
              }).toList());
  }

  Widget _buildPostCardBackgroundImage() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(child: _buildPostImageCarousel()),
        _images.isEmpty && _post.imageUrls.length > 1
            ? _buildPostImageCarouselIndicator()
            : _images.length > 1
                ? _buildPostImageCarouselIndicator()
                : Container(),
      ],
    );
  }

  Widget _buildFlexibleSpaceBackground() {
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: <Widget>[
          Material(
            elevation: 5.0,
            child: Container(
              height: 150.0,
              width: _deviceWidth,
              padding: EdgeInsets.only(bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    borderRadius: BorderRadius.circular(50.0),
                    onTap: _postFormState == PostFormState.Loading
                        ? null
                        : () => _loadAssets(),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle),
                      child: Icon(Icons.camera_alt,
                          size: 30.0, color: Colors.white70),
                    ),
                  ),
                  SizedBox(height: 7.0),
                  Text(
                    'Add photo(s)',
                    style:
                        TextStyle(fontSize: 23.0, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'You can take or choose up to 5 images.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Material(
            child: Container(
              height: 300.0,
              width: _deviceWidth,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.black54),
              child: _post != null
                  ? _buildPostCardBackgroundImage()
                  : _images.isNotEmpty
                      ? _buildPostCardBackgroundImage()
                      : InkWell(
                          splashColor: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50.0),
                          onTap: _postFormState == PostFormState.Loading
                              ? null
                              : () => _loadAssets(),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.camera_alt,
                              size: 70.0,
                              color: Colors.white70,
                            ),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(
      {@required sectionTitle, @required sectionDetails}) {
    return Column(
      children: <Widget>[
        // addDivider ? Divider(color: Colors.black54, height: 0.0) : Container(),
        Material(
          elevation: 5.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              '$sectionTitle',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 10.0),
            Text('$sectionDetails'),
          ],
        ),
        // Divider(color: Colors.black54, height: 0.0)
      ],
    );
  }

  Widget _buildTitleTextFormField() {
    return TextFormField(
      controller: _titleController,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
          labelText: 'Title', hintText: 'Enter Title', filled: true),
      validator: (String value) {
        return value.isEmpty ? 'Please enter post title!' : null;
      },
    );
  }

  Widget _buildDescriptionTextFormField() {
    return TextFormField(
      maxLines: 2,
      controller: _descriptionController,
      keyboardType: TextInputType.multiline,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
          labelText: 'Description',
          hintText: 'Enter description',
          filled: true),
      validator: (String value) {
        return value.isEmpty
            ? 'Please enter post details or description!'
            : null;
      },
    );
  }

  Widget _buildPriceTextFormField() {
    return TextFormField(
      controller: _priceController,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20.0),
      decoration: InputDecoration(
          labelText: 'Price', hintText: 'Enter price', filled: true),
      validator: (String value) {
        return value.isEmpty ? 'Please enter price of item!' : null;
      },
    );
  }

  Widget _buildIsProductAvailableFormField() {
    if (_post != null) {
      setState(() {
        _isItemAvailable = _post.isAvailable;
        _availabilityController.text = _isItemAvailable ? 'YES' : 'NO';
      });
    }

    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            _hideKeyPad();
            setState(() {
              _isItemAvailable = !_isItemAvailable;
              _availabilityController.text = _isItemAvailable ? 'YES' : 'NO';
            });
          },
          child: IgnorePointer(
            child: TextFormField(
              style: TextStyle(fontSize: 20.0),
              controller: _availabilityController,
              decoration: InputDecoration(
                  labelText: 'Is this item available?',
                  hintText: 'Item availability',
                  filled: true),
              validator: (String value) {
                return value.isEmpty || value == 'FALSE'
                    ? 'Please check item availability!'
                    : null;
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Switch(
            value: _isItemAvailable,
            onChanged: (bool value) {
              setState(() {
                _isItemAvailable = value;
                _availabilityController.text = value ? 'YES' : 'NO';
              });
            },
          ),
        ),
      ],
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

  Widget _buildCategoryList() {
    return StreamBuilder<List<Category>>(
        stream: _categoryBloc.fetchCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
          }

          final List<Category> _categories = snapshot.data;

          return _categories.length == 0
              ? _buildNoCategory()
              : Container(
                  height: 100.0,
                  child: ListView.builder(
                    controller: _categoryScrollController,
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final Category _category = snapshot.data[index];

                      return Material(
                        elevation: 10.0,
                        child: InkWell(
                          onTap: () {
                            final String _categoryId = _category.categoryId;

                            if (_selectedCategories.contains(_categoryId)) {
                              // remove categoryId from list if it exists
                              setState(() {
                                _selectedCategories.removeWhere(
                                    (String categoryId) =>
                                        categoryId == _categoryId);
                              });
                            } else {
                              // check if number of list items == 4 (MaxCategoriesAllowed)
                              if (_selectedCategories.length >= 4) {
                                final _icon =
                                    Icon(Icons.warning, color: Colors.amber);
                                _showSnackbar(
                                    icon: _icon,
                                    title: 'Categories',
                                    message:
                                        'Maximum number of categories allowed reached!');

                                return;
                              }

                              // add categoryId to list if it does not exist in list already
                              setState(() {
                                _selectedCategories.add(_categoryId);
                              });
                            }
                            print(_selectedCategories.length);
                          },
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 100.0,
                                width: 100.0,
                                margin: EdgeInsets.all(10.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.black26,
                                ),
                                child: Center(
                                  child: Text(
                                    '${_category.title.substring(0, 1)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(
                                            color: Colors.white30,
                                            fontSize: 80.0,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                height: 100.0,
                                width: 100.0,
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.black26,
                                ),
                                child: Center(
                                  child: Text(
                                    '${_category.title}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .display1
                                        .copyWith(
                                            color: Colors.white,
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              !_selectedCategories
                                      .contains(_category.categoryId)
                                  ? Container()
                                  : Positioned(
                                      top: 10.0,
                                      left: 15.0,
                                      child: Container(
                                        height: 80.0,
                                        width: 90.0,
                                        color: Colors.black38,
                                        child: Center(
                                          child: Icon(
                                            Icons.check,
                                            size: 40.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
        });
  }

  void _showSnackbar(
      {@required Icon icon, @required String title, @required String message}) {
    if (!mounted) return;

    Flushbar(
      icon: icon,
      title: title,
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  Future<void> _scrollToStart() async {
    await _categoryScrollController.animateTo(
        _categoryScrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn);

    await _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn);
  }

  void _resetForm() {
    _formKey.currentState.reset();

    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();

    _isItemAvailable = false;
    _availabilityController.text = _isItemAvailable ? 'YES' : 'NO';

    setState(() {
      _images.clear();
      _selectedCategories.clear();
    });
    _scrollToStart();
  }

  Future<void> _submitForm() async {
    _hideKeyPad();
    if (_post == null) {
      if (_images.isEmpty) {
        final _icon = Icon(Icons.warning, color: Colors.amber);
        _showSnackbar(
            icon: _icon,
            title: 'Validation',
            message: 'Please select post image(s) to continue!');

        _scrollToStart();
        return;
      }
    }

    if (!_formKey.currentState.validate()) {
      final _icon = Icon(Icons.warning, color: Colors.amber);
      _showSnackbar(
          icon: _icon,
          title: 'Validation',
          message: 'Please complete all required information in the form!');

      return;
    }

    final ReturnType _isCreated = _post != null
        ? await _postFormBloc.updatePost(
            assets: _images,
            postId: _post.postId,
            title: _titleController.text,
            description: _descriptionController.text,
            price: _priceController.text.isEmpty
                ? 0.0
                : double.parse(_priceController.text),
            isAvailable: _isItemAvailable,
            categories: _selectedCategories,
          )
        : await _postFormBloc.createPost(
            assets: _images,
            title: _titleController.text,
            description: _descriptionController.text,
            price: _priceController.text.isEmpty
                ? 0.0
                : double.parse(_priceController.text),
            isAvailable: _isItemAvailable,
            categories: _selectedCategories,
          );

    if (_isCreated.returnType) {
      final _icon = Icon(Icons.verified_user, color: Colors.green);
      _showSnackbar(
          icon: _icon, title: 'Success', message: _isCreated.messagTag);

      if (_post == null) {
        _resetForm();
      } else {
        _scrollToStart();
      }
    } else {
      final _icon = Icon(Icons.error_outline, color: Colors.red);
      _showSnackbar(icon: _icon, title: 'Error', message: _isCreated.messagTag);
    }
  }

  Widget _buildCustomSavePostFAB() {
    return StreamBuilder<PostFormState>(
        stream: _postFormBloc.postFormState,
        builder: (context, snapshot) {
          final double _buttonWidth =
              snapshot.data == PostFormState.Loading ? 50.0 : 150.0;
          // setState(() => _postFormState = snapshot.data);
          _onWidgetDidBuild(() {
            _postFormState = snapshot.data;
          });

          return Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Material(
                  elevation: 10.0,
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(25.0),
                  child: InkWell(
                    onTap: snapshot.data == PostFormState.Loading
                        ? null
                        : () => _submitForm(),
                    splashColor: Colors.black38,
                    borderRadius: BorderRadius.circular(25.0),
                    child: AnimatedContainer(
                      height: 50.0,
                      width: _buttonWidth,
                      duration: Duration(milliseconds: 150),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: snapshot.data == PostFormState.Loading
                          ? SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.0),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    'Upload',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Flexible(
                                  child: Icon(
                                    Icons.cloud_upload,
                                    size: 30.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
              ],
            ),
          );
        });
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 500.0,
      pinned: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildFlexibleSpaceBackground(),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Material(
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: _postFormState == PostFormState.Loading
                        ? null
                        : () => _loadAssets(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.image, size: 20.0),
                        SizedBox(width: 5.0),
                        Text('Open gallery'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          // padding: EdgeInsets.symmetric(
          //     horizontal: formContainerPaddingValue / 2),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildSectionLabel(
                    sectionTitle: 'Details Section',
                    sectionDetails: 'Enter post details'),
                _buildTitleTextFormField(),
                _buildDescriptionTextFormField(),
                _buildPriceTextFormField(),
                _buildIsProductAvailableFormField(),
                _buildSectionLabel(
                    sectionTitle: 'Category Section',
                    sectionDetails:
                        'You can select up to 4 categories for a post'),
                _buildCategoryList(),
                SizedBox(height: 10.0),
                _buildCustomSavePostFAB(),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildCustomScrollView({@required double formContainerPaddingValue}) {
    return Material(
      child: KeyboardAvoider(
        autoScroll: true,
        // key: _keyboardAvoiderKey,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            _buildSliverAppBar(),
            _buildSliverList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _formContainerWidth =
        _deviceWidth > 550.0 ? 550.0 : _deviceWidth;

    final double _formContainerPaddingValue =
        (_deviceWidth > _formContainerWidth)
            ? (_deviceWidth - _formContainerWidth)
            : 0.0;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: _buildCustomScrollView(
            formContainerPaddingValue: _formContainerPaddingValue),
      ),
    );
  }
}
