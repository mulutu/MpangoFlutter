class User {
  String _username;
  String _password;
  String _userType;
  bool _userEnabled;
  int _userId;
  String _firstName;
  String _lastName;

  User(this._username, this._password, this._userType, this._userEnabled,
      this._userId, this._firstName, this._lastName);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._password = obj["password"];

    this._userType = obj["userType"];
    this._userEnabled = obj["enabled"];
    this._userId = obj["id"];
    this._firstName = obj["firstName"];
    this._lastName = obj["lastName"];
  }

  String get username => _username;
  String get password => _password;
  String get userType => _userType;
  bool get userEnabled => _userEnabled;
  int get userId => _userId;
  String get firstName => _firstName;
  String get lastName => _lastName;

  set username(String value) {
    _username = value;
  }
  set password(String value) {
    _password = value;
  }
  set userType(String value) {
    _userType = value;
  }
  set userEnabled(bool value) {
    _userEnabled = value;
  }
  set userId(int value) {
    _userId = value;
  }
  set firstName(String value) {
    _firstName = value;
  }
  set lastName(String value) {
    _lastName = value;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;
    map["userType"] = _userType;
    map["userEnabled"] = _userEnabled;
    map["userId"] = _userId;
    map["firstName"] = _firstName;
    map["lastName"] = _lastName;

    return map;
  }
}
