import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'presentation/setup/themes.dart';
import 'presentation/views/login_view/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: LoginView(),
    );
  }
}
