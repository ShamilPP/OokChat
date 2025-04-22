abstract class UserState {}

class UserInitial extends UserState {}

class LastSeenUpdating extends UserState {}

class LastSeenUpdated extends UserState {}

class LastSeenUpdateFailed extends UserState {
  final String error;
  LastSeenUpdateFailed(this.error);
}
