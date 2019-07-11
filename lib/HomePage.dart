import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'models/Project.dart';
import 'models/ProjectSummaryRecordList.dart';
//import 'models/ProjectSummaryRecordService.dart';

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Widget _appBarTitle = new Text(appTitle);
  ProjectSummaryRecordList _records = new ProjectSummaryRecordList();
  ProjectSummaryRecordList _filteredRecords = new ProjectSummaryRecordList();

  int _currentIndex = 0;
  final List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    _records.records = new List();
    _filteredRecords.records = new List();
    //_getProjectSummaryRecords();
  }

  String url = "http://45.56.73.81:8084/Mpango/api/v1/users/1/projects/summary";
  Future<List<Project>> fetchProjects() async {
    final response = await http.get(url);
    //await http.get(url, headers: {"Accept": "application/json"});
    return compute(parseProjects, response.body);
  }

  // A function that converts a response body into a List<Photo>.
  static List<Project> parseProjects(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Project>((json) => Project.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _buildBar(context),
      backgroundColor: Colors.white,
      body: BottomNavBarApp(),//_buildBody(context), //BottomNavBarApp(),//
      resizeToAvoidBottomPadding: false,
      //bottomNavigationBar: _makeBottom(context),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      elevation: 0.1,
      backgroundColor: Colors.teal, //primarySwatch: Colors.teal,
      centerTitle: true,
      title: _appBarTitle,
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<List<Project>>(
        future: fetchProjects(),
        builder: (context, projectSummary) {
          if (projectSummary.hasError) print(projectSummary.error);

          return projectSummary.hasData
              ? ProjectsList(projects: projectSummary.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  ProjectsList({List<Project> projects}) {
    final PageController pageController = PageController(initialPage: 0);
    return Column(
      children: <Widget>[
        new SizedBox(
          height: 202.0,
          child: Container(
            //height:190.0,
            //margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0,),
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



  Widget _buildPageItem_(BuildContext context, Project record) {
    final List<charts.Series> seriesList = _createSampleData(record);
    return Center(
        child: Card(
      child: new Container(
          padding: EdgeInsets.all(2.0),
          child: new Column(children: <Widget>[
            //new Expanded(child: new Text("Bemerkung", style: TextStyle(fontWeight: FontWeight.w500),)),
            new Container(height: 4.0),
            new ListTile(
                title: Text(record.ProjectName,
                    style: TextStyle(fontWeight: FontWeight.w500))),
            new Container(height: 10.0),
            new Row(
              children: <Widget>[
                Container(
                    height: 30.0,
                    alignment: FractionalOffset.centerLeft,
                    child: new Text(record.totalIncomes.toString())),
                new Container(height: 14.0),
                Container(
                    height: 30.0,
                    alignment: FractionalOffset.centerLeft,
                    child: new Text(record.totalExpenses.toString())),
              ],
            ),
            //new Expanded(child:new charts.PieChart(seriesList, animate: false, defaultRenderer: new charts.ArcRendererConfig(arcWidth: 30))),
          ])),
    ));
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

  Widget _makeBottom(BuildContext context) {
    return Container(
      height: 55.0,
      child: BottomAppBar(
        color: Colors.teal, //Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.blur_on, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.hotel, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.account_box, color: Colors.white),
              onPressed: () {},
            )
          ],
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
