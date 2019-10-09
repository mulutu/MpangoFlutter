import 'package:redux/redux.dart';
import 'package:mpango/models/login/LoginResponse.dart';
import 'package:mpango/models/User.dart';
import 'package:mpango/models/redux/actions/login/LoginActions.dart';
import 'package:mpango/AppState.dart';

class LoginViewModel {
  final bool isLoading;
  final bool loginError;
  //final LoginResponse user;
  final User user;

  final Function(String, String) login;

  LoginViewModel({
    this.isLoading,
    this.loginError,
    this.user,
    this.login,
  });

  static LoginViewModel fromStore(Store<AppState> store) {
    return LoginViewModel(
      isLoading: store.state.userState.isLoading,
      loginError: store.state.userState.loginError,
      user: store.state.userState.user,
      login: (String username, String password) {
        store.dispatch(loginUser(username, password));
      },
    );
  }
}