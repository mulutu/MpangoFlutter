import 'package:flutter/material.dart';
import 'models/Project.dart';
import 'models/ProjectService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'FloatingButtonsTransactions.dart';

class HomePagePieChart extends StatelessWidget {
  HomePagePieChart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          pieCharts,
          accountsList,
          farmsList,
        ],
      ),
      //floatingActionButton: FloatingButtons(),
    );
  }

  final farmsList = SizedBox(
    height: 256,
    child: Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Farms',  style: TextStyle(fontWeight: FontWeight.w500)),
            //subtitle: Text('My City, CA 99984'),
            //leading: Icon(
              //Icons.restaurant_menu,
              //color: Colors.blue[500],
            //),
          ),
          Divider(),
          ListTile(
            title: Text('Gachuriri', ),
            trailing: Icon(Icons.keyboard_arrow_right),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text('Bungoma'),
            trailing: Icon(Icons.keyboard_arrow_right),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('+ FARM'),
                  onPressed: () { /* ... */ },
                ),
                FlatButton(
                  child: const Text('VIEW ALL'),
                  onPressed: () { /* ... */ },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  final accountsList = SizedBox(
    height: 256,
    child: Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Accounts',  style: TextStyle(fontWeight: FontWeight.w500)),
            //subtitle: Text('My City, CA 99984'),
            //leading: Icon(
            //Icons.restaurant_menu,
            //color: Colors.blue[500],
            //),
          ),
          Divider(),
          ListTile(
            title: Text('Wages', ),
            trailing: Icon(Icons.keyboard_arrow_right),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: Text('Pesticides'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // do something
            },
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
          ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('+ ACCOUNT'),
                  onPressed: () { /* ... */ },
                ),
                FlatButton(
                  child: const Text('VIEW ALL'),
                  onPressed: () { /* ... */ },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  final pieCharts = FutureBuilder<List<Project>>(
      future: ProjectService().fetchProjects(), //fetchProjects(),
      builder: (context, projectSummary) {
        if (projectSummary.hasError) print(projectSummary.error);

        return projectSummary.hasData
            ? ProjectsList(projects: projectSummary.data, context: context )
            : Center(child: CircularProgressIndicator());
      }
  );

  static ProjectsList({List<Project> projects, BuildContext context}) {
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

  static Widget _buildPageItem(BuildContext context, Project record) {
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

  static List<charts.Series<LinearSales, int>> _createSampleData(Project record) {
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