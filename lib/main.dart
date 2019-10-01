import 'package:flutter/material.dart';
import 'package:mpango/HomePage.dart';
import 'package:mpango/ui/LoginPage.dart';
import 'package:mpango/TasksPage.dart';
import 'package:mpango/CreateTransactionPage.dart';
import 'package:mpango/helpers/Constants.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:timezone/timezone.dart';
import 'package:mpango/ui/login/LoginScreen.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:mpango/models/redux/reducers/AppReducer.dart';
import 'package:mpango/AppState.dart';
import 'package:mpango/models/navigation/navigation.dart';
//import 'screens/home//home_screen.dart';
import 'package:flutter_redux/flutter_redux.dart';


void main() async {
  //debugPrint = (String message, {int wrapWidth}) {};
  ByteData loadedData;
  await Future.wait<void>(<Future<void>>[
      rootBundle.load('assets/timezone/2018c.tzf').then((ByteData data) {loadedData = data;  })
    ]);
  initializeDatabase(loadedData.buffer.asUint8List());
  runApp(new MpangoApp());
}

class MpangoApp extends StatelessWidget{

  final store = Store<AppState>(
      appReducer,
      initialState: new AppState.initial(),
      middleware: [thunkMiddleware]
  );

  final routes = <String, WidgetBuilder>{
    loginPageTag: (context) => LoginPage(),
    homePageTag: (context) => HomePage(),
    createTransactionPageTag: (context) => CreateTransactionPage(),
    userTasksPageTag: (context) => TasksPage(),
  };

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: appTitle,
        navigatorKey: Keys.navKey,
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: LoginScreen(title: 'Log in'),
        routes: {
          Routes.homeScreen: (context) {
            return HomePage();
          },
        },
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const <LocalizationsDelegate<MaterialLocalizations>>[
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: const <Locale>[
          const Locale('en', ''),
          //const Locale('fr', ''),
        ],
        title: appTitle,
        theme: new ThemeData(
          //primaryColor: appDarkGreyColor,
          primarySwatch: Colors.teal,
        ),
        //home: LoginPage(),
        home: LoginScreen(title: 'Log in'),
        routes: routes,
    );
  }*/

}