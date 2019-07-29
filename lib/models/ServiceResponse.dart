import 'package:decimal/decimal.dart';

class ServiceResponse {
  int statusId;
  String message;

  ServiceResponse({
    this.statusId,
    this.message,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return new ServiceResponse(
        statusId: json['status'],
        message: json['message'],
    );
  }
}
