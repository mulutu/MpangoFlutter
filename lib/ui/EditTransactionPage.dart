import 'package:flutter/material.dart';
import 'package:mpango/models/Transaction.dart';
import 'package:mpango/models/Project.dart';
import 'package:mpango/models/Account.dart';
import 'package:mpango/HomePage.dart';
import 'package:mpango/models/TransactionService.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:mpango/ui/SelectProject.dart';
import 'package:mpango/ui/SelectDate.dart';
import 'package:mpango/ui/SelectAccount.dart';

class EditTransactionPage extends StatefulWidget {
  var newTrxObject;
  EditTransactionPage({ this.newTrxObject  });

  @override
  _EditTransactionState createState() => new _EditTransactionState();
}

class _EditTransactionState extends State<EditTransactionPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _controllerAmount = new TextEditingController();
  final TextEditingController _controllerProjects = new TextEditingController();
  final TextEditingController _controllerAccounts = new TextEditingController();
  final TextEditingController _controllerDate = new TextEditingController();
  final TextEditingController _controllerDesc = new TextEditingController();

  Transaction newTransaction =  new Transaction();

  String pageTitle = "";
  Project projectObj;
  List<Project> projectsList = <Project>[];
  List<Account> accountsList = <Account>[];
  Account accountObj;

  @override
  void initState() {
    super.initState();
    newTransaction = widget.newTrxObject;

    _controllerAmount.text = newTransaction.amount.toString();
    _controllerProjects.text = newTransaction.projectName;
    _controllerAccounts.text = newTransaction.accountId.toString();
    _controllerDate.text = newTransaction.transactionDate.toString();
    _controllerDesc.text = newTransaction.description;

    if(newTransaction.transactionTypeId==0){
      pageTitle = "Edit Income";
    }else{
      pageTitle = "Edit Expense";
    }
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
                decoration: const InputDecoration( icon: const Icon(Icons.person), hintText: 'Amount', labelText: 'Amount', ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) => val.isEmpty ? 'Amount is required' : null,
                onSaved: (val) => newTransaction.amount = double.parse(val), // as double,
                textInputAction: TextInputAction.next,
                controller: _controllerAmount,
              ),

              InkWell(
                onTap: () { _awaitReturnValueFromSelectProjectScreen(context); },
                child: IgnorePointer(
                  child: new TextFormField(
                    decoration: const InputDecoration( icon: const Icon(Icons.calendar_today), hintText: 'Select Project', labelText: 'Select Project', ),
                    controller: _controllerProjects,
                    textInputAction: TextInputAction.next,
                  ),
                )
              ),

              InkWell(
                onTap: () { _awaitReturnValueFromSelectAccountScreen(context); },
                child: IgnorePointer(
                  child: new TextFormField(
                    decoration: const InputDecoration( icon: const Icon(Icons.calendar_today), hintText: 'Select Account', labelText: 'Select Account', ),
                    controller: _controllerAccounts,
                    textInputAction: TextInputAction.next,
                  ),
                )
              ),

              InkWell(
                onTap: () { _awaitReturnValueFromSelectDateScreen(context); },
                child: IgnorePointer(
                    child: new TextFormField(
                      decoration: const InputDecoration( icon: const Icon(Icons.calendar_today), hintText: 'Enter date of transaction', labelText: 'Date', ),
                      keyboardType: TextInputType.datetime,
                      controller: _controllerDate,
                  ),
                )
              ),

              new TextFormField(
                decoration: const InputDecoration( icon: const Icon(Icons.email), hintText: 'Enter the description', labelText: 'Description', ),
                maxLines: 2,
                keyboardType: TextInputType.multiline,
                validator: (val) => val.isEmpty ? 'Description is required' : null,
                onSaved: (val) => newTransaction.description = val, // as double,
                controller: _controllerDesc,
              ),

              new Container(
                padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                child: new RaisedButton(
                  child: const Text('Submit'),
                  onPressed: _submitForm,
                )
              ),

            ],
          )
        )
      )
    );
  }


  void _awaitReturnValueFromSelectAccountScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectAccount(newTrxObj:newTransaction),
        ));
    setState(() {
      newTransaction = result;
      _controllerAccounts.text = newTransaction.accountId.toString();
    });
  }

  void _awaitReturnValueFromSelectDateScreen(BuildContext context) async {
    var formatter = new DateFormat('yyyy-MM-dd');
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectDate(newTrxObj:newTransaction),
        ));
    setState(() {
      newTransaction = result;
      _controllerDate.text = formatter.format(newTransaction.transactionDate);
    });
  }

  void _awaitReturnValueFromSelectProjectScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectProject(newTrxObj:newTransaction),
        ));
    setState(() {
      newTransaction = result;
      _controllerProjects.text = newTransaction.selectedProjects.toString();
    });
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