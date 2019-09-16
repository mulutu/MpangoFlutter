import 'package:flutter/material.dart';
import 'models/Transaction.dart';
import 'CreateTransactionPage.dart';
import 'package:unicorndial/unicorndial.dart';

class FloatingButtonsTransactions extends StatelessWidget {
  FloatingButtonsTransactions();

  @override
  Widget build(BuildContext context) {

    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: "+ Expense",
      currentButton: FloatingActionButton(
        heroTag: "add_expense",
        backgroundColor: Colors.redAccent,
        mini: true,
        child: Icon(Icons.train),
        onPressed: () {
          Transaction newTransaction =  new Transaction();
          newTransaction.transactionTypeId=1;
          Navigator.push(
            context,
            new MaterialPageRoute( builder: (context) => CreateTransactionPage(newTrxObject:newTransaction))
          );
        },
      )));

    childButtons.add(UnicornButton(
      hasLabel: true,
      labelText: "+ Income",
      currentButton: FloatingActionButton(
        heroTag: "add_income",
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


    return UnicornDialer(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
      parentButtonBackground: Colors.redAccent,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add),
      childButtons: childButtons);
  }
}