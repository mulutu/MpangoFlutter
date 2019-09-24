import 'package:flutter/material.dart';
import 'package:mpango/models/Project.dart';
import 'package:mpango/models/Task.dart';
import 'package:mpango/models/ProjectService.dart';
import 'package:mpango/models/TaskService.dart';
import 'package:mpango/utils/PieChartPage.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  List<Task> tasks = <Task>[];
  List<Task> tasksToday = <Task>[];

  //List<Tab> tabList = List();
  TabController tabController;

  // get list of tasks
  _getTasksRecords() async {
    List<Task> tasks_ = await TaskService().fetchTasks2();
    setState(() {
      for (Task record in tasks_) {
        this.tasks.add(record);
      }
    });
  }

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    _getTasksRecords();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          pieCharts,
          tasksList(context),
          //accountsList,
          //farmsList,
        ],
      ),
      //floatingActionButton: FloatingButtons(),
    );
  }

  Widget tasksList(BuildContext context) {
    return SizedBox(
      child: new Column(
        children: <Widget>[
          new Text("Your Tasks"),
          new Container(
            decoration:
                new BoxDecoration(color: Theme.of(context).primaryColor),
            //decoration: new BoxDecoration(color: Colors.red),
            //padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            child: new TabBar(
              controller: tabController,
              indicatorColor: Colors.pink,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  text: "TODAY",
                ),
                Tab(
                  text: "TOP 5",
                ),
              ],
            ),
          ),
          new Container(

            margin: const EdgeInsets.all(5),
            child: new TabBarView(
              controller: tabController,
              children: <Widget>[
                todaysTask(context),
                allTask(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget todaysTask(BuildContext context) {
    if (tasks == null) {
      _getTasksRecords();
    }

    for (Task task in tasks) {
      DateTime taskDate = task.taskDate;
      DateTime today = DateTime.now();

      int diffDays = taskDate.compareTo(today);
      bool isSame = (diffDays == 0);

      if (isSame) {
        tasksToday.add(task);
      }
    }

    return Container(
        constraints: BoxConstraints.expand(
          height: Theme.of(context).textTheme.display1.fontSize * 1.1 + 100.0,
        ),
        child: ListView.builder(
            itemCount: tasksToday.length,
            //padding: const EdgeInsets.all(5),
            itemBuilder: (context, position) {
              return ListTile(
                title: Text(
                  '${tasksToday[position].taskName}',
                ),
                subtitle: Text(
                  '${tasksToday[position].taskName}',
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              );
            }
        )
    );
  }


  Widget allTask(BuildContext context) {
    if (tasks == null) {
      _getTasksRecords();
    }

    return Container(
        child: ListView.builder(
            itemCount: tasks.length,
            //padding: const EdgeInsets.all(5),
            itemBuilder: (context, position) {
              return ListTile(
                title: Text(
                  '${tasks[position].taskName}',
                ),
                subtitle: Text(
                  '${tasks[position].taskName}',
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              );
            }
        )
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
}
