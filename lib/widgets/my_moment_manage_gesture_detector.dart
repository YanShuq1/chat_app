import 'package:flutter/cupertino.dart';

class MyMomentManageGestureDetector extends StatelessWidget {
  //动态管理监听手势按钮组件，负责发布动态业务
  const MyMomentManageGestureDetector({super.key});

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
                child: const Text('发布动态'),
                onPressed: () {
                  //print("Selected: Item 1");
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
