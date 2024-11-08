import 'dart:async';

import 'package:chat_app/model/chat_message.dart';
import 'package:chat_app/model/chattile.dart';
import 'package:chat_app/model/contact.dart';
import 'package:chat_app/pages/chat/contact_card/contact_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PrivateChat extends StatefulWidget {
  final Chattile chattile;
  const PrivateChat({super.key, required this.chattile});

  @override
  _PrivateChatState createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  final _messageController = TextEditingController();

  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _startSubscribe();
  }

  void _startSubscribe() {
    _subscription = Supabase.instance.client
        .from('chatMessages')
        .stream(primaryKey: ['chat_message_id']).listen(
            (List<Map<String, dynamic>> data) async {
      await spLoadAndSaveContactListFromDB();
      await spLoadAndSaveContactEmailListFromDB();
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
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _sendMessage(DateTime sendTime) async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    _messageController.clear();

    await Supabase.instance.client.from('chatMessages').insert({
      'chat_room_id': widget.chattile.chatRoomID,
      'message': message,
      'sender': currentUser.email,
      'send_time': sendTime.toIso8601String(),
    });

    final messageList = await Supabase.instance.client
        .from('chatMessages')
        .select()
        .eq('chat_room_id', widget.chattile.chatRoomID)
        .order('send_time', ascending: false);

    String messageID = messageList.first['chat_message_id'];

    // print(messageID);

    await Supabase.instance.client
        .from('chatRooms')
        .update({'latest_message_id': messageID}).eq(
            'chat_room_id', widget.chattile.chatRoomID);

    await spLoadAndSaveLatestMessageListFromDB();

    // print("私聊更新最近消息:$latestMessageList");
  }

  @override
  Widget build(BuildContext context) {
    final messageStream = Supabase.instance.client
        .from('chatMessages')
        .stream(primaryKey: ['chat_message_id'])
        .eq('chat_room_id', widget.chattile.chatRoomID)
        .order('send_time', ascending: false);

    final contactAvatarUrl = widget.chattile.avatarUrl;
    final contactName = widget.chattile.contactName;

    // print(widget.chattile);
    // print(widget.chattile.avatarUrl);
    // print(widget.chattile.contactName);
    // print(widget.chattile.chatRoomID);
    // print(widget.chattile.email);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(contactName),
        trailing: GestureDetector(
            child: const Icon(CupertinoIcons.ellipsis),
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) =>
                          ContactCard(chattile: widget.chattile)));
            }),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: messageStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return const Center(child: Text('暂无消息'));
                  }

                  final messages = snapshot.data!;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isCurrentUser =
                          message['sender'] == currentUser.email;
                      final sendTime = DateTime.parse(message['send_time']);
                      final formattedTime =
                          sendTime.toString().substring(0, 19);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: isCurrentUser
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  if (!isCurrentUser) ...[
                                    // 对方的头像
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: CupertinoColors.systemGrey,
                                          width: 0.8,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          contactAvatarUrl,
                                          width: 30, // 头像大小
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  // 消息气泡
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    constraints: const BoxConstraints(
                                      maxWidth: 250, // 限制气泡的最大宽度
                                    ),
                                    decoration: BoxDecoration(
                                      color: isCurrentUser
                                          ? const Color.fromARGB(
                                              190, 0, 123, 255)
                                          : CupertinoColors.lightBackgroundGray,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      message['message'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (isCurrentUser) ...[
                                    const SizedBox(width: 8),
                                    // 当前用户的头像
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: CupertinoColors.systemGrey,
                                          width: 0.8,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          currentUser.avatarUrl,
                                          width: 30, // 头像大小
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4), // 间距
                              // 显示时间
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                child: Text(
                                  formattedTime,
                                  style: const TextStyle(
                                    color: CupertinoColors.inactiveGray,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _messageController,
                      placeholder: '输入消息',
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      DateTime sendTime = DateTime.now();
                      _sendMessage(sendTime);
                    },
                    child: const Icon(CupertinoIcons.arrow_up_circle_fill),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
