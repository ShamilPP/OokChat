// google_auth_event.dart
abstract class GoogleAuthEvent {}

class GoogleAuthSignInRequested extends GoogleAuthEvent {}

class GoogleAuthSignOutRequested extends GoogleAuthEvent {}
