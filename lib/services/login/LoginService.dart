//import 'package:mpango/models/login/LoginResponse.dart';
import 'package:mpango/models/User.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:mpango/helpers/Constants.dart';

Future<User> login(String username, String password) async {
  User user = new User(username, password, "", false, 0, "", "");
  return Future.delayed(const Duration(milliseconds: 2000), () async {
    if (username.isEmpty || password.isEmpty) {
      Error error = new Error();
      return Future.error(error);
    } else {
      final response_ = await http.post(
          LOGIN_URL,
          headers: HEADERS,
          body: _toJson(user));
      final String res = response_.body;
      final int statusCode = response_.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        //throw new Exception("Error while fetching data");
        Error error = new Error();
        return Future.error("Error while fetching data");
      } else {
        return _fromJson(response_.body);
      }
      //{"id":1,"firstName":"Jackson","lastName":"Mulutu","email":"mulutujackson@gmail.com","username":"mulutujackson@gmail.com","password":"$2a$10$iBnWBvfV42aBPcEwEdl0SOskUUKvuScfp0QoMpupRXIj3jWNR.TSq","enabled":true,"confirmationToken":"be62e12b-192c-4863-b153-901b3a92c00c","roles":null,"userType":"ROLE_USER"}
      //LoginResponse response = new LoginResponse(userId: 0, username: "ghfh sdgfhsdj");
      //return _fromJson(response_.body);
      //return response;
    }
  });
}

User _fromJson(String responseBody) {
  Map<String, dynamic> map = json.decode(responseBody);
  var response = new User("", "", "", false, 0, "", "");
  response.userId = map['id'];
  response.firstName = map['firstName'];
  return response;
}

String _toJson(User user) {
  var mapData = new Map();
  //mapData["email"] = user.username;
  mapData["username"] = user.username;
  mapData["password"] = user.password;
  String jsondata = json.encode(mapData);
  return jsondata;
}

/*
{
"id": 1,
"firstName": "Jackson",
"lastName": "Mulutu",
"email": "mulutujackson@gmail.com",
"username": "mulutujackson@gmail.com",
"password": "$2a$10$iBnWBvfV42aBPcEwEdl0SOskUUKvuScfp0QoMpupRXIj3jWNR.TSq",
"enabled": true,
"confirmationToken": "be62e12b-192c-4863-b153-901b3a92c00c",
"roles": null,
"userType": "ROLE_USER"
} */
