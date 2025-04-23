// google_auth_bloc.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ook_chat/constants/key/firebase_constants.dart';

import '../../../../model/user.dart' as userModel;
import '../../repo/local_repo.dart';
import '../../repo/user_repo.dart';
import 'google_auth_event.dart';
import 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final LocalRepository localRepository;
  final UserRepository userRepository;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: FirebaseConstants.googleWebClientId);

  GoogleAuthBloc({required this.localRepository, required this.userRepository}) : super(GoogleAuthInitial()) {
    on<GoogleAuthSignInRequested>(_onSignIn);
    on<GoogleAuthSignOutRequested>(_onSignOut);
  }

  void _onSignIn(GoogleAuthSignInRequested event, Emitter<GoogleAuthState> emit) async {
    emit(GoogleAuthLoading());

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Sign-in canceled by user.");
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        userModel.User _user = userModel.User(
          uid: user.uid,
          profilePhoto: user.photoURL,
          name: user.displayName ?? "No Name",
          email: user.email ?? "No Email",
          createdTime: DateTime.now(),
          lastSeenTime: DateTime.now(),
        );
        var firebaseUser = await userRepository.createUser(_user);
        if (firebaseUser?.id != null) {
          await localRepository.saveUserId(firebaseUser!.id!);
          emit(GoogleAuthSignedIn(user: _user));
        } else {
          emit(GoogleAuthError(errorMessage: "Failed to sign in."));
        }
      } else {
        emit(GoogleAuthError(errorMessage: "Failed to sign in."));
      }
    } catch (e) {
      emit(GoogleAuthError(errorMessage: "Failed to sign in: $e"));
    }
  }

  void _onSignOut(GoogleAuthSignOutRequested event, Emitter<GoogleAuthState> emit) async {
    emit(GoogleAuthLoading());

    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();

      emit(GoogleAuthSignedOut());
    } catch (e) {
      emit(GoogleAuthError(errorMessage: "Failed to sign out: $e"));
    }
  }
}
