import 'package:meta/meta.dart';
import 'package:mpango/models/redux/state/user/UserState.dart';

@immutable
class AppState {
  final UserState userState;

  AppState({@required this.userState});

  factory AppState.initial() {
    return AppState(
      userState: UserState.initial(),
    );
  }

  AppState copyWith({
    UserState userState,
  }) {
    return AppState(
      userState: userState ?? this.userState,
    );
  }

  @override
  int get hashCode =>
      userState.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState && userState == other.userState;
}