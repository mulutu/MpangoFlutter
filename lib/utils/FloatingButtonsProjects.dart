import 'package:flutter/material.dart';
import '../models/Project.dart';
import '../models/Transaction.dart';
import '../models/Task.dart';
import '../CreateTransactionPage.dart';
import '../CreateTaskPage.dart';
import 'package:unicorndial/unicorndial.dart';
import '../CreateProjectPage.dart';

class FloatingButtonsProjects extends StatelessWidget {
  FloatingButtonsProjects();

  @override
  Widget build(BuildContext context) {

    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: "+ Task",
      currentButton: FloatingActionButton(
        heroTag: "add_task",
        backgroundColor: Colors.redAccent,
        mini: true,
        child: Icon(Icons.train),
        onPressed: () {
          Task newTask =  new Task();
          Navigator.push(
            context,
            new MaterialPageRoute( builder: (context) => CreateTaskPage(newTaskObject:newTask))
          );
        },
      )));

    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: "+ Farm",
      currentButton: FloatingActionButton(
        heroTag: "add_farm",
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

    return UnicornDialer(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
      parentButtonBackground: Colors.redAccent,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add),
      childButtons: childButtons);
  }
}