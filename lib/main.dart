import 'package:fashionet_bloc/pages/pages.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'QuickSand',
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber),
      home: AuthPage(),
    );
  }
}
