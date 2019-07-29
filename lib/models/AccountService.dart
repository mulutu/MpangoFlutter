import 'AccountList.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'Account.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'Project.dart';
import 'package:flutter/foundation.dart';


class AccountService {

  static const _serviceUrlGetUserAccounts = "http://45.56.73.81:8084/Mpango/api/v1/users/1/coa";
  static const _serviceUrlCreateAccount = "http://45.56.73.81:8084/Mpango/api/v1/users/1/projects";
  static final _headers = {'Content-Type': 'application/json'};

  /////////// FETCH PROJECTS /////////////////
  Future<List<Account>> fetchAccounts() async {
    final response = await http.get(_serviceUrlGetUserAccounts, headers: _headers,);
    print('response.body-accounts : ${response.body}');
    return compute(parseAccounts, response.body);
  }
  static List<Account> parseAccounts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Account>((json) => Account.fromJson(json)).toList();
  }




  /*Future<String> _loadRecordsAsset() async {
    return await rootBundle.loadString('assets/data/records.json');
  }

  Future<AccountList> loadRecords() async {
    String jsonString = await _loadRecordsAsset();
    final jsonResponse = json.decode(jsonString);
    AccountList records = new AccountList.fromJson(jsonResponse);
    return records;
  }*/
}
