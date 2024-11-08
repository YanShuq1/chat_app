import 'package:chat_app/model/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("个人资料"),
      ),
      child: ListView(
        children: [
          ProfileTile(
            title: "头像",
            trailing: CircleAvatar(
              backgroundImage: NetworkImage(currentUser.avatarUrl), // 头像的URL
              radius: 30,
            ),
            onTap: () {
              _showImageDialog(
                context,
                currentUser.avatarUrl,
              );
            },
          ),
          const CustomDivider(),
          ProfileTile(
            title: "昵称",
            trailing: Text(
              currentUser.contactName,
              style: const TextStyle(color: CupertinoColors.inactiveGray),
            ),
            onTap: () {
              _showEditNicknameDialog(context);
            },
          ),
          const CustomDivider(),
          ProfileTile(
            title: "用户邮箱",
            trailing: Text(
              currentUser.email,
              style: const TextStyle(color: CupertinoColors.inactiveGray),
            ),
            onTap: () {},
          ),
          const CustomDivider(),
          ProfileTile(
            title: "二维码",
            trailing: QrImageView(
              data: currentUser.email, // 使用用户ID作为二维码内容
              version: QrVersions.auto,
              size: 50,
              // embeddedImage: NetworkImage(currentUser.avatarUrl),
            ),
            onTap: () {
              _showQrCodeDialog(context); // 点击放大二维码
            },
          ),
          const CustomDivider(),
        ],
      ),
    );
  }

  // 显示放大图片的对话框
  void _showImageDialog(BuildContext context, String imageUrl) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoPageScaffold(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // 点击图片关闭对话框
            },
            child: Container(
              color: Colors.black,
              child: Center(
                child: Image.network(imageUrl), // 放大的图片
              ),
            ),
          ),
        );
      },
    );
  }

  // 显示编辑昵称的对话框
  void _showEditNicknameDialog(BuildContext context) {
    TextEditingController controller =
        TextEditingController(text: currentUser.contactName);

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("编辑昵称"),
          content: CupertinoTextField(
            controller: controller, // 绑定当前昵称
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context); // 取消编辑
              },
              child: const Text("取消"),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                await Supabase.instance.client
                    .from('profiles')
                    .update({'user_name': controller.text.trim()}).eq(
                        'email', currentUser.email);
                setState(() {
                  loadCurrentUser();
                });
                Navigator.pop(context); // 关闭对话框
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }

  // 显示放大二维码的对话框
  void _showQrCodeDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoPageScaffold(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // 点击二维码关闭对话框
            },
            child: Center(
              child: QrImageView(
                data: currentUser.email,
                version: QrVersions.auto,
                size: 300, // 放大的二维码尺寸
                // embeddedImage: NetworkImage(currentUser.avatarUrl),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ProfileTile: 用于展示个人信息项的小部件
class ProfileTile extends StatelessWidget {
  final String title;
  final Widget trailing;
  final VoidCallback? onTap; // 点击事件回调

  const ProfileTile({
    super.key,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0), // 设置左边距
              child: Text(title, style: const TextStyle(fontSize: 18)),
            ),
            const Spacer(), // 使用 Spacer 将左侧文字和右侧元素推开
            trailing,
            const SizedBox(width: 16), // 右侧留出一点间距
            const Icon(CupertinoIcons.forward),
          ],
        ), // 添加点击事件
      ),
    );
  }
}

// CustomDivider: 自定义分割线小部件
class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 1,
      color: CupertinoColors.separator,
    );
  }
}
