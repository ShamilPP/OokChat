// auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/local_repo.dart';
import '../../repo/user_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  final LocalRepository localRepository;

  AuthBloc({required this.userRepository, required this.localRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignedOut>(_onAuthSignedOut);
  }

  // Event to check if user is already authenticated
  void _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(Duration(milliseconds: 500));

    try {
      final userId = await localRepository.getUserId(); // The userId key is where we store authentication status

      if (userId != null) {
        // If userId exists in SharedPreferences, fetch user data from repository (Firebase)
        final user = await userRepository.getUserData(userId);
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(errorMessage: "Failed to check authentication: $e"));
    }
  }

  // Event to handle sign-out
  void _onAuthSignedOut(AuthSignedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await localRepository.deleteUserId();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(errorMessage: "Failed to sign out: $e"));
    }
  }
}
