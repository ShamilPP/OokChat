// auth_event.dart
abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthSignedOut extends AuthEvent {}
