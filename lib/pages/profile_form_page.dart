import 'package:country_code_picker/country_code_picker.dart';
import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:fashionet_bloc/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:libphonenumber/libphonenumber.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

class ProfileFormPage extends StatefulWidget {
  @override
  _ProfileFormPageState createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController _scrollController;

  AuthBloc _authBloc;
  ProfileBloc _profileBloc;

  CountryCode _selectedCountryCode;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otherPhoneNumberController =
      TextEditingController();

  List<Asset> _images = List<Asset>();
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _authBloc = AuthProvider.of(context);
    _profileBloc = ProfileProvider.of(context);
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
      _profileBloc.onProfileImageChanged(resultList[0]);
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
    return StreamBuilder<String>(
        stream: _profileBloc.firstName,
        builder: (context, snapshot) {
          return TextField(
            style: TextStyles.textFieldTextStyle,
            onChanged: _profileBloc.onFirstNameChanged,
            decoration: InputDecoration(
                labelText: 'First Name', errorText: snapshot.error),
          );
        });
  }

  Widget _buildLastNameTextField() {
    return StreamBuilder<String>(
        stream: _profileBloc.lastName,
        builder: (context, snapshot) {
          return TextField(
            style: TextStyles.textFieldTextStyle,
            onChanged: _profileBloc.onLastNameChanged,
            decoration: InputDecoration(
                labelText: 'Last Name', errorText: snapshot.error),
          );
        });
  }

  Widget _buildBusinessNameTextField() {
    return StreamBuilder<String>(
        stream: _profileBloc.businessName,
        builder: (context, snapshot) {
          return TextField(
            style: TextStyles.textFieldTextStyle,
            onChanged: _profileBloc.onBusinessNameChanged,
            decoration: InputDecoration(
                labelText: 'Business Name', errorText: snapshot.error),
          );
        });
  }

  Widget _buildBusinessDescriptionTextField() {
    return StreamBuilder<String>(
        stream: _profileBloc.businessDescription,
        builder: (context, snapshot) {
          return TextField(
            style: TextStyles.textFieldTextStyle,
            onChanged: _profileBloc.onBusinessDescriptionChanged,
            decoration: InputDecoration(
                labelText: 'Business Description', errorText: snapshot.error),
          );
        });
  }

  Widget _buildPhoneNumberTextField() {
    return StreamBuilder<String>(
        stream: _profileBloc.phoneNumber,
        builder: (context, snapshot) {
          return Row(
            children: <Widget>[
              CountryCodePicker(
                onChanged: (CountryCode countryCode) {
                  _selectedCountryCode = countryCode;
                  _profileBloc.onCountryCodeChanged(countryCode);
                },
                initialSelection: '+233',
                favorite: ['+233'],
                showCountryOnly: false,
                padding: EdgeInsets.only(
                    top: snapshot.error == null ? 13.0 : 0.0,
                    bottom: snapshot.error == null ? 0.0 : 7.0,
                    right: 2.0),
                textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: TextField(
                  keyboardType: TextInputType.phone,
                  style: TextStyles.textFieldTextStyle,
                  controller: _phoneNumberController,
                  onChanged: _profileBloc.onPhoneNumberChanged,
                  decoration: InputDecoration(
                      labelText: 'Phone Number', errorText: snapshot.error),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildOtherPhoneNumberTextField() {
    return StreamBuilder<String>(
        stream: _profileBloc.otherPhoneNumber,
        builder: (context, snapshot) {
          return TextField(
            keyboardType: TextInputType.phone,
            style: TextStyles.textFieldTextStyle,
            controller: _otherPhoneNumberController,
            onChanged: _profileBloc.onOtherPhoneNumberChanged,
            decoration: InputDecoration(
              labelText: 'Other Phone Number',
              prefixText: '$_selectedCountryCode ',
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget _buildLocationTextField() {
    return StreamBuilder<String>(
        stream: _profileBloc.location,
        builder: (context, snapshot) {
          return TextField(
            style: TextStyles.textFieldTextStyle,
            onChanged: _profileBloc.onLocationChanged,
            decoration: InputDecoration(
              labelText: 'Location',
              prefixIcon: Icon(Icons.location_on),
              errorText: snapshot.error,
            ),
          );
        });
  }

  void _showSnackbar({@required String message}) {
    final snackbar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(child: Text(message)),
            Icon(Icons.info_outline, color: Theme.of(context).accentColor)
          ],
        ),
        duration: new Duration(seconds: 2));
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  Future<void> _scrollToStart() async {
    await _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeIn);
  }

  void _submitForm() async {
    if (_images.isEmpty) {
      _showSnackbar(message: 'Please select a profile image to continue!');
      _scrollToStart();
      return;
    }

    if (!await PhoneNumberUtil.isValidPhoneNumber(
        phoneNumber:
            '${_selectedCountryCode.dialCode}${_phoneNumberController.text}',
        isoCode: _selectedCountryCode.code)) {
      _showSnackbar(message: 'Primary phone number is invalid!');
      return;
    }

    if (!await PhoneNumberUtil.isValidPhoneNumber(
        phoneNumber:
            '${_selectedCountryCode.dialCode}${_phoneNumberController.text}',
        isoCode: _selectedCountryCode.code)) {
      _showSnackbar(message: 'Primary phone number is invalid!');
      return;
    }

    if (!await PhoneNumberUtil.isValidPhoneNumber(
        phoneNumber:
            '${_selectedCountryCode.dialCode}${_otherPhoneNumberController.text}',
        isoCode: _selectedCountryCode.code)) {
      _showSnackbar(message: 'Other phone number is invalid!');
      return;
    }

    ReturnType _isCreated = await _profileBloc.createProfile();

    if (!_isCreated.returnType) {
      _showSnackbar(message: _isCreated.messagTag);
    }
  }

  Widget _buildActionButton() {
    return StreamBuilder<bool>(
        stream: _profileBloc.validateForm,
        builder: (context, validatorSnapshot) {
          return StreamBuilder<ProfileState>(
              stream: _profileBloc.profileState,
              builder: (context, snapshot) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    onPressed: (validatorSnapshot.hasData &&
                            validatorSnapshot.data &&
                            snapshot.data != ProfileState.Loading)
                        ? () => _submitForm()
                        : null,
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
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
                          snapshot.data == ProfileState.Loading
                              ? SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.0),
                                )
                              : Icon(Icons.arrow_forward_ios,
                                  size: 18.0,
                                  color: Theme.of(context).primaryColor)
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
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
        key: _scaffoldKey,
        floatingActionButton: _buildActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
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
                        SizedBox(height: 60.0),
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
