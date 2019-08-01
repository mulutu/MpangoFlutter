import 'package:flutter/material.dart';
import 'models/Task.dart';
import 'TasksPage.dart';
import 'models/ProjectService.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'models/TaskService.dart';
import 'models/Project.dart';

class CreateTaskPage extends StatefulWidget {
  var newTaskObject;
  CreateTaskPage({ this.newTaskObject  });

  @override
  _CreateTaskPageState createState() => new _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Task newTask =  new Task();

  List<Project> projectsList = <Project>[];
  Project projectObj;
  String _projectName = '';

  _getProjectsRecords() async {
    List<Project> projects_ = await ProjectService().fetchProjects();
    setState(() {
      for (Project record in projects_) {
        this.projectsList.add(record);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    newTask = widget.newTaskObject;
    newTask.priority=1;
    newTask.active=true;

    _getProjectsRecords();
  }


  final TextEditingController _controller = new TextEditingController();
  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    var result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2200), //new DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return FittedBox(
          child: Theme(
            child: child,
            data: ThemeData(
              primaryColor: Colors.purple[300],
            ),
          ),
        );
      }
    );

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Create Task"),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[

              // Task Name
              new TextFormField(
                decoration: const InputDecoration( icon: const Icon(Icons.person), hintText: 'Task Name', labelText: 'Task', ),
                keyboardType: TextInputType.text,
                validator: (val) => val.isEmpty ? 'Task Name is required' : null,
                onSaved: (val) => newTask.taskName = val,
              ),

              // Select Project
              new FormField(
                builder: (FormFieldState state) {
                  if( projectsList != null){
                    return InputDecorator(
                      decoration: InputDecoration(  icon: const Icon(Icons.color_lens),  labelText: 'Select Project',  ),
                      isEmpty: _projectName == '',
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton<Project>(
                          value: projectObj,
                          isDense: true,
                          onChanged: (Project newValue) {
                            setState(() {
                              projectObj = newValue;
                              _projectName = newValue.ProjectName;
                              newTask.projectId = newValue.id;
                              state.didChange(newValue.ProjectName);
                            });
                          },
                          items: projectsList.map((Project project) {
                            return new DropdownMenuItem<Project>( value: project, child: new Text(project.ProjectName),  );
                          }).toList(),
                        )
                      )
                    );
                  }
                }
              ),

              // Task date
              InkWell(
                onTap: () {
                  _chooseDate(context, _controller.text);
                },
                child: IgnorePointer(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.calendar_today),
                      hintText: 'Enter date of task',
                      labelText: 'Task Date',
                    ),
                    keyboardType: TextInputType.datetime,
                    controller: _controller,
                    validator: (val) => isValidDob(val) ? null : 'Not a valid date',
                    //onSaved: (val) => newTransaction.transactionDate = new DateFormat("yyyy-MM-dd").parse(val), // as double,
                    onSaved: (val) => newTask.taskDate= new DateFormat.yMd().parse(val),
                  ),
                )
              ),

              // Enter description
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: 'Enter the description',
                  labelText: 'Description',
                ),
                maxLines: 2,
                keyboardType: TextInputType.multiline,
                validator: (val) => val.isEmpty ? 'Description is required' : null,
                onSaved: (val) => newTask.description = val, // as double,
              ),

              // Submit Button
              new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  onPressed: _submitForm,
                )
              ),

            ]
          )
        )
      )
    );
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime(2200));
  }



  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('taskName: ${newTask.taskName}');
      print('projectId: ${newTask.projectId}');
      print('taskDate: ${newTask.taskDate}');
      print('description: ${newTask.description}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');

      var taskService = new TaskService();
      taskService.createTask(newTask)
          .then((value) => showMessage('New Task created for ${value.message}!', Colors.blue)
      );

    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    print(message);
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
    Navigator.push(
        context,
        new MaterialPageRoute( builder: (context) => TasksPage())
    );
  }

}