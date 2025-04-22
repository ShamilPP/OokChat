import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/user_repo.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<UpdateLastSeen>(_onUpdateLastSeen);
  }

  Future<void> _onUpdateLastSeen(
    UpdateLastSeen event,
    Emitter<UserState> emit,
  ) async {
    emit(LastSeenUpdating());
    try {
      await userRepository.updateLastSeen(event.userId, DateTime.now());
      emit(LastSeenUpdated());
    } catch (e) {
      emit(LastSeenUpdateFailed(e.toString()));
    }
  }
}
