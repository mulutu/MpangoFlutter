import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

class Farm{
  int id;
  int UserId;
  String FarmName;
  int Size;
  String Location;
  //DateTime DateCreated;
  String Description;

  Farm({
    this.id,
    this.UserId,
    this.FarmName,
    this.Size,
    this.Location,
    //this.DateCreated,
    this.Description,
  });

  factory Farm.fromJson(Map<String, dynamic> json) {
    return new Farm(
      id: json['id'],
      UserId: json['userId'],
      FarmName: json['farmName'],
      Size: json['size'],
      Location: json['location'],
      //DateCreated: new DateFormat("dd-MM-yyyy").parseStrict(json['dateCreated']), //
      Description: json['description'],
    );
  }

}