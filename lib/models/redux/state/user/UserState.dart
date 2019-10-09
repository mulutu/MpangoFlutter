import 'package:meta/meta.dart';
import 'package:mpango/models/login/LoginResponse.dart';
import 'package:mpango/models/User.dart';

@immutable
class UserState {
  final bool isLoading;
  final bool loginError;
  //final LoginResponse user;
  final User user;

  UserState({
    @required this.isLoading,
    @required this.loginError,
    @required this.user,
  });

  factory UserState.initial() {
    return new UserState(isLoading: false, loginError: false, user: null);
  }

  UserState copyWith({bool isLoading, bool loginError, User user}) {
  //UserState copyWith({bool isLoading, bool loginError, LoginResponse user}) {
    return new UserState(
        isLoading: isLoading ?? this.isLoading, loginError: loginError ?? this.loginError, user: user ?? this.user);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserState &&
              runtimeType == other.runtimeType &&
              isLoading == other.isLoading &&
              loginError == other.loginError &&
              user == other.user;

  @override
  int get hashCode => isLoading.hashCode ^ user.hashCode;
}