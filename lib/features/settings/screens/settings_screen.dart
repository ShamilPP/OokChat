import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ook_chat/bloc/theme/theme_cubit.dart';
import 'package:ook_chat/features/preminum/widgets/preminum_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  double _roastLevel = 50;
  String _messageType = 'Roast';
  String _messageLength = 'Short';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Settings
          _buildSectionHeader('Appearance'),
          _buildThemeSelector(),
          const Divider(height: 32),

          // Roast Level Settings
          _buildSectionHeader('Roast Level'),
          _buildRoastLevelSlider(),
          const Divider(height: 32),

          // Message Type Settings
          _buildSectionHeader('Message Type'),
          _buildMessageTypeSelector(),
          const Divider(height: 32),

          // Message Length Settings
          _buildSectionHeader('Message Length'),
          _buildMessageLengthSelector(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeOption(ThemeMode.light, 'Light', Icons.light_mode),
            const Divider(height: 1),
            _buildThemeOption(ThemeMode.dark, 'Dark', Icons.dark_mode),
            const Divider(height: 1),
            _buildThemeOption(ThemeMode.system, 'System', Icons.settings_suggest),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(ThemeMode mode, String title, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          _themeMode = mode;
          context.read<ThemeCubit>().setTheme(mode);
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            Radio<ThemeMode>(
              value: mode,
              groupValue: _themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  setState(() {
                    _themeMode = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoastLevelSlider() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mild'),
                Text(
                  _roastLevel.round().toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getRoastColor(_roastLevel),
                  ),
                ),
                const Text('Savage'),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                activeTrackColor: _getRoastColor(_roastLevel),
              ),
              child: Slider(
                value: _roastLevel,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    _roastLevel = value;
                  });
                },
                onChangeEnd: (value) {
                  setState(() {
                    _roastLevel = 50;
                  });
                  showPremiumDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoastColor(double level) {
    if (level < 30) {
      return Colors.green;
    } else if (level < 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildMessageTypeSelector() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessageTypeOption('Roast', 'Sarcastic and roasting responses'),
            const Divider(height: 1),
            _buildMessageTypeOption('Funny', 'Humorous and light-hearted responses'),
            const Divider(height: 1),
            _buildMessageTypeOption('Normal', 'Standard professional responses'),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTypeOption(String type, String description) {
    return InkWell(
      onTap: () {
        showPremiumDialog();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Spacer(),
            Radio<String>(
              value: type,
              groupValue: _messageType,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _messageType = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageLengthSelector() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessageLengthOption('Short', 'Brief, concise responses'),
            const Divider(height: 1),
            _buildMessageLengthOption('Normal', 'Standard length responses'),
            const Divider(height: 1),
            _buildMessageLengthOption('Long', 'Detailed, comprehensive responses'),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageLengthOption(String length, String description) {
    return InkWell(
      onTap: () {
        showPremiumDialog();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  length,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Spacer(),
            Radio<String>(
              value: length,
              groupValue: _messageLength,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _messageLength = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  showPremiumDialog() {
    showDialog(context: context, builder: (_) => GetPlusPremiumDialog());
  }
}
