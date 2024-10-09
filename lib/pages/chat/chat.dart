import 'package:chat_app/widgets/contacts_manage_gesture_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyChatPage extends StatefulWidget {
  const MyChatPage({super.key});

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  //滚动监听器 _controller
  final ScrollController _controller = ScrollController();

  int itemNum = 60;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          trailing: ContactsManageGestureDetector(),
          middle: Text("Chat"),
        ),
        child: CupertinoScrollbar(
          //滑动条厚度
          thickness: 5.0,
          thicknessWhileDragging: 10.0,
          radius: const Radius.circular(1.5),
          radiusWhileDragging: const Radius.circular(2.0),
          scrollbarOrientation: ScrollbarOrientation.right,
          controller: _controller,
          thumbVisibility: true,
          child: ListView.builder(
            controller: _controller,
            //TODO:获取消息列表数
            itemCount: itemNum,
            itemBuilder: (BuildContext context, int index) {
              return CupertinoListTile(
                //TODO：好友头像、ID、最近消息、最近消息发送时间获取，点击事件处理
                leading: const Icon(CupertinoIcons.person),
                title: Text("好友$index"),
                subtitle: const Text(
                  "最近消息...",
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
                trailing: Text("8:${index.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10.0,
                    )),
              );
            },
          ),
        ));
  }
}
