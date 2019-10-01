import 'package:mpango/AppState.dart';
import 'user/UserReducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    userState: userReducer(state.userState, action),
  );
}