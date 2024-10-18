import 'package:chat_app/pages/chat/contact_manage/add_contact.dart';
import 'package:flutter/cupertino.dart';

class ContactsManageGestureDetector extends StatelessWidget {
  final VoidCallback onAdded;
  //联系人管理监听手势按钮组件，负责添加/删除好友，创建群聊业务
  const ContactsManageGestureDetector({super.key, required this.onAdded});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            title: const Text('选择操作'),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: const Text('添加好友'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      CupertinoDialogRoute(
                          builder: (context) => AddContactPage(
                                onAdded: onAdded,
                              ),
                          context: context));
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('创建群聊'),
                onPressed: () {
                  //print("Selected: Item 2");
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('加入群聊'),
                onPressed: () {
                  //print("Selected: Item 3");
                  Navigator.pop(context);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
      child: const Icon(CupertinoIcons.add_circled),
    );
  }
}
