import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class Task{
  int taskId;
  int projectId;
  String taskName;
  String description;
  DateTime taskDate;
  int priority;
  bool active;

  Task({
    this.taskId,
    this.projectId,
    this.taskName,
    this.description,
    this.taskDate,
    this.priority,
    this.active,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return new Task(
      taskId: json['taskId'],
      projectId: json['projectId'],
      taskName: json['taskName'],
      description: json['description'],
      priority: json['priority'],
      taskDate: new DateFormat("dd-MM-yyyy").parseStrict(json['taskDate']), //
      active: json['active'],
    );
  }

}