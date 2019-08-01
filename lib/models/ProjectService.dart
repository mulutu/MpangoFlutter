import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'ServiceResponse.dart';
import 'Project.dart';
import 'ProjectsList.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ProjectService {
  static const _serviceUrlGetUserProjects = "http://45.56.73.81:8084/Mpango/api/v1/users/1/projects/summary";
  static const _serviceUrlCreateProject = "http://45.56.73.81:8084/Mpango/api/v1/projects";
  static final _headers = {'Content-Type': 'application/json'};

  /////////// FETCH PROJECTS /////////////////
  static Future<List<Project>> fetchProjects_static() async {
    final response = await http.get(_serviceUrlGetUserProjects, headers: _headers,);
    print('response.body : ${response.body}');
    return compute(parseProjects, response.body);
  }

  Future<List<Project>> fetchProjects() async {
    final response = await http.get(_serviceUrlGetUserProjects, headers: _headers,);
    print('response.body : ${response.body}');
    return compute(parseProjects, response.body);
  }

  static List<Project> parseProjects(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Project>((json) => Project.fromJson(json)).toList();
  }

  //////////// CREATE PROJECT ////////////////
  Future<ServiceResponse> createProject(Project project) async {
    try {
      String json = _toJson(project);
      final response = await http.post(_serviceUrlCreateProject, headers: _headers, body: json);
      var c = _fromJson(response.body);
      return c;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return null;
    }
  }
  String _toJson(Project project) {
    var mapData = new Map();
    mapData["userId"] = project.UserId;
    mapData["farmId"] = project.FarmId;
    mapData["projectName"] = project.ProjectName;
    mapData["description"] = project.Description;
    String jsondata = json.encode(mapData);
    return jsondata;
  }

  ServiceResponse _fromJson(String responseBody) {
    Map<String, dynamic> map = json.decode(responseBody);
    var response = new ServiceResponse();
    response.statusId = map['status'];
    response.message = map['message'];
    return response;
  }
}