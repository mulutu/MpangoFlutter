import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:mpango/models/Project.dart';
import 'package:mpango/models/ProjectService.dart';
import 'package:mpango/models/Transaction.dart';
import 'package:mpango/CreateTransactionPage.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:mpango/models/Transaction.dart';
import 'package:mpango/models/Project.dart';
import 'package:mpango/models/Account.dart';
import 'package:mpango/HomePage.dart';
import 'package:mpango/models/ChartOfAccounts.dart';
import 'package:mpango/models/TransactionService.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mpango/models/ProjectService.dart';
import 'package:mpango/models/ChartOfAccountsService.dart';
import 'package:mpango/ui/SelectProject.dart';
import 'package:mpango/ui/SelectDate.dart';

class SelectAccount extends StatefulWidget {
  var newTrxObj;
  SelectAccount({ this.newTrxObj  });
  @override
  _SelectAccountState createState() => new _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<Account> accountsList = <Account>[];
  List<String> accountNames = <String>[];
  String _picked = "";


  Transaction newTransaction =  new Transaction();

  List<String> _checked = <String>[];
  List<int> _checkedId = <int>[];

  _getAccountsRecords() async {
    List<ChartOfAccounts> accounts_ = await ChartOfAccountsService().fetchChartOfAccounts();
    setState(() {
      for (ChartOfAccounts record in accounts_) {
        List<Account> list = record.listOfAccounts.records;
        if(list.length > 0 ) {
          this.accountsList.addAll(list);
        }
      }
      for (Account record in this.accountsList) {
        this.accountNames.add(record.accountName);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    newTransaction = widget.newTrxObj;
    _getAccountsRecords();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Account"),
      ),
      key: _scaffoldKey,
      body: _body(),
    );
  }

  Widget _body(){
    return new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
            key: _formKey,
            child: ListView(
                children: <Widget>[
                  ///CUSTOM RADIOBUTTON GROUP
                  Container(
                    padding: const EdgeInsets.only(left: 14.0, top: 14.0, bottom: 14.0),
                    child: Text("Active Accounts",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),
                    ),
                  ),

                  RadioButtonGroup(
                    orientation: GroupedButtonsOrientation.VERTICAL,
                    margin: const EdgeInsets.only(left: 12.0),
                    onSelected: (String selected) => setState((){
                      _picked = selected;

                      for (Account pro in accountsList) {
                        if(selected.compareTo(pro.accountName) == 0) {
                          print('selected account: ${pro.accountName}');
                          int selectedAccountId = pro.id;

                          newTransaction.accountId = selectedAccountId;

                          Navigator.pop(context, newTransaction);
                        }
                      }

                    }),
                    labels: accountNames,
                    //picked: _picked,
                    /*itemBuilder: (Radio rb, Text txt, int i){
                      return Column(
                        children: <Widget>[
                          Icon(Icons.public),
                          rb,
                          txt,
                        ],
                      );
                    },*/
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
      //form.save(); //This invokes each onSaved event

      print("checked projects: ${_checked.toString()}");

      _checkedId.clear();

      for (Account pro in accountsList) {
        if(_checked.contains(pro.accountName)){
          _checkedId.add(pro.id);
          print('selected account: ${pro.accountName}');
        }
      }

      newTransaction.selectedProjects = _checkedId;

      print("checked projects IDS: ${_checkedId.toString()}");
      print("TRX checked projects IDS: ${newTransaction.selectedProjects.toString()}");

      print('Form save called, newContact is now up to date...');
      //print('Amount: ${newTransaction.amount}');
      //print('Description: ${newTransaction.description}');
      //print('Date: ${newTransaction.transactionDate}');
      //print('ProjectId: ${newTransaction.projectId}');
      //print('AccountId: ${newTransaction.accountId}');
      //print('UserId: ${newTransaction.userId}');
      //print('TransactionTypeId: ${newTransaction.transactionTypeId}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');

      Navigator.pop(context, newTransaction);

      /*Navigator.push(
          context,
          new MaterialPageRoute( builder: (context) => CreateTransactionPage(newTrxObject:newTransaction, ))
      );*/

      //var transactionService = new TransactionService();
      //transactionService.createTransaction(newTransaction)
      //    .then((value) => showMessage('New transaction created for ${value.message}!', Colors.blue)
      //);


    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    print(message);
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));

    //Navigator.push(
    //context,
    //new MaterialPageRoute( builder: (context) => HomePage())
    //);
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }


}