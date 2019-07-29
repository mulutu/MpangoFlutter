import 'Account.dart';
import 'dart:convert';
import 'AccountList.dart';

class ChartOfAccounts {
  String accountGroupTypeName;
  String accountGroupTypeCode;
  int accountGroupTypeId;
  //List<Account> listOfAccounts;
  AccountList listOfAccounts;
  //dynamic listOfAccounts = new List<Account>();

  ChartOfAccounts({
    this.accountGroupTypeName,
    this.accountGroupTypeCode,
    this.accountGroupTypeId,
    this.listOfAccounts,
  });

  factory ChartOfAccounts.fromJson(Map<String, dynamic> json){
    return new ChartOfAccounts(
        accountGroupTypeName: json['accountGroupTypeName'],
        accountGroupTypeCode: json['accountGroupTypeCode'],
        accountGroupTypeId: json ['accountGroupTypeId'],
        listOfAccounts: new AccountList.fromJson(json['listOfAccounts'])
    );
  }
}