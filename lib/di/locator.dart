import 'package:get_it/get_it.dart';
import 'package:ook_chat/features/auth/bloc/auth/auth_bloc.dart';
import 'package:ook_chat/features/auth/repo/user_repo.dart';
import 'package:ook_chat/features/chat/repositories/chat_repository.dart';

import '../features/auth/bloc/google_auth/google_auth_bloc.dart';
import '../features/auth/repo/local_repo.dart';
import '../features/chat/bloc/chat_bloc.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Register repository
  locator.registerLazySingleton<ChatRepository>(() => ChatRepository());
  locator.registerLazySingleton<LocalRepository>(() => LocalRepository());
  locator.registerLazySingleton<UserRepository>(() => UserRepository());

  // Register bloc
  locator.registerFactory<ChatBloc>(() => ChatBloc(repository: locator<ChatRepository>()));
  locator.registerFactory<GoogleAuthBloc>(() => GoogleAuthBloc(localRepository: locator<LocalRepository>(), userRepository: locator<UserRepository>()));
  locator.registerFactory<AuthBloc>(() => AuthBloc(localRepository: locator<LocalRepository>(), userRepository: locator<UserRepository>()));
}
