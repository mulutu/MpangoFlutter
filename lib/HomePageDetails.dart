import 'package:flutter/material.dart';
import 'helpers/BottomNavigationBarBloc.dart';
import 'TransactionsPage.dart';
import 'TasksPage.dart';
import 'DrawerNormal.dart';
import 'HomePagePieChart.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;

class HomePageDetails extends StatefulWidget {
  createState() => _HomePageDetailsState();
}

class _HomePageDetailsState extends State<HomePageDetails> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BottomNavBarBloc _bottomNavBarBloc;
  int _currentIndex = 0;
  List<String> _titles;

  @override
  void initState() {
    _titles = [ "Home", "Transactions", "Tasks" ];
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  void dispose() {
    _bottomNavBarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text( _titles[_currentIndex] ),),
      drawerDragStartBehavior: DragStartBehavior.down,
      key: _scaffoldKey,
      drawer: DrawerNormal(),
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.HOME:
              return HomePagePieChart();
            case NavBarItem.ALERT:
              return TransactionsPage();
            case NavBarItem.TASKS:
              return TasksPage();
          }
        },
      ),
      //floatingActionButton: FloatingButtons(),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(
            fixedColor: Colors.blueAccent,
            currentIndex: snapshot.data.index,
            onTap: (int index) {
              setState(() { this._currentIndex = index; } );
              _bottomNavBarBloc.pickItem(index);
            },
            items: [
              BottomNavigationBarItem(
                title: Text('Home'),
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                title: Text('Transactions'),
                icon: Icon(Icons.notifications),
              ),
              BottomNavigationBarItem(
                title: Text('Tasks'),
                icon: Icon(Icons.calendar_today),
              ),
            ],
          );
        },
      ),
    );
  }
}



