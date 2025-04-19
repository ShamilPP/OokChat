import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/locator.dart';
import '../features/chat/bloc/chat_bloc.dart';

List<BlocProvider> globalBlocProviders = [
  BlocProvider<ChatBloc>(
    create: (_) => locator<ChatBloc>(),
  ),

  // You can add more like:
  // BlocProvider<AnotherBloc>(
  //   create: (_) => locator<AnotherBloc>(),
  // ),
];
