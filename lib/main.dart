import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc_providers.dart';
import 'core/theme/app_theme.dart';
import 'di/locator.dart';
import 'features/chat/screens/chat_screen.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: globalBlocProviders,
      child: MaterialApp(
        title: 'AI Chat App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: ChatScreen(),
      ),
    );
  }
}