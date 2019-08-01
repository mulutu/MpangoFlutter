import 'package:flutter/material.dart';
import 'HomePageDetails.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: HomePageDetails(),
      resizeToAvoidBottomPadding: false,
    );
  }

}
