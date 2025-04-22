import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/constants/app_icons.dart';
import 'package:ook_chat/features/auth/bloc/user/user_bloc.dart';
import 'package:ook_chat/features/auth/bloc/user/user_event.dart';
import 'package:ook_chat/features/auth/screens/auth_screen.dart';
import 'package:ook_chat/features/chat/bloc/chat_list/chat_list_bloc.dart';
import 'package:ook_chat/features/chat/bloc/chat_list/chat_list_event.dart';

import '../../auth/bloc/auth/auth_bloc.dart';
import '../../auth/bloc/auth/auth_event.dart';
import '../../auth/bloc/auth/auth_state.dart';
import '../../chat/screens/chat_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger authentication check when SplashScreen is displayed
    // LocalRepository().saveUserId("6Ye14v8K3lZFgeXYJY3Z");
    context.read<AuthBloc>().add(AuthCheckRequested());

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to chat screen if the user is authenticated

            context.read<UserBloc>().add(UpdateLastSeen(userId: state.user.id!));

            context.read<ChatListBloc>().add(LoadChatList(userId: state.user.id!));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          } else if (state is AuthUnauthenticated) {
            // Navigate to login/signup screen if the user is unauthenticated
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your Login/Signup Screen
            );
          }
        },
        child: Center(
          child: Hero(
            tag: 'app-icon',
            child: SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(AppIcons.appIcon),
            ),
          ),
        ),
      ),
    );
  }
}
