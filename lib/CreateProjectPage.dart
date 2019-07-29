import 'package:flutter/material.dart';
import 'models/Transaction.dart';
import 'models/Project.dart';
import 'models/Account.dart';
import 'HomePage.dart';
import 'models/ChartOfAccounts.dart';
import 'models/ProjectService.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'models/FarmService.dart';
import 'models/Farm.dart';

class CreateProjectPage extends StatefulWidget {
  var newProjectObject;
  CreateProjectPage({ this.newProjectObject  });

  @override
  _CreateProjectPageState createState() => new _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Project newProject =  new Project();

  List<Farm> farmsList = <Farm>[];
  Farm farmObj;
  String _farmName = '';

  _getFarmsRecords() async {
    List<Farm> farms_ = await FarmService().fetchFarms();
    setState(() {
      for (Farm record in farms_) {
        this.farmsList.add(record);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    newProject = widget.newProjectObject;
    newProject.UserId=1;

    _getFarmsRecords();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Create Project"),
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
              new TextFormField(
                decoration: const InputDecoration( icon: const Icon(Icons.person), hintText: 'Project Name', labelText: 'Project', ),
                keyboardType: TextInputType.text,
                //inputFormatters: [ WhitelistingTextInputFormatter.digitsOnly,  ],
                validator: (val) => val.isEmpty ? 'Project Name is required' : null,
                onSaved: (val) => newProject.ProjectName = val,
              ),
              new FormField(
                builder: (FormFieldState state) {
                  if( farmsList != null){
                    return InputDecorator(
                      decoration: InputDecoration(  icon: const Icon(Icons.color_lens),  labelText: 'Select Farm',  ),
                      isEmpty: _farmName == '',
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton<Farm>(
                          value: farmObj,
                          isDense: true,
                          onChanged: (Farm newValue) {
                            setState(() {
                              farmObj = newValue;
                              _farmName = newValue.FarmName;
                              newProject.FarmId = newValue.id;
                              state.didChange(newValue.FarmName);
                            });
                          },
                          items: farmsList.map((Farm farm) {
                            return new DropdownMenuItem<Farm>( value: farm, child: new Text(farm.FarmName),  );
                          }).toList(),
                        )
                      )
                    );
                  }
                }
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: 'Enter the description',
                  labelText: 'Description',
                ),
                maxLines: 2,
                keyboardType: TextInputType.multiline,
                validator: (val) => val.isEmpty ? 'Description is required' : null,
                onSaved: (val) => newProject.Description = val, // as double,
              ),
              new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  //onPressed: null,
                  onPressed: _submitForm,
                )
              ),
            ]
          )
        )
      )
    );
  }



  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('UserId: ${newProject.UserId}');
      print('FarmId: ${newProject.FarmId}');
      print('Project Name: ${newProject.ProjectName}');
      print('Description: ${newProject.Description}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');

      var projectService = new ProjectService();
      projectService.createProject(newProject)
          .then((value) => showMessage('New Project created for ${value.message}!', Colors.blue)
      );


    }
  }


  void showMessage(String message, [MaterialColor color = Colors.red]) {
    print(message);
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));

    Navigator.push(
        context,
        new MaterialPageRoute( builder: (context) => HomePage())
    );
  }



}