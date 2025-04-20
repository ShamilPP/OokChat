import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? img;
  final double? height;
  final double? width;
  final double size;
  final bool isAi;

  const ProfileAvatar({super.key, this.img, this.height, this.width, this.size = 20, this.isAi = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CircleAvatar(
        backgroundColor: isAi ? Colors.blue[100] : Colors.green[100],
        child: img != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(img!, fit: BoxFit.cover),
              )
            : Icon(
                isAi ? Icons.smart_toy_rounded : Icons.person,
                color: isAi ? Colors.blue[700] : Colors.green[700],
                size: size,
              ),
      ),
    );
  }
}
