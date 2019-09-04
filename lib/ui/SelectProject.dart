import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:mpango/models/Project.dart';
import 'package:mpango/models/ProjectService.dart';
import 'package:mpango/models/Transaction.dart';
import 'package:mpango/CreateTransactionPage.dart';


class SelectProject extends StatefulWidget {
  var newTrxObj;
  SelectProject({ this.newTrxObj  });
  @override
  _SelectProjectState createState() => new _SelectProjectState();
}

class _SelectProjectState extends State<SelectProject>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Transaction newTransaction =  new Transaction();

  List<String> _checked = <String>[];
  List<int> _checkedId = <int>[];


  List<Project> projectsList = <Project>[];
  List<String> projectNames = <String>[];

  _getProjectsRecords() async {
    List<Project> projects_ = await ProjectService().fetchProjects();
    setState(() {
      for (Project record in projects_) {
        this.projectsList.add(record);
        this.projectNames.add(record.ProjectName);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    newTransaction = widget.newTrxObj;
    _getProjectsRecords();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Project"),
      ),
      key: _scaffoldKey,
      body: _body(),
    );
    //
  }

  Widget _body(){
    return new SafeArea(
      top: false,
      bottom: false,
      child: new Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 14.0, top: 14.0),
              child: Text("Active Projects:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                ),
              ),
            ),
            CheckboxGroup(
              labels: projectNames,
              onChange: (bool isChecked, String label, int index) => print("isChecked: $isChecked   label: $label  index: $index"),
              //onSelected: (List<String> checked) => print("checked: ${checked.toString()}"),
              onSelected: (List<String> checked) => _checked = checked,
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
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      _checkedId.clear();
      for (Project pro in projectsList) {
        if(_checked.contains(pro.ProjectName)){
          _checkedId.add(pro.id);
        }
      }
      newTransaction.selectedProjects = _checkedId;
      print("checked projects IDS: ${_checkedId.toString()}");
      print("TRX checked projects IDS: ${newTransaction.selectedProjects.toString()}");
      print('========================================');
      print('Submitting to back end...');
      Navigator.pop(context, newTransaction);
    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    print(message);
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }

}