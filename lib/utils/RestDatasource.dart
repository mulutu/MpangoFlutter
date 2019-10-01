import 'dart:async';

import 'package:mpango/utils/NetworkUtil.dart';
import 'package:mpango/models/User.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://45.56.73.81:8084/Mpango/api/v1/";
  static final LOGIN_URL = BASE_URL + "/login";
  static final _API_KEY = "somerandomkey";

  Future<User> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "username": username,
      "password": password
    }).then((dynamic res) {
      print(res.toString());
      if(res["error"]) throw new Exception(res["error_msg"]);
      return new User.map(res["user"]);
    });
  }
}