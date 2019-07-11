import 'Project.dart';

class ProjectSummaryRecordList {
  List<Project> records = new List();

  ProjectSummaryRecordList({
    this.records
  });

  factory ProjectSummaryRecordList.fromJson(List<dynamic> parsedJson) {

    List<Project> records = new List<Project>();

    records = parsedJson.map((i) => Project.fromJson(i)).toList();

    return new ProjectSummaryRecordList(
      records: records,
    );
  }
}