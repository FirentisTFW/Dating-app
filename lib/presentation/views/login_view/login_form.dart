import 'package:Dating_app/logic/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey;
  String _email;
  String _password;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
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
            validator: Validators.compose([
              Validators.required('This field can\'t be empty'),
              Validators.email('Not valid e-mail address'),
            ]),
            onSaved: setEmail,
          ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(hintText: 'Password'),
            cursorColor: Theme.of(context).primaryColor,
            obscureText: true,
            validator: Validators.required('This field can\'t be empty'),
            onSaved: setPassword,
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LoginButton(signIn),
              FlatButton(
                onPressed: () {},
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
    var isValid = _formKey.currentState.validate();

    if (isValid) {
      _formKey.currentState.save();
      BlocProvider.of<AuthBloc>(context).add(AuthLogin(_email, _password));
    }
  }

  void setEmail(String value) => _email = value;

  void setPassword(String value) => _password = value;
}

class LoginButton extends StatelessWidget {
  final Function signIn;

  const LoginButton(this.signIn, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: signIn,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(const Radius.circular(30)),
        ),
        child: const Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
