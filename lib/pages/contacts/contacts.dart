import 'dart:async';

import 'package:chat_app/model/chat_message.dart';
import 'package:chat_app/model/chattile.dart';
import 'package:chat_app/model/contact.dart';
import 'package:chat_app/pages/chat/private/private_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyContactsPage extends StatefulWidget {
  const MyContactsPage({super.key});

  @override
  State<MyContactsPage> createState() => _MyContactsPageState();
}

class _MyContactsPageState extends State<MyContactsPage> {
  final ScrollController _controller = ScrollController();

  late StreamSubscription _contactStream;

  @override
  void initState() {
    super.initState();
    _subscription();
  }

  void _subscription() {
    _contactStream = Supabase.instance.client
        .from('contacts')
        .stream(primaryKey: ['user_email']) // 根据你的表结构选择合适的主键
        .listen((List<Map<String, dynamic>> data) async {
      // 数据变化时，更新状态
      await spLoadAndSaveContactListFromDB();
      await spLoadAndSaveContactEmailListFromDB();
      await spLoadAndSaveChatListFromDB();
      await spLoadAndSaveLatestMessageListFromDB();
      // 按照拼音首字母排序
      contactList.sort((a, b) => PinyinHelper.getFirstWordPinyin(a.contactName)
          .toUpperCase()
          .compareTo(
              PinyinHelper.getFirstWordPinyin(b.contactName).toUpperCase()));
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
    _contactStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? currentLetter;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Contacts"),
      ),
      child: CupertinoScrollbar(
        controller: _controller,
        child: ListView(
          controller: _controller,
          children: [
            for (var i in contactList)
              () {
                String firstLetter =
                    PinyinHelper.getFirstWordPinyin(i.contactName)[0]
                        .toUpperCase();
                if (currentLetter != firstLetter) {
                  currentLetter = firstLetter;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: CupertinoListTile(
                          title: Text(currentLetter!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          backgroundColor: CupertinoColors.systemGrey5,
                        ),
                      ),
                      CupertinoListTile(
                        leading: Image.network(i.avatarUrl),
                        title: Text(i.contactName),
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => PrivateChat(
                                      chattile: chatList.firstWhere(
                                          (c) => c.email == i.email)))); //跳转私聊
                        },
                      )
                    ],
                  );
                } else {
                  return CupertinoListTile(
                    leading: Image.network(i.avatarUrl),
                    title: Text(i.contactName),
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => PrivateChat(
                                  chattile: chatList.firstWhere(
                                      (c) => c.email == i.email)))); //跳转私聊
                    },
                  );
                }
              }(),
          ],
        ),
      ),
    );
  }
}
