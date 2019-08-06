import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'ServiceResponse.dart';
import 'package:flutter/foundation.dart';
import 'Task.dart';

class TaskService {

  static const _serviceUrl = "http://45.56.73.81:8084/Mpango/api/v1/users/1/tasks";
  static const _serviceUrlCreateTask = "http://45.56.73.81:8084/Mpango/api/v1/tasks";

  static final _headers = {'Content-Type': 'application/json'};


  /////////// FETCH FARMS /////////////////
  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(_serviceUrl, headers: _headers,);
    print('response.body : ${response.body}');
    return compute(parseTasks, response.body);
  }
  Future<List<Task>> fetchTasks2() async {
    final response = await http.get(_serviceUrl, headers: _headers,);
    print('response.body : ${response.body}');
    return compute(parseTasks, response.body);
  }
  static List<Task> parseTasks(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Task>((json) => Task.fromJson(json)).toList();
  }


  Future<ServiceResponse> createTask(Task task) async {
    try {
      String json = _toJson(task);
      final response = await http.post(_serviceUrlCreateTask, headers: _headers, body: json);
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

  String _toJson(Task task) {
    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(task.taskDate);
    var mapData = new Map();

    mapData["projectId"] = task.projectId;
    mapData["taskName"] = task.taskName;
    mapData["description"] = task.description;
    mapData["taskDate"] = formatted;
    mapData["priority"] = task.priority;
    mapData["active"] = task.active;
    //mapData["description"] = farm.description;
    //mapData["userId"] = farm.userId;
    //mapData["transactionTypeId"] = farm.transactionTypeId;

    String jsondata = json.encode(mapData);

    return jsondata;
  }
}