import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

final String apkLink = "https://github.com/ShamilPP/OokChat/releases/download/latest/ook_chat.apk";

class DownloadUpdateWidget extends StatefulWidget {
  const DownloadUpdateWidget({super.key});

  @override
  State<DownloadUpdateWidget> createState() => _DownloadUpdateWidgetState();
}

class _DownloadUpdateWidgetState extends State<DownloadUpdateWidget> {
  double progress = 0.0;

  @override
  void initState() {
    download();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Downloading Update"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 12),
          Text("${(progress * 100).toStringAsFixed(0)}%"),
        ],
      ),
    );
  }

  void download() async {
    // Ask for permission
    final storageStatus = await Permission.storage.request();
    final installPerStatus = await Permission.requestInstallPackages.request();
    if (!storageStatus.isGranted) {
      Navigator.pop(context);
      _showError(context, "Storage permission denied.");
      return;
    }
    if (!installPerStatus.isGranted) {
      Navigator.pop(context);
      _showError(context, "Install permission denied.");
      return;
    }

    try {
      final dir = await getExternalStorageDirectory();
      final filePath = "${dir!.path}/ookchat.apk";
      final file = File(filePath);

      // Download APK
      await Dio().download(
        apkLink,
        file.path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = received / total;
            });
          }
        },
      );

      Navigator.pop(context); // Close progress dialog
      await OpenFile.open(file.path); // Open APK to install
    } catch (e) {
      Navigator.pop(context); // Close dialog on error
      _showError(context, "Download failed: $e");
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(ctx),
          )
        ],
      ),
    );
  }
}
