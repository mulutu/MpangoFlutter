import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'ServiceResponse.dart';

import 'Transaction.dart';

class TransactionService {
  //static const _serviceUrl = 'http://mockbin.org/echo';
  static const _serviceUrl = "http://45.56.73.81:8084/Mpango/api/v1/transactions";
  static final _headers = {'Content-Type': 'application/json'};

  Future<ServiceResponse> createTransaction(Transaction transaction) async {
    print('Posting date : ${transaction.transactionDate}');
    try {
      String json = _toJson(transaction);
      final response = await http.post(_serviceUrl, headers: _headers, body: json);
      var c = _fromJson(response.body);
      return c;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return null;
    }
  }

  ServiceResponse _fromJson(String responseBody) {
    Map<String, dynamic> map = json.decode(responseBody);
    var response = new ServiceResponse();
    response.statusId = map['status'];
    response.message = map['message'];
    return response;
  }

  String _toJson(Transaction transaction) {
    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(transaction.transactionDate);

    print('Posting date formated : ${formatted}');

    var mapData = new Map();

    //mapData["transactionDate"] = new DateFormat.yMd().format(transaction.transactionDate);
    //mapData["amount"] = new DateFormat.yMd().format(contact.dob);
    mapData["transactionDate"] = formatted;
    mapData["amount"] = transaction.amount;
    mapData["accountId"] = transaction.accountId;
    mapData["projectId"] = transaction.projectId;
    mapData["description"] = transaction.description;
    mapData["userId"] = transaction.userId;
    mapData["transactionTypeId"] = transaction.transactionTypeId;

    String jsondata = json.encode(mapData);

    return jsondata;
  }
}