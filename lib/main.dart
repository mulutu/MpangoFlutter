import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import 'TasksPage.dart';
import 'CreateTransactionPage.dart';
import 'helpers/Constants.dart';

void main() => runApp(MpangoApp());

class MpangoApp extends StatelessWidget{

  final routes = <String, WidgetBuilder>{
    loginPageTag: (context) => LoginPage(),
    homePageTag: (context) => HomePage(),
    createTransactionPageTag: (context) => CreateTransactionPage(),
    userTasksPageTag: (context) => TasksPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: new ThemeData(
          //primaryColor: appDarkGreyColor,
          primarySwatch: Colors.teal,
        ),
        home: LoginPage(),
        routes: routes,
    );
  }

}