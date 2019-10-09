class LoginResponse {
  int userId;
  String username;
  String password;
  String userType;
  bool userEnabled;
  String firstName;
  String lastName;

  LoginResponse({
    this.userId,
    this.username,
    this.password,
    this.userType,
    this.userEnabled,
    this.firstName,
    this.lastName,
  });

  LoginResponse.map(dynamic obj) {
    this.userId = obj["id"];
    this.username = obj["username"];
    this.password = obj["password"];
    this.userType = obj["userType"];
    this.userEnabled = obj["enabled"];
    this.firstName = obj["firstName"];
    this.lastName = obj["lastName"];
  }

  int get _userId => userId;
  String get _username => username;
  String get _password => password;
  String get _userType => userType;
  bool get _userEnabled => userEnabled;
  String get _firstName => firstName;
  String get _lastName => lastName;

  set _userId(int value) {
    userId = value;
  }
  set _username(String value) {
    username = value;
  }
  set _password(String value) {
    password = value;
  }
  set _userType(String value) {
    userType = value;
  }
  set _userEnabled(bool value) {
    userEnabled = value;
  }
  set _firstName(String value) {
    firstName = value;
  }
  set _lastName(String value) {
    lastName = value;
  }

}