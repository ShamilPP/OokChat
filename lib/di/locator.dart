import 'package:get_it/get_it.dart';
import 'package:ook_chat/features/chat/repositories/chat_repository.dart';
import '../features/chat/bloc/chat_bloc.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Register ChatRepository
  locator.registerLazySingleton<ChatRepository>(() => ChatRepository());

  // Register ChatBloc with dependency injected
  locator.registerFactory<ChatBloc>(() => ChatBloc(repository: locator<ChatRepository>()));
}
