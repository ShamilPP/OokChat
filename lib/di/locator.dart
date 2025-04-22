import 'package:get_it/get_it.dart';
import 'package:ook_chat/features/auth/bloc/auth/auth_bloc.dart';
import 'package:ook_chat/features/auth/bloc/user/user_bloc.dart';
import 'package:ook_chat/features/auth/repo/user_repo.dart';
import 'package:ook_chat/features/chat/bloc/chat_list/chat_list_bloc.dart';
import 'package:ook_chat/features/chat/repositories/firebase_chat_repository.dart';
import 'package:ook_chat/features/feedback/repositories/feedback_repository.dart';

import '../bloc/theme/theme_cubit.dart';
import '../features/auth/bloc/google_auth/google_auth_bloc.dart';
import '../features/auth/repo/local_repo.dart';
import '../features/chat/bloc/chat/chat_bloc.dart';
import '../features/chat/repositories/gemini_chat_repository.dart';
import '../features/feedback/bloc/feedback_bloc.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Register repository
  locator.registerLazySingleton<GeminiChatRepository>(() => GeminiChatRepository());
  locator.registerLazySingleton<LocalRepository>(() => LocalRepository());
  locator.registerLazySingleton<UserRepository>(() => UserRepository());
  locator.registerLazySingleton<FirebaseChatRepository>(() => FirebaseChatRepository());
  locator.registerLazySingleton<FeedbackRepository>(() => FeedbackRepository());

  // Register bloc
  locator.registerFactory<ThemeCubit>(() => ThemeCubit());
  locator.registerFactory<ChatBloc>(() => ChatBloc(geminiRepository: locator<GeminiChatRepository>(), firebaseRepository: locator<FirebaseChatRepository>()));
  locator.registerFactory<GoogleAuthBloc>(() => GoogleAuthBloc(localRepository: locator<LocalRepository>(), userRepository: locator<UserRepository>()));
  locator.registerFactory<AuthBloc>(() => AuthBloc(localRepository: locator<LocalRepository>(), userRepository: locator<UserRepository>()));
  locator.registerFactory<ChatListBloc>(() => ChatListBloc(chatRepository: locator<FirebaseChatRepository>()));
  locator.registerFactory<UserBloc>(() => UserBloc(userRepository: locator<UserRepository>()));
  locator.registerFactory<FeedbackBloc>(() => FeedbackBloc(feedbackRepository: locator<FeedbackRepository>()));
}
