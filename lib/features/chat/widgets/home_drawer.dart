import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/constants/app_info.dart';
import 'package:ook_chat/features/about/screens/about_screen.dart';
import 'package:ook_chat/features/auth/bloc/auth/auth_bloc.dart';
import 'package:ook_chat/features/auth/bloc/auth/auth_state.dart';
import 'package:ook_chat/features/chat/bloc/chat/chat_bloc.dart';
import 'package:ook_chat/features/chat/bloc/chat/chat_state.dart';
import 'package:ook_chat/features/chat/bloc/chat_list/chat_list_bloc.dart';
import 'package:ook_chat/features/chat/bloc/chat_list/chat_list_state.dart';
import 'package:ook_chat/features/chat/widgets/profile_avatar.dart';
import 'package:ook_chat/features/feedback/widgets/feedback_dialog.dart';
import 'package:ook_chat/features/settings/screens/settings_screen.dart';

import '../../../model/user.dart';
import '../bloc/chat/chat_event.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    User? user;
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) user = authState.user;

    return Drawer(
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            color: colorScheme.primary.withOpacity(.9),
            child: Row(
              children: [
                ProfileAvatar(img: user?.profilePhoto, height: 50, width: 50, size: 25),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Ook Chat',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Ook chat member",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // New Chat Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<ChatBloc>().add(NewChatEvent());
                Navigator.pop(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('New Chat', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Chats',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Chat List
          Expanded(
            child: BlocBuilder<ChatListBloc, ChatListState>(builder: (ctx, chatListState) {
              return BlocBuilder<ChatBloc, ChatState>(builder: (ctx, chatState) {
                final selectedChatId = context.read<ChatBloc>().selectedChatId;
                if (chatListState is ChatListLoading) return Center(child: CircularProgressIndicator());
                if (chatListState is ChatListError) return Center(child: Text(chatListState.message));
                if (chatListState is ChatListLoaded) {
                  if (chatListState.chats.isEmpty) return Center(child: Text("No recent chats"));
                  return ListView.builder(
                    itemCount: chatListState.chats.length,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    itemBuilder: (context, index) {
                      final chatItem = chatListState.chats[index];
                      final isActive = chatItem.id == selectedChatId;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isActive ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: isActive ? Border.all(color: colorScheme.primary.withOpacity(0.3), width: 1) : null,
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isActive ? colorScheme.primary : colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isActive ? Icons.chat_outlined : Icons.chat_outlined,
                              color: isActive ? Colors.white : colorScheme.primary,
                              size: 18,
                            ),
                          ),
                          title: Text(
                            chatItem.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                              fontSize: 15,
                              color: isActive ? colorScheme.primary : theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          onTap: () async {
                            setState(() {
                              context.read<ChatBloc>().add(LoadChatMessagesEvent(userId: user!.id!, selectedChatId: chatItem.id!));
                            });
                            // Wait for the drawer to close
                            Future.delayed(Duration(milliseconds: 100)).then((value) {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return SizedBox();
                }
              });
            }),
          ),

          const Divider(thickness: 1),

          // Bottom Actions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                // Settings
                _buildMenuTile(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () async {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
                  },
                ),

                // About
                _buildMenuTile(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
                  },
                ), // Feedback
                _buildMenuTile(
                  context,
                  icon: Icons.feedback_outlined,
                  title: 'Feedback',
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(context: context, builder: (_) => FeedbackDialog());
                  },
                ),
              ],
            ),
          ),

          // const SizedBox(height: 10),

          // Version Info
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              'v${AppInfo.appVersion}',
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
