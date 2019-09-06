import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'ServiceResponse.dart';
import 'Transaction.dart';
import 'package:flutter/foundation.dart';

class TransactionService {

  /////////// FETCH PROJECTS /////////////////
  static const _serviceUrlGetUserTransactions = "http://45.56.73.81:8084/Mpango/api/v1/users/1/transactions";
  static const _serviceUrl = "http://45.56.73.81:8084/Mpango/api/v1/transactions";
  static final _headers = {'Content-Type': 'application/json'};

  static Future<List<Transaction>> fetchTransactions() async {
    final response = await http.get(_serviceUrlGetUserTransactions, headers: _headers,);
    return compute(parseTransactions, response.body);
  }
  static List<Transaction> parseTransactions(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Transaction>((json) => Transaction.fromJson(json)).toList();
  }

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
    mapData["selectedProjectIds"] = transaction.selectedProjects;

    String jsondata = json.encode(mapData);

    return jsondata;
  }
}