import 'package:fashionet_bloc/consts/consts.dart';
import 'package:flutter/material.dart';

class CategoryForm extends StatefulWidget {
  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  Widget _buildFormTitle() {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Category Form',
              style: Theme.of(context).textTheme.display1.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Text(
          'Complete all required information',
          style: Theme.of(context)
              .textTheme
              .display1
              .copyWith(color: Theme.of(context).primaryColor, fontSize: 15.0),
        ),
      ],
    );
  }

  Widget _buildTitleTextField() {
    return TextField(
      // keyboardType: TextInputType.emailAddress,
      style: TextStyles.textFieldTextStyle,
      decoration: InputDecoration(labelText: 'Title'),
    );
  }

  Widget _buildDescriptioneTextField() {
    return TextField(
      maxLines: 2,
      keyboardType: TextInputType.multiline,
      style: TextStyles.textFieldTextStyle,
      decoration: InputDecoration(labelText: 'Description'),
    );
  }

  void submitForm() {}

  Widget _buildActionButton() {
    return Align(
      alignment: Alignment.bottomCenter,
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

  Widget _buildCategoryForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildFormTitle(),
          _buildTitleTextField(),
          _buildDescriptioneTextField(),
          SizedBox(height: 20.0),
          _buildActionButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 280.0,
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        child: _buildCategoryForm(),
      ),
    );
  }
}
