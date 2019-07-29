import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

//part 'transaction.g.dart';

@JsonSerializable()

class Transaction{
  int userId;
  int accountId;
  int transactionTypeId;
  double amount;
  String description;
  DateTime transactionDate;
  int projectId;
  String projectName;

  Transaction({
    this.userId,
    this.accountId,
    this.transactionTypeId,
    this.amount,
    this.description,
    this.transactionDate,
    this.projectId,
    this.projectName,
  });

  //Transaction.empty(); contact.dob = new DateFormat.yMd().parseStrict(map['dob']);
  //Map<String, dynamic> toJson() => _$TransactionToJson(this);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    //var formatter = new DateFormat('yyyy-MM-dd');
    return new Transaction(
        userId: json['userId'],
        accountId: json['accountId'],
        transactionTypeId: json['transactionTypeId'],
        amount: json['amount'],
        description: json['description'],
        transactionDate: new DateFormat("dd-MM-yyyy").parseStrict(json['transactionDate']), //
        //transactionDate: formatter.format(dateTimeFromString(json['transactionDate'].),//new DateFormat.yMd().parseStrict(json['transactionDate']),
        projectId: json['projectId'],
        projectName: json['projectName'],
    );
  }

  //void set setUserId(int userId) {
    //this.userId = userId;
  //}
}