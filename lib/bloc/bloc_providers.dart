import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/bloc/theme/theme_cubit.dart';
import 'package:ook_chat/features/auth/bloc/user/user_bloc.dart';
import 'package:ook_chat/features/chat/bloc/chat_list/chat_list_bloc.dart';
import 'package:ook_chat/features/feedback/bloc/feedback_bloc.dart';

import '../di/locator.dart';
import '../features/auth/bloc/auth/auth_bloc.dart';
import '../features/auth/bloc/google_auth/google_auth_bloc.dart';
import '../features/chat/bloc/chat/chat_bloc.dart';

List<BlocProvider> globalBlocProviders = [
  BlocProvider<ThemeCubit>(
    create: (_) => locator<ThemeCubit>(),
  ),
  BlocProvider<ChatBloc>(
    create: (_) => locator<ChatBloc>(),
  ),
  BlocProvider<ChatListBloc>(
    create: (_) => locator<ChatListBloc>(),
  ),
  BlocProvider<GoogleAuthBloc>(
    create: (_) => locator<GoogleAuthBloc>(),
  ),
  BlocProvider<AuthBloc>(
    create: (_) => locator<AuthBloc>(),
  ),
  BlocProvider<UserBloc>(
    create: (_) => locator<UserBloc>(),
  ),
  BlocProvider<FeedbackBloc>(
    create: (_) => locator<FeedbackBloc>(),
  ),
];
