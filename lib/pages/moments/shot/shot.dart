import 'dart:io';
import 'package:chat_app/model/shotModel.dart';
import 'package:chat_app/provider/shot_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Shot extends StatelessWidget {
  const Shot({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShotProvider>(
      builder: (context, shotProvider, child) {
        // 如果数据还在加载，显示加载指示器
        if (shotProvider.shots.isEmpty) {
          return const Center(child: Text(""));
        }

        return ListView(
          scrollDirection: Axis.horizontal,
          children: shotProvider.shots
              .map((shot) => _buildShotItem(context, shot))
              .toList(),
        );
      },
    );
  }

  Widget _buildShotItem(BuildContext context, ShotModel shot) {
    return GestureDetector(
      onTap: () => _showImageDialog(context, shot.imagePath),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FutureBuilder<ImageProvider>(
                future: _loadImage(shot.imagePath),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 150,
                      height: 150,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    // 处理错误情况，比如返回一个默认图片
                    return Image.asset(
                      'images/avatar2.jpg', // 替换为你的默认图片路径
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Image(
                      image: snapshot.data!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
            ),
            Positioned(
              top: 8,
              left: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 23,
                  backgroundImage: AssetImage(shot.avatarPath),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<ImageProvider> _loadImage(String imagePath) async {
    // 检查图片是否存在于 assets 中
    if (await File(imagePath).exists()) {
      return FileImage(File(imagePath));
    } else {
      return AssetImage(imagePath); // 如果找不到，尝试从 assets 加载
    }
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<ImageProvider>(
          future: _loadImage(imagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return CupertinoAlertDialog(
                content: Image.asset(
                  'images/avatar2.jpg', // 替换为你的默认图片路径
                  fit: BoxFit.contain,
                ),
              );
            } else {
              return CupertinoAlertDialog(
                content: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(
                      image: snapshot.data!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
