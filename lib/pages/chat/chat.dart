import 'dart:async';

import 'package:chat_app/model/chat_message.dart';
import 'package:chat_app/model/chattile.dart';
import 'package:chat_app/model/contact.dart';
import 'package:chat_app/pages/chat/private/private_chat.dart';
import 'package:chat_app/widgets/contacts_manage_gesture_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyChatPage extends StatefulWidget {
  const MyChatPage({super.key});

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  final ScrollController _controller = ScrollController();

  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _startSubscribe();
  }

  void _startSubscribe() {
    _streamSubscription = Supabase.instance.client
        .from('chatRooms')
        .stream(primaryKey: ['chat_room_id']) // 根据你的表结构选择合适的主键
        .listen((List<Map<String, dynamic>> data) async {
      // 数据变化时，更新状态
      await spLoadAndSaveContactEmailListFromDB();
      await spLoadAndSaveContactListFromDB();
      await spLoadAndSaveChatListFromDB();
      await spLoadAndSaveLatestMessageListFromDB();
      //根据最近消息时间排列聊天列表
      chatList.sort((a, b) {
        String timeA =
            latestMessageList[a.chatRoomID]!['latestMessageSendTime'];
        String timeB =
            latestMessageList[b.chatRoomID]!['latestMessageSendTime'];
        return timeB.compareTo(timeA);
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: ContactsManageGestureDetector(
          onAdded: () {},
        ),
        middle: const Text("Chat"),
      ),
      child: CupertinoScrollbar(
        controller: _controller,
        child: ListView.builder(
          controller: _controller,
          itemCount: chatList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text("确定删除对话？"),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text("确定",
                              style:
                                  TextStyle(color: CupertinoColors.systemRed)),
                          onPressed: () {
                            chatList.removeAt(index);
                            setState(() {});
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
                  },
                );
              },
              child: CupertinoListTile(
                leading: Image.network(chatList[index].avatarUrl),
                title: Text(chatList[index].contactName),
                subtitle: Text(
                  latestMessageList[chatList[index].chatRoomID]
                          ?['latestMessage'] ??
                      'No messages',
                  style: const TextStyle(fontSize: 10.0),
                ),
                trailing: Text(
                  latestMessageList[chatList[index].chatRoomID]
                          ?['latestMessageSendTime'] ??
                      'N/A',
                  style: const TextStyle(
                      color: CupertinoColors.systemGrey2, fontSize: 10.0),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          PrivateChat(chattile: chatList[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
