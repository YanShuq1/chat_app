import 'package:chat_app/model/chattile.dart';
import 'package:chat_app/pages/chat/private/private_chat.dart';
import 'package:chat_app/widgets/contacts_manage_gesture_detector.dart';
import 'package:flutter/cupertino.dart';

class MyChatPage extends StatefulWidget {
  const MyChatPage({super.key});

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  //滚动监听器 _controller
  final ScrollController _controller = ScrollController();

  //状态初始化
  @override
  void initState() {
    super.initState();
    loadChatList();
  }

  void _onChatChanged() {
    setState(() {
      loadChatList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: ContactsManageGestureDetector(
            onAdded: _onChatChanged, //回调函数
          ),
          middle: const Text("Chat"),
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
            itemCount: chatList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                //长摁弹出删除dialog
                onLongPress: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text("确定删除好友？"),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text(
                                "确定",
                                style:
                                    TextStyle(color: CupertinoColors.systemRed),
                              ),
                              onPressed: () {
                                chatList.removeAt(index);
                                _onChatChanged();
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text("取消"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      });
                },
                child: CupertinoListTile(
                  //TODO：好友头像、ID、最近消息、最近消息发送时间获取，点击事件处理
                  leading: const Icon(CupertinoIcons.person),
                  title: Text(chatList[index].contactName),
                  subtitle: const Text(
                    "最近消息...",
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                  trailing: Text("8:${index.toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey2,
                        fontSize: 10.0,
                      )),
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => PrivateChat(
                                  contactName: chatList[index].contactName,
                                  chatID: chatList[index].chatID,
                                )));
                  },
                ),
              );
            },
          ),
        ));
  }
}
