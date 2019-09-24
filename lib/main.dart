import 'package:flutter/material.dart';
import 'package:mpango/HomePage.dart';
import 'package:mpango/ui/LoginPage.dart';
import 'package:mpango/TasksPage.dart';
import 'package:mpango/CreateTransactionPage.dart';
import 'package:mpango/helpers/Constants.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/timezone.dart';

//void main() => runApp(MpangoApp());
void main() async {
  //debugPrint = (String message, {int wrapWidth}) {};
  ByteData loadedData;
  await Future.wait<void>(<Future<void>>[
      rootBundle.load('assets/timezone/2018c.tzf').then((ByteData data) {loadedData = data;  })
    ]);
  initializeDatabase(loadedData.buffer.asUint8List());
  runApp(new MpangoApp());
}

/*void main() async {
  var byteData = await rootBundle.load('assets/timezone/${tzDataDefaultFilename}');
  initializeDatabase(byteData.buffer.asUint8List());
  runApp(new MpangoApp());
}*/

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
        localizationsDelegates: const <LocalizationsDelegate<MaterialLocalizations>>[
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: const <Locale>[
          const Locale('en', ''),
          const Locale('fr', ''),
        ],
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