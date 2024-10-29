import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationEnabled = false; // 是否接收消息通知
  bool isTeenModeEnabled = false; // 青少年模式
  bool isDarkModeEnabled = false; // 深色模式

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("个人设置"),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            // 接收消息通知设置
            _buildSwitchTile(
              title: "接收消息通知",
              value: isNotificationEnabled,
              onChanged: (bool value) {
                setState(() {
                  isNotificationEnabled = value;
                });
              },
            ),
            const Divider(),
            // 青少年模式设置
            _buildSwitchTile(
              title: "青少年模式",
              value: isTeenModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  isTeenModeEnabled = value;
                });
              },
            ),
            const Divider(),
            // 开启深色模式设置
            _buildSwitchTile(
              title: "开启深色模式",
              value: isDarkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
              },
            ),
            const Divider(),
            const SizedBox(height: 50),
            // 退出按钮
            CupertinoButton(
              color: const Color.fromARGB(255, 240, 190, 195),
              child: const Text("退出账号"),
              onPressed: () {
                // 退出逻辑
                //print("退出账号");
              },
            ),
          ],
        ),
      ),
    );
  }

  // 构建带有开关的设置项，并将 title 包装在一个圆角矩形中
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          // 包装 title 的圆角矩形
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 233, 237, 247), // 背景色
              borderRadius: BorderRadius.circular(10.0), // 圆角矩形
            ),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const Spacer(),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
