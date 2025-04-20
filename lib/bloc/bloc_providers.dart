import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/locator.dart';
import '../features/auth/bloc/auth/auth_bloc.dart';
import '../features/auth/bloc/google_auth/google_auth_bloc.dart';
import '../features/chat/bloc/chat_bloc.dart';

List<BlocProvider> globalBlocProviders = [
  BlocProvider<ChatBloc>(
    create: (_) => locator<ChatBloc>(),
  ),
  BlocProvider<GoogleAuthBloc>(
    create: (_) => locator<GoogleAuthBloc>(),
  ),

  BlocProvider<AuthBloc>(
    create: (_) => locator<AuthBloc>(),
  ),
];
