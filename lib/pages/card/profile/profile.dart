import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String nickname = "我爱睡觉"; // 昵称的初始值

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
            trailing: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://c-ssl.duitang.com/uploads/blog/202307/12/y9SY3apeubl4oJ5.jpeg'), // 头像的URL
              radius: 30,
            ),
            onTap: () {
              _showImageDialog(
                context,
                'https://c-ssl.duitang.com/uploads/blog/202307/12/y9SY3apeubl4oJ5.jpeg',
              );
            },
          ),
          const CustomDivider(),
          ProfileTile(
            title: "昵称",
            trailing: Text(
              nickname,
              style: const TextStyle(color: CupertinoColors.inactiveGray),
            ),
            onTap: () {
              _showEditNicknameDialog(context);
            },
          ),
          const CustomDivider(),
          const ProfileTile(
            title: "二维码",
            trailing: Image(
              image: NetworkImage(
                  "https://th.bing.com/th/id/R.bcd18b2eff79aa76c210cb1b4fa9e718?rik=TWBJEYvTNbweXA&riu=http%3a%2f%2fpic.616pic.com%2fys_bnew_img%2f00%2f10%2f41%2fe0SAYdMOs1.jpg&ehk=o1kc%2fcW7P17uacN%2fn%2fqoQKqoYYaY3TmPdLFC0lXqfkM%3d&risl=&pid=ImgRaw&r=0"), // 二维码的URL
              width: 50,
              height: 50,
            ),
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
    TextEditingController controller = TextEditingController(text: nickname);

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
              onPressed: () {
                setState(() {
                  nickname = controller.text; // 更新昵称
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
}

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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0), // 设置左边距
            child: Text(title, style: const TextStyle(fontSize: 18)),
          ),
          const Spacer(), // 使用 Spacer 将左侧文字和右侧元素推开
          GestureDetector(
            onTap: onTap, // 添加点击事件
            child: trailing, // 右侧的头像、昵称或二维码
          ),
          const SizedBox(width: 16), // 右侧留出一点间距
          const Icon(CupertinoIcons.forward),
        ],
      ),
    );
  }
}

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
