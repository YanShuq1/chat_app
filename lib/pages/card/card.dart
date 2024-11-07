import 'package:chat_app/model/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../moments/moments.dart';
import 'profile/profile.dart';
import 'setting/setting.dart';

class MyCardPage extends StatelessWidget {
  const MyCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Card"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0), // 设置距离边缘的内边距
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // 设置卡片的圆角
            ),
            elevation: 4, // 可选：设置阴影效果
            child: const Center(
              child: Column(
                children: [Avatar(), CardPageButton()],
              ), // 放置 Avatar 组件
            ),
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30), // 头像顶部的空白间距
        // 用户头像
        ClipRRect(
          borderRadius: BorderRadius.circular(10), // 设置头像的圆角
          child: Image.network(
            currentUser.avatarUrl,
            width: 150, // 设置头像宽度
            height: 150, // 设置头像高度
            fit: BoxFit.cover, // 图片充满容器
          ),
        ),
        const SizedBox(height: 10), // 头像和个性签名之间的间距
        // 个性签名
        Text(
          currentUser.contactName,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class CardPageButton extends StatelessWidget {
  const CardPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton("个人资料", context, const ProfilePage()),
        _buildButton("空间", context, const MyMomentsPage()),
        _buildButton("设置", context, const SettingsPage()),
      ],
    );
  }

  Widget _buildButton(String title, BuildContext context, Widget page) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: CupertinoButton(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(10),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                title,
                style:
                    const TextStyle(color: Color.fromARGB(255, 191, 215, 239)),
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => page),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
