import 'package:flutter/material.dart';
import 'bottom-navbar-bloc.dart';
import 'models/Project.dart';
import 'models/ProjectSummaryRecordList.dart';

import 'models/Project.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'DonutPieChart.dart';
import 'bottom-navbar-app.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class BottomNavBarApp extends StatefulWidget {
  createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> {
  BottomNavBarBloc _bottomNavBarBloc;

  @override
  void initState() {
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
      appBar: AppBar(
        title: Text('Bottom NavBar Navigation'),
      ),
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.HOME:
              //return _homeArea();
              return _buildBody(context);
            case NavBarItem.ALERT:
              //return _alertArea();
              return listSection(context);
            case NavBarItem.SETTINGS:
              return _settingsArea();
          }
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(
            fixedColor: Colors.blueAccent,
            currentIndex: snapshot.data.index,
            onTap: _bottomNavBarBloc.pickItem,
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

  // A function that converts a response body into a List<Photo>.
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
              reverse: true,
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
      //children: <Widget>[_topSection, listSection],
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
  String url_transactions = "http://45.56.73.81:8084/Mpango/api/v1/users/1/projects/summary";
  static final titles = [
    'bike',
    'boat',
    'bus',
    'car',
    'railway',
    'run',
    'subway',
    'transit',
    'walk'
  ];
  static final icons = [
    Icons.directions_bike,
    Icons.directions_boat,
    Icons.directions_bus,
    Icons.directions_car,
    Icons.directions_railway,
    Icons.directions_run,
    Icons.directions_subway,
    Icons.directions_transit,
    Icons.directions_walk
  ];

  ///

  Widget listSection(BuildContext context){
    return Column(
        children:<Widget>[
          new Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(icons[index]),
                    title: Text(titles[index]),
                  ),
                );
              },
            ),
          )
        ]
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