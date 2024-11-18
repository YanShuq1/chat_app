import 'dart:io';
import 'package:chat_app/model/contact.dart';
import 'package:chat_app/model/shot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShotPage extends StatefulWidget {
  const ShotPage({super.key, required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  State<ShotPage> createState() => _ShotPageState();
}

class _ShotPageState extends State<ShotPage> {
  bool isLoading = false; // 加载状态标志

  @override
  void initState() {
    super.initState();
    _loadShotPageState();
  }

  Future<void> _loadShotPageState() async {
    setState(() {
      isLoading = true; // 开始加载
    });

    await loadShotListFromDataBase(); // 异步加载数据

    setState(() {
      isLoading = false; // 加载完成
    });
  }

  Future<void> _deleteShotPageState(Shot shot) async {
    setState(() {
      isLoading = true;
    });

    await deleteUserShotFromDataBase(shot);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // 加载指示器
      );
    }

    if (shotList.isEmpty) {
      return const Center(
        child: Text("No shots found."), // 空列表提示
      );
    }

    return FutureBuilder(
      future: loadShotListFromDataBase(),
      builder: (context, snapshot) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: shotList.length,
          itemBuilder: (context, index) {
            return _buildShotItem(context, shotList[index]);
          },
        );
      },
    );
  }

  // 构建每个 Shot 项目
  Widget _buildShotItem(BuildContext context, Shot shot) {
    return GestureDetector(
      onTap: () => _showImageDialog(context, shot.photoUrl),
      onLongPress: () => _showDeleteShotDialog(context, shot),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FutureBuilder<ImageProvider>(
                future: _loadImage(shot.photoUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      width: 150,
                      height: 150,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    // 出现错误时显示默认图片
                    return Image.asset(
                      'images/avatar2.jpg', // 默认图片路径
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(shot.email == currentUser.email
                      ? currentUser.avatarUrl
                      : contactList
                          .firstWhere((i) => i.email == shot.email)
                          .avatarUrl),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 加载图片函数，按照本地文件 > 网络图片 > assets 的顺序加载
  Future<ImageProvider> _loadImage(String imagePath) async {
    if (await File(imagePath).exists()) {
      return FileImage(File(imagePath));
    } else if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return const AssetImage('images/avatar2.jpg'); // 默认图片路径
    }
  }

  // 显示图片弹出框
  void _showImageDialog(BuildContext context, String imagePath) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<ImageProvider>(
          future: _loadImage(imagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return CupertinoAlertDialog(
                content: Image.asset(
                  'images/avatar2.jpg', // 默认图片路径
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

  // 显示删除 Shot 弹出框
  void _showDeleteShotDialog(BuildContext context, Shot shot) {
    if (shot.email == currentUser.email) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              "确定删除该条 Shot?",
              style: TextStyle(
                color: CupertinoColors.systemRed,
              ),
            ),
            content: const Text(
              "确定删除后该条 Shot 在本地和云端的记录都将删除且无法恢复，确定删除该条 Shot?",
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: Navigator.of(context).pop,
                child: const Text("取消"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  _deleteShotPageState(shot);
                  Navigator.of(context).pop();
                },
                child: const Text("确定"),
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text(
                "删除非本人的shot是无效操作!",
                style: TextStyle(color: CupertinoColors.systemRed),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: Navigator.of(context).pop,
                  child: const Text("确定"),
                )
              ],
            );
          });
    }
  }
}
