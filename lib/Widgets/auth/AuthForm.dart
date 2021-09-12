import 'dart:io';

import 'package:chatapp_1/Widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,File image, bool isLogin,
      BuildContext ctx) submitFuc;
  final bool isLoading;
  AuthForm(this.submitFuc, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _username = "";

  File _userImageFile;
  void _pickedImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImageFile == null) {
      print("please enter a image");
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFuc(
          _email.trim(), _password.trim(), _username.trim(),_userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none ,
                  key: ValueKey("email"),
                  validator: (val) {
                    if (val.isEmpty || !val.contains("@")) {
                      return "Pleaase enter a valid email address";
                    }
                    return null;
                  },
                  onSaved: (val) => _email = val,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "email address"),
                ),
                if (!_isLogin)
                  TextFormField(
          autocorrect: true,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.words,
                    key: ValueKey("username"),
                    validator: (val) {
                      if (val.isEmpty || val.length < 4) {
                        return "Pleaase enter at least 4 charachters  ";
                      }
                      return null;
                    },
                    onSaved: (val) => _username = val,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                TextFormField(
                  key: ValueKey("password"),
                  validator: (val) {
                    if (val.isEmpty || val.length < 7) {
                      return "Pleaase enter at least 7 charachters";
                    }
                    return null;
                  },
                  onSaved: (val) => _password = val,
                  decoration: InputDecoration(labelText: "password"),
                  obscureText: true,
                ),
                SizedBox(
                  height: 12,
                ),
                if (!widget.isLoading)
                  RaisedButton(
                      child: Text(_isLogin ? "Login" : "Sign up"),
                      onPressed: submit),
                FlatButton(
                  child: Text(_isLogin
                      ? "Create new account"
                      : "I already have an account"),
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                ),
                if (widget.isLoading) CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
