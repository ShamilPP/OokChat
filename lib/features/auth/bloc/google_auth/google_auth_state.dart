// google_auth_state.dart
import '../../../../model/user.dart';

abstract class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthSignedIn extends GoogleAuthState {
  final User user;

  GoogleAuthSignedIn({required this.user});
}

class GoogleAuthSignedOut extends GoogleAuthState {}

class GoogleAuthError extends GoogleAuthState {
  final String errorMessage;

  GoogleAuthError({required this.errorMessage});
}

class GoogleAuthLoading extends GoogleAuthState {}
