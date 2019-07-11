import 'ProjectSummaryRecordList.dart';
import 'Project.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

class ProjectSummaryRecordService {
  String url = "http://45.56.73.81:8084/Mpango/api/v1/users/1/projects/summary";

  Future<List<Project>> fetchProject() async {
    final response = await http.get(url, headers: {"Accept": "application/json"});
    return compute(parsePhotos, response.body);

    /*if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      //return Project.fromJson(json.decode(response.body));
      return Project.fromJson(json.decode(response.body));
      //return await rootBundle.loadString(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }*/
  }

  // A function that converts a response body into a List<Photo>.
  List<Project> parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Project>((json) => Project.fromJson(json)).toList();
  }

  /*Future<ProjectSummaryRecordList> loadRecords() async {
    String jsonString = await fetchProject();
    //final jsonResponse = json.decode(jsonString);
    final jsonResponse = json.decode(jsonString).cast<Map<String, dynamic>>();
    ProjectSummaryRecordList records = new ProjectSummaryRecordList.fromJson(jsonResponse);
    return records;
  }*/
}
