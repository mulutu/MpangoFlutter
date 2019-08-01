import 'package:flutter/material.dart';
import 'models/TaskService.dart';
import 'models/Task.dart';
import 'FloatingButtonsProjects.dart';

class TasksPage extends StatefulWidget {
  createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text( 'Tasks' ),),
      body: FutureBuilder<List<Task>>(
        future: TaskService.fetchTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return snapshot.hasData
            ? ListViewTasks_(tasks: snapshot.data)
            : Center(child: CircularProgressIndicator());
        }
      ),
      floatingActionButton: FloatingButtonsProjects(),
      resizeToAvoidBottomPadding: false,
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