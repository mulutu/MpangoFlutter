import 'package:flutter/material.dart';
import 'package:mpango/models/Transaction.dart';
import 'package:mpango/DetailsPage.dart';
import 'package:intl/intl.dart';
import 'package:mpango/models/TransactionService.dart';
import 'package:mpango/utils/FloatingButtonsTransactions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mpango/ui/EditTransactionPage.dart';
import 'package:extended_tabs/extended_tabs.dart';

class TransactionsPage extends StatefulWidget {
  @override
  _TransactionsPage createState() =>
      new _TransactionsPage(); //TransactionsPage();
}

class _TransactionsPage extends State<TransactionsPage>
    with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TabBar(
            unselectedLabelColor: Colors.teal,
            //indicator: ColorTabIndicator(Colors.white),
            labelColor: Colors.black,
            tabs: [
              Tab(text: "Incomes", ),
              Tab(text: "Expenses",),
            ],
            controller: tabController,
          ),
          Expanded(
            child: ExtendedTabBarView(
              children: <Widget>[
                displayTransactions(0),
                displayTransactions(1),
              ],
              controller: tabController,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingButtonsTransactions(),
    );
  }

  Widget displayTransactions(int type) {
    return FutureBuilder<List<Transaction>>(
        future: TransactionService.fetchTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<Transaction> incomes = <Transaction>[];
          List<Transaction> expenses = <Transaction>[];

          for (Transaction record in snapshot.data) {
            if (record.transactionTypeId == 0) {
              incomes.add(record);
            } else {
              expenses.add(record);
            }
          }

          if (type == 0) {
            return displayList(incomes);
          } else {
            return displayList(expenses);
          }
        });
  }

  Widget displayList(List<Transaction> transactions) {
    var formatter = new DateFormat('yyyy-MM-dd');
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          String formatted =
              formatter.format(transactions[index].transactionDate);
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
                onTap: () {
                  _editTransaction(context, transactions[index]);
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  _deleteTransaction(context, transactions[index]);
                },
              ),
            ],
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (trxType == 1) ? Colors.red : Colors.green,
                child: (trxType == 1) ? Text('E') : Text('I'),
                foregroundColor: Colors.white,
              ),
              title: new Row(children: <Widget>[
                new Expanded(
                  child: new Text('${transactions[index].amount}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: (trxType == 1) ? Colors.red : Colors.green,
                      )),
                ),
                new Expanded(
                  child: new Text(
                    '${formatted}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0,
                        color: Colors.grey),
                  ),
                ),
              ]),
              subtitle: new Container(
                  padding: const EdgeInsets.only(left: 0, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 1),
                          child: Text(
                            '${transactions[index].description}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        //Text('${transactions[index].projectName}', style: TextStyle( color: Colors.grey[500], ), ),
                      ])),
            ),
          );
        },
      ),
    );
  }

  void _deleteTransaction(BuildContext context, Transaction trx) {
    var transactionService = new TransactionService();
    transactionService.deleteTransaction(trx).then((value) => showMessage(
        'New transaction delete for ${value.message}!', Colors.blue));
    setState(() {});
  }

  static void _editTransaction(BuildContext context, Transaction trx) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => EditTransactionPage(newTrxObject: trx)));
  }

  void _onTapItem(BuildContext context, Transaction transaction) {
    //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(transaction.amount.toString() + ' - ' + transaction.amount.toString())));
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => DetailsPage(newTrxObject: transaction)));
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    print(message);
    //_scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}
