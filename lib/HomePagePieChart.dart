import 'package:flutter/material.dart';
import 'package:mpango/models/Project.dart';
import 'package:mpango/models/ProjectService.dart';
import 'package:mpango/utils/PieChartPage.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

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
            title: Text('Farms', style: TextStyle(fontWeight: FontWeight.w500)),
            //subtitle: Text('My City, CA 99984'),
            //leading: Icon(
            //Icons.restaurant_menu,
            //color: Colors.blue[500],
            //),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Gachuriri',
            ),
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
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('+ FARM'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                FlatButton(
                  child: const Text('VIEW ALL'),
                  onPressed: () {
                    /* ... */
                  },
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
            title:
                Text('Accounts', style: TextStyle(fontWeight: FontWeight.w500)),
            //subtitle: Text('My City, CA 99984'),
            //leading: Icon(
            //Icons.restaurant_menu,
            //color: Colors.blue[500],
            //),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Wages',
            ),
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
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('+ ACCOUNT'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                FlatButton(
                  child: const Text('VIEW ALL'),
                  onPressed: () {
                    /* ... */
                  },
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
            ? ProjectsList(projects: projectSummary.data, context: context)
            : Container(
                constraints: BoxConstraints.expand(
                  height: Theme.of(context).textTheme.display1.fontSize * 1.1 +
                      260.0,
                ),
                child: new Center(child: CircularProgressIndicator()));
      });

  static ProjectsList({List<Project> projects, BuildContext context}) {
    final PageController pageController = PageController(initialPage: 0);
    return Center(
        child: Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 260.0,
      ),
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return PieChartPage(projectObj: projects[index]);
        },
        itemCount: projects.length,
        //pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    ));
  }

  static ProjectsListxxx({List<Project> projects, BuildContext context}) {
    final PageController pageController = PageController(initialPage: 0);
    return Center(
        child: Container(
      constraints: BoxConstraints.expand(
        height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 260.0,
      ),
      child: PageView(
        reverse: false,
        controller: pageController,
        scrollDirection: true ? Axis.horizontal : Axis.vertical,
        pageSnapping: true,
        children: projects
            .map((project) => PieChartPage(projectObj: project))
            .toList(),
      ),
    ));
  }
}
