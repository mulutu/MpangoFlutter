import 'package:flutter/material.dart';
import 'models/Transaction.dart';
import 'DetailsPage.dart';
import 'package:intl/intl.dart';
import 'models/TransactionService.dart';
import 'FloatingButtonsTransactions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'ui/EditTransactionPage.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPage createState() => new _TransactionsPage(); //TransactionsPage();
}
class _TransactionsPage extends State<TransactionsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  FutureBuilder<List<Transaction>>(
        future: TransactionService.fetchTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return snapshot.hasData
            ? ListViewTransactions_(transactions: snapshot.data)
            : Center(child: CircularProgressIndicator());
        }
      ),
      floatingActionButton: FloatingButtonsTransactions(),
    );
  }

  Widget ListViewTransactions_({List<Transaction> transactions}) {
    var formatter = new DateFormat('yyyy-MM-dd');
    return Container(
      padding: const EdgeInsets.all(5),
      child:
      ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {

          String formatted = formatter.format(transactions[index].transactionDate);
          var trxType = transactions[index].transactionTypeId;

          return Slidable(
            key: ValueKey(index),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'Archive',
                color: Colors.blue,
                icon: Icons.archive,
              ),
              IconSlideAction(
                caption: 'Share',
                color: Colors.indigo,
                icon: Icons.share,
              ),
            ],
            secondaryActions: <Widget>[
              /*IconSlideAction(
                caption: 'More',
                color: Colors.grey.shade200,
                icon: Icons.more_horiz,
              ),*/
              IconSlideAction(
                caption: 'Edit Transaction',
                color: Colors.indigo,
                icon: Icons.edit,
                onTap: () { _editTransaction(context, transactions[index]); },

              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () { _deleteTransaction(context, transactions[index]); },
              ),
            ],
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (trxType==1) ? Colors.red: Colors.green,
                child:  (trxType==1) ? Text('E'): Text('I') ,
                foregroundColor: Colors.white,
              ),
              title: new Row(
                  children: <Widget>[
                    new Expanded(child: new Text('${transactions[index].amount}', textAlign:TextAlign.left, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0,  color:  (trxType==1) ? Colors.red: Colors.green, )), ),
                    new Expanded(child:new Text('${formatted}', textAlign:TextAlign.right, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14.0, color: Colors.grey), ), ),
                  ]
              ),
              subtitle: new Container(
                  padding: const EdgeInsets.only(left: 0, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 1),
                          child: Text( '${transactions[index].description}', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 15.0,), ),
                        ),
                        //Text('${transactions[index].projectName}', style: TextStyle( color: Colors.grey[500], ), ),
                      ]
                  )
              ),
            ),
          );
        },
      ),



      // test on pull function
      //child: LiquidPullToRefresh(
        //key: _refreshIndicatorKey,	// key if you want to add
        //onRefresh: null,	// refresh callback

        /*child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, position) {
            String formatted = formatter.format(transactions[position].transactionDate);
            var trxType = transactions[position].transactionTypeId;
            return GestureDetector(
              onTap: () => _onTapItem(context, transactions[position]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(height: 1.0),
                  Container(
                    padding: const EdgeInsets.only(bottom:2, left:5, top:5),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(child: new Text('${transactions[position].amount}', textAlign:TextAlign.left, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0,  color:  (trxType==1) ? Colors.red: Colors.green, )), ),
                        new Expanded(child:new Text('${formatted}', textAlign:TextAlign.right, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13.0, color: Colors.grey), ), ),
                      ]
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 1),
                          child: Text( '${transactions[position].description}', style: TextStyle( fontWeight: FontWeight.bold, ), ),
                        ),
                        Text('${transactions[position].projectName}', style: TextStyle( color: Colors.grey[500], ), ),
                      ]
                    )
                  ),
                ],
              )
            );
          }
        ),*/


      //) // test on pull function


    );
  }

  void _deleteTransaction(BuildContext context,  Transaction trx){
    var transactionService = new TransactionService();
    transactionService.deleteTransaction(trx).then((value) => showMessage('New transaction delete for ${value.message}!', Colors.blue));
    setState(() {  });
  }

  void _editTransaction(BuildContext context,  Transaction trx){
    Navigator.push(
        context,
        new MaterialPageRoute( builder: (context) => EditTransactionPage(newTrxObject:trx))
    );
  }

  void _onTapItem(BuildContext context, Transaction transaction) {
    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(transaction.amount.toString() + ' - ' + transaction.amount.toString())));
    Navigator.push( context, new MaterialPageRoute( builder: (context) => DetailsPage(newTrxObject:transaction))  );
  }


  void showMessage(String message, [MaterialColor color = Colors.red]) {
    print(message);
    //_scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));

  }

}