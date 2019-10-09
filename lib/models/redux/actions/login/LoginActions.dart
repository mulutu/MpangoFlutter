import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:mpango/models/login/LoginResponse.dart';
import 'package:mpango/services/login/LoginService.dart';
import 'package:mpango/models/navigation/navigation.dart';
import 'package:mpango/models/User.dart';

ThunkAction loginUser(String username, String password) {
  return (Store store) async {
    new Future(() async{
      store.dispatch(new StartLoadingAction());
      login(username, password).then((user) {
        store.dispatch(new LoginSuccessAction(user));
        Keys.navKey.currentState.pushNamed(Routes.homeScreen);
      }, onError: (error) {
        print('LOGIN FAILED ${error}');
        store.dispatch(new LoginFailedAction());
      });
    });
  };
}

class StartLoadingAction {
  StartLoadingAction();
}

class LoginSuccessAction {
  //final LoginResponse user;
  final User user;
  LoginSuccessAction(this.user);
}

class LoginFailedAction {
  LoginFailedAction();
}