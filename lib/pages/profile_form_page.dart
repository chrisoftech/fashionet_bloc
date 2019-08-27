import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:fashionet_bloc/consts/consts.dart';
import 'package:flutter/material.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

class ProfileFormPage extends StatefulWidget {
  @override
  _ProfileFormPageState createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  AuthBloc _authBloc;

  List<Asset> _images = List<Asset>();
  String _error = 'No Error Dectected';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _authBloc = AuthProvider.of(context);
  }

  void _hideKeypad() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
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
      _error = error;
    });
  }

  Widget _buildFormTitle() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text('FASHIONet',
              style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor)),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Text('Please, complete profile form before proceeding',
                style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildImagePlaceHolder() {
    return Container(
      height: 110.0,
      width: 110.0,
      child: Stack(
        children: <Widget>[
          Container(
            height: 110.0,
            width: 110.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12,
              border:
                  Border.all(width: 1.0, color: Theme.of(context).primaryColor),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/avatars/avatar.png'),
              ),
            ),
            child: _images.isEmpty
                ? Container()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(55.0),
                    child: AssetThumb(
                      asset: _images[0],
                      width: 300,
                      height: 300,
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Material(
              elevation: 10.0,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              child: InkWell(
                onTap: () => _loadAssets(),
                splashColor: Colors.black38,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Icon(
                    Icons.camera_alt,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageUploadForm() {
    return Container(
      // padding: EdgeInsets.only(top: 20.0),
      child: Row(
        children: <Widget>[
          _buildImagePlaceHolder(),
          SizedBox(width: 20.0),
          Text(
            'Add Profile Image',
            style: TextStyle(
                color: Colors.black87,
                letterSpacing: -.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(
      {@required String sectionTitle, String sectionDetails}) {
    return Column(
      children: <Widget>[
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
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
        sectionDetails == null
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Text('$sectionDetails'),
                ],
              ),
      ],
    );
  }

  Widget _buildFirstNameTextField() {
    return TextField(
      style: TextStyles.textFieldTextStyle,
      decoration: InputDecoration(labelText: 'First Name'),
    );
  }

  Widget _buildLastNameTextField() {
    return TextField(
      style: TextStyles.textFieldTextStyle,
      decoration: InputDecoration(labelText: 'Last Name'),
    );
  }

  Widget _buildBusinessNameTextField() {
    return TextField(
      style: TextStyles.textFieldTextStyle,
      decoration: InputDecoration(labelText: 'Business Name'),
    );
  }

  Widget _buildBusinessDescriptionTextField() {
    return TextField(
      style: TextStyles.textFieldTextStyle,
      decoration: InputDecoration(labelText: 'Business Description'),
    );
  }

  Widget _buildPhoneNumberTextField() {
    return TextField(
      keyboardType: TextInputType.phone,
      style: TextStyles.textFieldTextStyle,
      decoration: InputDecoration(labelText: 'Phone Number'),
    );
  }

  Widget _buildOtherPhoneNumberTextField() {
    return TextField(
      keyboardType: TextInputType.phone,
      style: TextStyles.textFieldTextStyle,
      decoration: InputDecoration(labelText: 'Other Phone Number'),
    );
  }

  Widget _buildLocationTextField() {
    return TextField(
      style: TextStyles.textFieldTextStyle,
      decoration: InputDecoration(
        labelText: 'Location',
        prefixIcon: Icon(Icons.location_on),
      ),
    );
  }

  void submitForm() {
    _authBloc.signOutUser();
  }

  Widget _buildActionButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: RaisedButton(
        onPressed: () => submitForm(),
        color: Theme.of(context).accentColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Submit',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 20.0),
              Icon(Icons.arrow_forward_ios,
                  size: 18.0, color: Theme.of(context).primaryColor)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return GestureDetector(
      onTap: _hideKeypad,
      child: Scaffold(
        floatingActionButton: _buildActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: 0.0,
                backgroundColor: Colors.white70,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(150.0),
                  child: Container(
                    padding: EdgeInsets.only(
                        right: _contentPadding,
                        left: _contentPadding,
                        bottom: 10.0),
                    child: Column(
                      children: <Widget>[
                        _buildFormTitle(),
                        SizedBox(height: 30.0),
                        _buildImageUploadForm(),
                        // SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment(0.0, 0.0),
                  padding: EdgeInsets.symmetric(horizontal: _contentPadding),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        _buildSectionLabel(
                            sectionTitle: 'Bio Section',
                            sectionDetails: 'Enter your name(s)'),
                        _buildFirstNameTextField(),
                        SizedBox(height: 10.0),
                        _buildLastNameTextField(),
                        _buildSectionLabel(
                            sectionTitle: 'Business Section',
                            sectionDetails: 'Tell us about your business'),
                        _buildBusinessNameTextField(),
                        SizedBox(height: 10.0),
                        _buildBusinessDescriptionTextField(),
                        _buildSectionLabel(
                            sectionTitle: 'Contact(s) Section',
                            sectionDetails: 'How can you be contacted?'),
                        _buildPhoneNumberTextField(),
                        SizedBox(height: 10.0),
                        _buildOtherPhoneNumberTextField(),
                        _buildSectionLabel(
                            sectionTitle: 'Location/Address Section',
                            sectionDetails:
                                'Where can your clients locate you?'),
                        _buildLocationTextField(),
                        SizedBox(height: 50.0),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
