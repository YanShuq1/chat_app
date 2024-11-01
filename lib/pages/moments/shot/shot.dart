import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Shot extends StatelessWidget {
  const Shot({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _buildShotItem(context, 'images/avatar1.jpeg', 'images/avatar1.jpeg'),
        _buildShotItem(context, 'images/avatar2.jpg', 'images/avatar2.jpg'),
        _buildShotItem(context, 'images/avatar3.jpg', 'images/avatar3.jpg'),
        _buildShotItem(context, 'images/avatar4.jpg', 'images/avatar4.jpg'),
      ],
    );
  }

  // 构建Shot的图片项目
  Widget _buildShotItem(
      BuildContext context, String imagePath, String avatarPath) {
    return GestureDetector(
      onTap: () => _showImageDialog(context, imagePath),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 150, // 图片宽度
                height: 150, // 图片高度
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(2), // 白色边框的厚度
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 23, // 控制头像的实际大小
                  backgroundImage: AssetImage(avatarPath),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 显示放大图片的对话框
  void _showImageDialog(BuildContext context, String imagePath) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
