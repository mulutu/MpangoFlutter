import 'Project.dart';

class ProjectsList {
  List<Project> records = new List();

  ProjectsList({
    this.records
  });

  factory ProjectsList.fromJson(List<dynamic> parsedJson) {
    List<Project> records = new List<Project>();
    records = parsedJson.map((i) => Project.fromJson(i)).toList();
    return new ProjectsList(
      records: records,
    );
  }
}