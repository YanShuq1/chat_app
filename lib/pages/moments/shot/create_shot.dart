import 'dart:io';
import 'package:chat_app/model/contact.dart';
import 'package:chat_app/model/shot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateShot extends StatefulWidget {
  const CreateShot({super.key});

  @override
  _CreateShotState createState() => _CreateShotState();
}

class _CreateShotState extends State<CreateShot> {
  XFile? _selectedImage; // 保存选择的图片,XFile为跨平台的抽象File类
  final ImagePicker _picker = ImagePicker();
  // bool _isLoading = false; //加载

  // 从图库中选择图片
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  // 将 shot 添加到 Hive
  // Future<void> _addShotToHive() async {
  //   if (_selectedImage != null) {
  //     final newShot = ShotModel(
  //       imagePath: _selectedImage!.path,
  //       avatarPath: currentUser.avatarUrl, // 修改为当前用户的头像
  //     );

  //     // 将 Shot 直接添加到 Hive 中的 shots box
  //     final box = Hive.box<ShotModel>('shots');
  //     await box.add(newShot);

  //     // print("Shot added successfully.");
  //     Navigator.of(context).pop(); // 返回上一个页面
  //   } else {
  //     // print("No image selected");
  //   }
  // }

  Future<void> _addShotToDB() async {
    setState(() {});

    await createAndSendShotToDataBase(_selectedImage!);
    await loadShotListFromDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Shot'),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 显示图片
            _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.file(
                      File(_selectedImage!.path),
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  )
                : GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Tap to select an image',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 30),
            // 取消和确认按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 取消按钮
                Flexible(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2, // 设置最大宽度
                    child: CupertinoButton(
                      padding: EdgeInsets.zero, // 去除内边距
                      color: Colors.red.withOpacity(0.3),
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                      child: const Icon(
                        CupertinoIcons.clear,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // 确认按钮
                Flexible(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2, // 设置最大宽度
                    child: CupertinoButton(
                      padding: EdgeInsets.zero, // 去除内边距
                      color: Colors.green.withOpacity(0.3),
                      onPressed: () {
                        _addShotToDB();
                      }, // 调用添加到 Hive 的方法
                      child: const Icon(
                        CupertinoIcons.check_mark,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            // 用户信息
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      //AssetImage('images/avatar2.jpg'), // 替换成你的头像路径
                      NetworkImage(currentUser
                          .avatarUrl), // 使用 NetworkImage 替换 Image.network
                ),
                const SizedBox(width: 10),
                Text(
                  currentUser.contactName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
