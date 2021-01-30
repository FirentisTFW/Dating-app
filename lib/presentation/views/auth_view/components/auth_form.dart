import 'package:Dating_app/data/models/enums.dart';
import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class AuthForm extends StatefulWidget {
  final AuthType formType;

  const AuthForm(this.formType, {Key key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  GlobalKey<FormState> _formKey;
  FocusNode _focusNode;
  String _email;
  String _password;
  String _repeatPassword;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'Email Address'),
            cursorColor: Theme.of(context).primaryColor,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.compose([
              Validators.required('This field can\'t be empty'),
              Validators.email('Not valid e-mail address'),
            ]),
            onSaved: setEmail,
            onFieldSubmitted: (_) => _focusNode.nextFocus(),
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(hintText: 'Password'),
            cursorColor: Theme.of(context).primaryColor,
            obscureText: true,
            textInputAction: widget.formType == AuthType.Login
                ? TextInputAction.go
                : TextInputAction.next,
            validator: Validators.required('This field can\'t be empty'),
            onSaved: setPassword,
            onFieldSubmitted: (_) => _focusNode.nextFocus(),
          ),
          if (widget.formType == AuthType.Registration) ...{
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(hintText: 'Repeat Password'),
              cursorColor: Theme.of(context).primaryColor,
              obscureText: true,
              textInputAction: TextInputAction.go,
              validator: Validators.required('This field can\'t be empty'),
              onSaved: setRepeatPassword,
            ),
          },
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AuthenticateButton(
                widget.formType == AuthType.Login ? signIn : signUp,
                widget.formType,
              ),
              if (widget.formType == AuthType.Login)
                FlatButton(
                  onPressed: () {},
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(20))),
                  child: const Text(
                    'Need help?',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void signIn() {
    FocusScope.of(context).unfocus();
    var isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();
      BlocProvider.of<AuthBloc>(context).add(AuthLogin(_email, _password));
    }
  }

  void signUp() {
    FocusScope.of(context).unfocus();
    var isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();
      if (_password == _repeatPassword) {
        BlocProvider.of<AuthBloc>(context).add(AuthRegister(_email, _password));
      } else {
        Get.rawSnackbar(message: 'Passwords don\'t match.');
      }
    }
  }

  void setEmail(String value) => _email = value;

  void setPassword(String value) => _password = value;

  void setRepeatPassword(String value) => _repeatPassword = value;
}

class AuthenticateButton extends StatelessWidget {
  final Function authenticate;
  final AuthType _formType;

  const AuthenticateButton(this.authenticate, this._formType, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: authenticate,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(const Radius.circular(30)),
        ),
        child: Text(
          _formType == AuthType.Login ? 'Login' : 'Register',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
