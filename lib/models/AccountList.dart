import 'Account.dart';

class AccountList {
  List<Account> records = new List();

  AccountList({
    this.records
  });

  factory AccountList.fromJson(List<dynamic> parsedJson) {

    List<Account> records = new List<Account>();

    records = parsedJson.map((i) => Account.fromJson(i)).toList();

    print('accountList Class records : ${records.length}');

    return new AccountList(
      records: records,
    );
  }
}