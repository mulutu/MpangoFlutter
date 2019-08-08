import 'package:flutter/material.dart';
import 'models/TaskService.dart';
import 'models/Task.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'FloatingButtonsProjects.dart';
import 'package:sliver_calendar/sliver_calendar.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart';
import 'dart:math';
import 'package:intl/intl.dart';



class TasksPage extends StatefulWidget {
  createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  List<CalendarEvent> events = <CalendarEvent>[];
  List<Task> tasks = <Task>[];
  Location loc;

  Future<void> _getTasksRecords() async {
    Iterable<Task> tasks_ = await TaskService().fetchTasks2();
    print('TASKS: ${tasks_.length}');
    setTasks(tasks_);
  }

  void setTasks(Iterable<Task> res) {
    List<Task> games = res.toList();
    games.sort((a, b) => a.taskDate.compareTo(b.taskDate));
    tasks = games;
  }

  @override
  List<CalendarEvent> getEvents(DateTime start, DateTime end) {
    if (tasks == null) {
      _getTasksRecords();
    }
    if (tasks == null) {
      return [];
    }
    if (events.length == 0) {
      for (int i = 0; i < tasks.length; i++) {
        events.add(new CalendarEvent(
            index: i,
            instant: new TZDateTime.from(tasks[i].taskDate, local),
            instantEnd: new TZDateTime.from(tasks[i].taskDate, local).add(new Duration(minutes: 1))
          )
        );
      }
    }
    return events;
  }


  @override
  void initState() {
    super.initState();
    _getTasksRecords();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: new AppBar(title: new Text( 'Tasks' ),),
      body: new Column(
        children: <Widget>[
          FutureBuilder<String>(
            //future: TaskService.fetchTasks(), //FlutterNativeTimezone.getLocalTimezone(),
            future: FlutterNativeTimezone.getLocalTimezone(),
            builder: (BuildContext context, AsyncSnapshot<String> tz) {
              if (tz.hasData) {
                loc = getLocation(tz.data);
                TZDateTime nowTime = new TZDateTime.now(loc);
                return new Expanded(
                  child: new CalendarWidget(
                    initialDate: nowTime,
                    //initialDate: new TZDateTime.now(local),
                    //beginningRangeDate: nowTime.subtract(new Duration(days: 62)),
                    //endingRangeDate: nowTime.add(new Duration(days: 62)),
                    //location: loc,
                    buildItem: buildItem,
                    getEvents: getEvents,
                    bannerHeader: new AssetImage("assets/images/calendarheader.png"),
                    monthHeader: new AssetImage("assets/images/calendarbanner.jpg"),
                    weekBeginsWithDay: 1, // Sunday = 0, Monday = 1, Tuesday = 2, ..., Saturday = 6
                  ),
                );
              } else {
                return new Center(
                  //child: new Text("Getting the timezone..."),
                  child: CircularProgressIndicator(),
                );
              }
            }
          )
        ]
      ),
      floatingActionButton: FloatingButtonsProjects(),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget buildItem(BuildContext context, CalendarEvent e) {
    var date = DateFormat.yMd().format(tasks[e.index].taskDate);
    return new Card(
      child: new ListTile(
        title: new Text("${date}"),
        subtitle: new Text("${tasks[e.index].taskName}"),
        leading: const Icon(Icons.gamepad),
      ),
    );
  }

  Widget ListViewTasks_({List<Task> tasks}) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, position) {
          return GestureDetector(
            onTap: () => _onTapItem(context, tasks[position]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(height: 1.0),
                ListTile(
                  title: Text('${tasks[position].taskName}', ),
                  subtitle: Text('${tasks[position].description}', ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            )
          );
        }
      ),
    );
  }

  void _onTapItem(BuildContext context, Task task) {
    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(transaction.amount.toString() + ' - ' + transaction.amount.toString())));
    //Navigator.push( context, new MaterialPageRoute( builder: (context) => DetailsPage(newTrxObject:project))  );
  }
}