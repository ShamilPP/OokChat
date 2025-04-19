import 'package:flutter/material.dart';
import 'package:ook_chat/constants/app_info.dart';
import 'package:ook_chat/features/about/screens/about_screen.dart';
import 'package:ook_chat/features/chat/widgets/profile_avatar.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final List<String> chatItems = [
    "Ego Slayer",
    "Confidence Crusher",
    "Roast Session",
    "Verbal Punches",
    "Burn Central",
    "Trash Talk Time",
    "Savage Replies",
    "No Mercy Mode",
    "Tear Factory",
    "Emotional Damage Bot",
  ];

  int activeChatIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                ProfileAvatar(isUser: true, height: 50, width: 50, size: 25),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ook Chat',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Your AI Assistant',
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
                // TODO: Start new chat
              },
              icon: const Icon(Icons.add),
              label: const Text('New Chat', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                backgroundColor: colorScheme.primary,
                foregroundColor:Colors.white,
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
            child: ListView.builder(
              itemCount: chatItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              itemBuilder: (context, index) {
                final chatItem = chatItems[index];
                final isActive = index == activeChatIndex;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isActive ? Border.all(color: colorScheme.primary.withOpacity(0.3), width: 1) : null,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isActive ? colorScheme.primary : colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive ? Icons.chat : Icons.chat_outlined,
                        color: isActive ? Colors.white : colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      chatItem,
                      style: TextStyle(
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                        fontSize: 15,
                        color: isActive ? colorScheme.primary : theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    // trailing: isActive
                    //     ? Icon(
                    //         Icons.check_circle,
                    //         color: colorScheme.primary,
                    //         size: 18,
                    //       )
                    //     : null,
                    onTap: () {
                      setState(() {
                        activeChatIndex=index;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const Divider(thickness: 1),

          // Bottom Actions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                // Settings
                _buildMenuTile(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    // TODO: Navigate to settings screen
                  },
                ),

                // About
                _buildMenuTile(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Version Info
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
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
