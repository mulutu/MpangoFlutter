import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:mpango/models/login/LoginResponse.dart';
import 'package:mpango/services/login/LoginService.dart';
import 'package:mpango/models/navigation/navigation.dart';

ThunkAction loginUser(String username, String password) {
  return (Store store) async {
    new Future(() async{
      store.dispatch(new StartLoadingAction());
      login(username, password).then((loginResponse) {
        store.dispatch(new LoginSuccessAction(loginResponse));
        Keys.navKey.currentState.pushNamed(Routes.homeScreen);
      }, onError: (error) {
        store.dispatch(new LoginFailedAction());
      });
    });
  };
}

class StartLoadingAction {
  StartLoadingAction();
}

class LoginSuccessAction {
  final LoginResponse user;

  LoginSuccessAction(this.user);
}

class LoginFailedAction {
  LoginFailedAction();
}