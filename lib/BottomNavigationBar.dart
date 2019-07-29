import 'package:flutter/material.dart';
import 'helpers/BottomNavigationBarBloc.dart';
import 'models/Project.dart';
import 'models/Transaction.dart';
import 'models/ListViewTransactions.dart';
import 'CreateTransactionPage.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:unicorndial/unicorndial.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'helpers/Constants.dart';
import 'CreateProjectPage.dart';

class BottomNavBarApp extends StatefulWidget {
  createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> {
  BottomNavBarBloc _bottomNavBarBloc;
  int _currentIndex = 0;
  List<String> _titles;

  @override
  void initState() {
    _titles = [
      "Home",
      "My Transactions",
      "Settings",
    ];
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

    var childButtons = List<UnicornButton>();
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "+ Expense",
        currentButton: FloatingActionButton(
          heroTag: "add_expense",
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Icon(Icons.train),
          onPressed: () {
            Transaction newTransaction =  new Transaction();
            newTransaction.transactionTypeId=1;
            Navigator.push(
                context,
                new MaterialPageRoute( builder: (context) => CreateTransactionPage(newTrxObject:newTransaction))
            );
          },
        )));
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "+ Income",
        currentButton: FloatingActionButton(
            heroTag: "add_income",
            backgroundColor: Colors.greenAccent,
            mini: true,
            onPressed: () {
              Transaction newTransaction =  new Transaction();
              newTransaction.transactionTypeId=0;
              Navigator.push(
                  context,
                  new MaterialPageRoute( builder: (context) => CreateTransactionPage(newTrxObject:newTransaction))
              );
            },
            child: Icon(Icons.airplanemode_active))));
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "+ Project",
        currentButton: FloatingActionButton(
            heroTag: "add_project",
            backgroundColor: Colors.blueAccent,
            mini: true,
            onPressed: () {
              Project newProject =  new Project();
              Navigator.push(
                  context,
                  new MaterialPageRoute( builder: (context) => CreateProjectPage(newProjectObject:newProject))
              );
            },
            child: Icon(Icons.directions_car))));

    return Scaffold(
      appBar: new AppBar(title: new Text( _titles[_currentIndex] ),),
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.HOME:
              return _buildBody(context);
            case NavBarItem.ALERT:
              return _buildTransactionList(context);
            case NavBarItem.SETTINGS:
              return _settingsArea();
          }
        },
      ),
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Colors.redAccent,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: childButtons),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(
            fixedColor: Colors.blueAccent,
            currentIndex: snapshot.data.index,
            //onTap: _bottomNavBarBloc.pickItem,
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
                title: Text('Settings'),
                icon: Icon(Icons.settings),
              ),
            ],
          );
        },
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _bottomNavBarBloc.pickItem;
  }

  ///////////// Home page ////////////
  Widget _buildBody(BuildContext context) {
    return FutureBuilder<List<Project>>(
        future: fetchProjects(),
        builder: (context, projectSummary) {
          if (projectSummary.hasError) print(projectSummary.error);

          return projectSummary.hasData
              ? ProjectsList(projects: projectSummary.data)
              : Center(child: CircularProgressIndicator());
        }
    );
  }

  String url = "http://45.56.73.81:8084/Mpango/api/v1/users/1/projects/summary";
  Future<List<Project>> fetchProjects() async {
    final response = await http.get(url);
    return compute(parseProjects, response.body);
  }

  static List<Project> parseProjects(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Project>((json) => Project.fromJson(json)).toList();
  }

  ProjectsList({List<Project> projects}) {
    final PageController pageController = PageController(initialPage: 0);
    return Column(
      children: <Widget>[
        new SizedBox(
          height: 202.0,
          child: Container(
            child: PageView(
              reverse: false,
              controller: pageController,
              scrollDirection: true ? Axis.horizontal : Axis.vertical,
              pageSnapping: true,
              children: projects
                  .map((project) => _buildPageItem(context, project))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPageItem(BuildContext context, Project record) {
    final List<charts.Series> seriesList = _createSampleData(record);
    return Center(
        child: Card(
            elevation: 2.0,
            child: Container(
                child: Column(
                  children: <Widget>[
                    new Container(height: 4.0),
                    Container(
                        child: Text( record.ProjectName, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17.0), )
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /*Expanded(
                        flex: 1,
                        child: Container(
                            height: 170.0,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Container(height: 20.0,),
                                  new Text("Income:", textAlign:TextAlign.left,  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14.0)),
                                  new Text(record.totalIncomes.toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0)),
                                  new Container(height: 10.0),
                                  new Text("Expenses:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14.0)),
                                  new Text(record.totalExpenses.toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0)),
                                ]
                            )
                        ),
                      ),*/
                          Expanded(
                            flex: 9,
                            child: Container(
                                height: 170.0,
                                child: new charts.PieChart(
                                    seriesList,
                                    animate: true,
                                    defaultRenderer: new charts.ArcRendererConfig(
                                        arcWidth: 12,
                                        arcRendererDecorators: [  // <-- add this to the code
                                          charts.ArcLabelDecorator() // <-- and this of course
                                        ]
                                    )
                                )
                            ),
                          ),
                        ]
                    )
                  ],
                )
            )
        )
    );
  }

  static List<charts.Series<LinearSales, int>> _createSampleData(
      Project record) {
    final data = [
      new LinearSales(0, record.totalExpenses.toInt(), Colors.red),
      new LinearSales(1, record.totalIncomes.toInt(), Colors.green),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (LinearSales sales, _) => sales.color,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}', //Add this
        // Set a label accessor to control the text of the arc label.
        //labelAccessorFn: (LinearSales sales, _) => sales.year == 'Main' ? '${sales.year}' : null,
      )
    ];
  }

  ///////// Transactions ///////////
  List data;
  String url_transactions = "http://45.56.73.81:8084/Mpango/api/v1/users/1/transactions";
  Future<List<Transaction>> fetchTransactions() async {
    final response = await http.get(url_transactions);
    return compute(parseTransactions, response.body);
  }

  // A function that converts a response body into a List<Photo>.
  static List<Transaction> parseTransactions(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Transaction>((json) => Transaction.fromJson(json)).toList();
  }

  Widget _buildTransactionList(BuildContext context){
    return FutureBuilder<List<Transaction>>(
        future: fetchTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return snapshot.hasData
              ? ListViewTransactions(transactions: snapshot.data)
              : Center(child: CircularProgressIndicator());
        }
    );
  }

  ////////// Settings //////////////
  Widget _settingsArea() {
    return Center(
      child: Text(
        'Settings Screen',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.blue,
          fontSize: 25.0,
        ),
      ),
    );
  }
}


/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;
  final charts.Color color;

  LinearSales(this.year, this.sales, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class Choice {
  const Choice({ this.title, this.icon, this.color});
  final String title;
  final IconData icon;
  final num color;
}
