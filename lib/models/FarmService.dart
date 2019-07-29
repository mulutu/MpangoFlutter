import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'ServiceResponse.dart';
import 'package:flutter/foundation.dart';
import 'Farm.dart';

class FarmService {
  static const _serviceUrl = "http://45.56.73.81:8084/Mpango/api/v1/users/1/farms";
  static final _headers = {'Content-Type': 'application/json'};


  /////////// FETCH FARMS /////////////////
  Future<List<Farm>> fetchFarms() async {
    final response = await http.get(_serviceUrl, headers: _headers,);
    print('response.body : ${response.body}');
    return compute(parseFarms, response.body);
  }
  static List<Farm> parseFarms(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Farm>((json) => Farm.fromJson(json)).toList();
  }


  Future<ServiceResponse> createFarm(Farm farm) async {
    try {
      String json = _toJson(farm);
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

  String _toJson(Farm farm) {
    var formatter = new DateFormat('dd-MM-yyyy');
    //String formatted = formatter.format(farm.DateCreated);
    var mapData = new Map();

    //mapData["transactionDate"] = new DateFormat.yMd().format(transaction.transactionDate);
    //mapData["amount"] = new DateFormat.yMd().format(contact.dob);
    //mapData["transactionDate"] = formatted;
    //mapData["amount"] = farm.amount;
    //mapData["accountId"] = farm.accountId;
    //mapData["projectId"] = farm.projectId;
    //mapData["description"] = farm.description;
    //mapData["userId"] = farm.userId;
    //mapData["transactionTypeId"] = farm.transactionTypeId;

    String jsondata = json.encode(mapData);

    return jsondata;
  }
}