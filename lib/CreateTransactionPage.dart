import 'package:flutter/material.dart';
import 'models/Transaction.dart';
import 'models/Project.dart';
import 'models/Account.dart';
import 'HomePage.dart';
import 'models/ChartOfAccounts.dart';
import 'models/TransactionService.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'models/ProjectService.dart';
import 'models/ChartOfAccountsService.dart';
import 'ui/SelectProject.dart';

class CreateTransactionPage extends StatefulWidget {
  var newTrxObject;
  CreateTransactionPage({ this.newTrxObject  });

  /*CreateTransactionPage(this.newTrxObject) {
    if (newTrxObject == null) {
      throw ArgumentError("member of MemberWidget cannot be null. Received: '$newTrxObject'");
    }
  }*/

  @override
  _CreateTransactionState createState() => new _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransactionPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Transaction newTransaction =  new Transaction();

  final TextEditingController _controllerProjects = new TextEditingController();

  String pageTitle = "";

  Project projectObj;
  List<Project> projectsList = <Project>[];
  String _projectName = '';

  List<Account> accountsList = <Account>[];
  String _accountName = '';
  Account accountObj;

  _getProjectsRecords() async {
    List<Project> projects_ = await ProjectService().fetchProjects();
    setState(() {
      for (Project record in projects_) {
        this.projectsList.add(record);
      }
    });
  }

  _getAccountsRecords() async {
    List<ChartOfAccounts> accounts_ = await ChartOfAccountsService().fetchChartOfAccounts();
    setState(() {
      for (ChartOfAccounts record in accounts_) {
        List<Account> list = record.listOfAccounts.records;
        if(list.length > 0 ) {
          this.accountsList.addAll(list);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    newTransaction = widget.newTrxObject;
    newTransaction.userId = 1;
    //newTransaction.accountId = 3;
    //newTransaction.transactionTypeId = 1;
    _getProjectsRecords();
    _getAccountsRecords();

    if(newTransaction.transactionTypeId==0){
      pageTitle = "New Income";
    }else{
      pageTitle = "New Expense";
    }
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
        lastDate: new DateTime.now(),
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
        title: new Text(pageTitle),
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
                decoration: const InputDecoration( icon: const Icon(Icons.person), hintText: 'Enter transaction amount', labelText: 'Amount', ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                //inputFormatters: [ WhitelistingTextInputFormatter.digitsOnly,  ],
                validator: (val) => val.isEmpty ? 'Amount is required' : null,
                onSaved: (val) => newTransaction.amount = double.parse(val), // as double,
                textInputAction: TextInputAction.next,
              ),
              InkWell(
                onTap: () {
                  _awaitReturnValueFromSelectProjectScreen(context);
                  /*Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new SelectProject(newTrxObj:newTransaction)),
                  );*/
                },
                child: IgnorePointer(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.calendar_today),
                      hintText: 'Select Project',
                      labelText: 'Select Project',
                    ),
                    keyboardType: TextInputType.text,
                    controller: _controllerProjects,
                    textInputAction: TextInputAction.next,
                    //onChanged: (v)=>setState((){_text=v;}),
                    //validator: (val) => isValidDob(val) ? null : 'Not a valid name',
                    //onSaved: (val) => newTransaction.transactionDate = new DateFormat("yyyy-MM-dd").parse(val), // as double,
                    //onSaved: (val) => newTransaction.transactionDate = new DateFormat.yMd().parse(val),
                  ),
                )
              ),
              /*new FormField(
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
                                    //newTransaction.projectId = _userProjects.records.indexOf(newValue);
                                    newTransaction.projectId = newValue.id;
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
              ),*/
              new FormField(
                  builder: (FormFieldState state) {
                    if( accountsList != null){
                      return InputDecorator(
                          decoration: InputDecoration(  icon: const Icon(Icons.color_lens),  labelText: 'Select Account',  ),
                          isEmpty: _accountName == '',
                          child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<Account>(
                                value: accountObj,
                                isDense: true,
                                onChanged: (Account newValue) {
                                  setState(() {
                                    accountObj = newValue;
                                    _accountName = newValue.accountName;
                                    newTransaction.accountId= newValue.id;
                                    state.didChange(newValue.accountName);
                                  });
                                },
                                items: accountsList.map((Account account) {
                                  return new DropdownMenuItem<Account>( value: account, child: new Text(account.accountName),  );
                                }).toList(),
                              )
                          )
                      );
                    }
                  }
              ),
              InkWell(
                  onTap: () {
                    _chooseDate(context, _controller.text);
                  },
                child: IgnorePointer(
                    child: new TextFormField(
                        decoration: const InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: 'Enter date of transaction',
                        labelText: 'Date',
                      ),
                      keyboardType: TextInputType.datetime,
                      controller: _controller,
                      validator: (val) => isValidDob(val) ? null : 'Not a valid date',
                      //onSaved: (val) => newTransaction.transactionDate = new DateFormat("yyyy-MM-dd").parse(val), // as double,
                      onSaved: (val) => newTransaction.transactionDate = new DateFormat.yMd().parse(val),
                  ),
                )
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
                onSaved: (val) => newTransaction.description = val, // as double,
              ),
              new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  //onPressed: null,
                  onPressed: _submitForm,
                )
              ),
            ],
          )
        )
      )
    );
  }

  void _awaitReturnValueFromSelectProjectScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectProject(newTrxObj:newTransaction),
        ));
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      newTransaction = result;
      _controllerProjects.text = newTransaction.selectedProjects.toString();
    });

    print("CREATETRX TRX checked projects IDS: ${newTransaction.selectedProjects.toString()}");

  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('Amount: ${newTransaction.amount}');
      print('Description: ${newTransaction.description}');
      print('Date: ${newTransaction.transactionDate}');
      print('ProjectId: ${newTransaction.projectId}');
      print('AccountId: ${newTransaction.accountId}');
      print('UserId: ${newTransaction.userId}');
      print('TransactionTypeId: ${newTransaction.transactionTypeId}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');

      var transactionService = new TransactionService();
      transactionService.createTransaction(newTransaction)
          .then((value) => showMessage('New transaction created for ${value.message}!', Colors.blue)
      );


    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    print(message);
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
    Navigator.push(
        context,
        new MaterialPageRoute( builder: (context) => HomePage())
    );
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }
}