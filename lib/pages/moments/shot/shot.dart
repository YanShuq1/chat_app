import 'package:chat_app/model/shotModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Shot extends StatelessWidget {
  const Shot({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ShotModel>>(
      future: _loadShots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final shots = snapshot.data ?? [];

        return ListView(
          scrollDirection: Axis.horizontal,
          children: shots.map((shot) => _buildShotItem(context, shot)).toList(),
        );
      },
    );
  }

  Future<List<ShotModel>> _loadShots() async {
    final box = await Hive.openBox<ShotModel>('shots');

    // 清空盒子中的所有数据,测试用的
    await box.clear();

    if (box.isEmpty) {
      // 添加默认数据
      final defaultShot = ShotModel(
        imagePath: 'images/avatar1.jpeg',
        avatarPath: 'images/avatar2.jpg', // 替换为你的默认头像路径
      );
      await box.add(defaultShot);

      final defaultShot1 = ShotModel(
        imagePath: 'images/avatar2.jpg',
        avatarPath: 'images/avatar3.jpg',
      );
      await box.add(defaultShot1);

      final defaultShot2 = ShotModel(
        imagePath: 'images/avatar2.jpg',
        avatarPath: 'images/avatar4.jpg',
      );
      await box.add(defaultShot2);
    }

    // 打印盒子中的项目数量
    print('Number of shots: ${box.length}');

    return box.values.toList();
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
              child: Image.asset(
                shot.imagePath,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
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
