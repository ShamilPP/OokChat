import 'package:flutter/material.dart';
import 'package:ook_chat/features/about/screens/about_screen.dart';

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});

  final List<String> chatTitles = [
    "Shopping Bot",
    "Weather Inquiry",
    "Project Discussion",
    "Fun Chat",
  ];

  final int activeChatIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 40),

          // New Chat Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Start new chat
              },
              icon: const Icon(Icons.add),
              label: const Text('New Chat'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Chat List
          Expanded(
            child: ListView.builder(
              itemCount: chatTitles.length,
              itemBuilder: (context, index) {
                final chatTitle = chatTitles[index];
                final isActive = index == activeChatIndex;

                return ListTile(
                  leading: Icon(
                    isActive ? Icons.chat : Icons.chat_outlined,
                    color: isActive
                        ? theme.primaryColor
                        : theme.iconTheme.color,
                  ),
                  title: Text(
                    chatTitle,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive
                          ? theme.primaryColor
                          : theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  tileColor: isActive
                      ? colorScheme.primary.withOpacity(0.1)
                      : null,
                  onTap: () {
                    // TODO: Handle chat selection
                  },
                );
              },
            ),
          ),

          const Divider(),

          // Settings
          ListTile(
            leading: Icon(Icons.settings_outlined, color: theme.iconTheme.color),
            title: Text('Settings', style: theme.textTheme.bodyLarge),
            onTap: () {
              // TODO: Navigate to settings screen
            },
          ),

          // About
          ListTile(
            leading: Icon(Icons.info_outline, color: theme.iconTheme.color),
            title: Text('About', style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
