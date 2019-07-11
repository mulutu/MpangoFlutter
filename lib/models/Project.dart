import 'package:decimal/decimal.dart';



class Project {
  //int id;
  //int UserId;
  //int FarmId;
  //String farmName;
  String ProjectName;
  //String DateCreated;
  //double expectedOutput;
  //double actualOutput;
  //int unitId;
  //String unitDescription;
  //String Description;
  double totalExpenses;
  double totalIncomes;

  //double temp = weatherData['main']['temp'].toDouble();
  // I/flutter ( 4378): Exception: FormatException: Invalid date format

  //I/flutter ( 4378): 10-03-2019

  Project({
      //this.id,
      //this.UserId,
      //this.FarmId,
      //this.farmName,
      this.ProjectName,
      //this.DateCreated,
      //this.expectedOutput,
      //this.actualOutput,
      //this.unitId,
      //this.unitDescription,
      //this.Description,
      this.totalExpenses,
      this.totalIncomes
    });

  factory Project.fromJson(Map<String, dynamic> json) {
    return new Project(
        //id: json['id'],
        //UserId: json['userId'],
        //FarmId: json['farmId'],
        //farmName: json['photo'],
        ProjectName: json['projectName'],
        //DateCreated: json['dateCreated'],
        //expectedOutput: double.parse(json['expectedOutput']),
        //actualOutput: double.parse(json['actualOutput']),
        //unitId: json['unitId'],
        //unitDescription: json['unitDescription'],
        //Description: json['description'],
        totalExpenses: json['totalExpeses'].toDouble(),
        totalIncomes: json['totalIncomes'].toDouble()
    );
  }
}
