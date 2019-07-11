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



  //void _getProjectSummaryRecords() async {
  //ProjectSummaryRecordList records = await ProjectSummaryRecordService().loadRecords();
  //List<Project> records = await ProjectSummaryRecordService().fetchProject();

  //setState(() {
  //for (Project record in records) {
  // this._records.records.add(record);
  // this._filteredRecords.records.add(record);
  // }
  // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      backgroundColor: Colors.white,
      body: _buildBody(context),
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: _makeBottom(context),
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
          height: 400.0,
          child: Card(
            child: PageView(
              reverse: false,
              controller: pageController,
              scrollDirection: true ? Axis.horizontal : Axis.vertical,
              pageSnapping: true,
              children: projects //_filteredRecords.records
                  .map((data) => _buildPageItem(context, data))
                  .toList(),
            ),
          ),
        )
      ],
      //children: <Widget>[_topSection, listSection],
    );
  }

  static List<charts.Series<LinearSales, int>> _createSampleData(Project record) {
    final data = [
      new LinearSales(0, record.totalExpenses.toInt()),
      new LinearSales(1, record.totalIncomes.toInt()),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  Widget _buildPageItem(BuildContext context, Project record) {

    final List<charts.Series> seriesList = _createSampleData(record);

    return Container(
        key: ValueKey(record.ProjectName),
        child: Column(
          children:[
            ListTile(
              title: Text(record.ProjectName, style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(record.totalIncomes.toString()),
              leading: Icon(
                Icons.restaurant_menu,
                color: Colors.blue[500],
              ),
            ),
            Container(
              height: 300.0,
              child: Card(
                child: new charts.PieChart(seriesList, animate: false,
                    // Configure the width of the pie slices to 60px. The remaining space in
                    // the chart will be left as a hole in the center.
                    defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60)),
              ),
            ),
          ],
        ));
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

  LinearSales(this.year, this.sales);
}
