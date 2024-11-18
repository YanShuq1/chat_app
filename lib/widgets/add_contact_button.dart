import 'package:chat_app/model/chat_message.dart';
import 'package:chat_app/model/chattile.dart';
import 'package:chat_app/model/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddContactButton extends StatefulWidget {
  final Contact contact;
  final VoidCallback onAdded;

  const AddContactButton(
      {super.key, required this.contact, required this.onAdded});

  @override
  State<AddContactButton> createState() => _AddContactButtonState();
}

class _AddContactButtonState extends State<AddContactButton> {
  bool _isAdded = false;

  @override
  void initState() {
    super.initState();
  }

  void _toggleAdd() async {
    try {
      if (!contactEmailList.any((i)=>i==widget.contact.email)) {
        var uuid = const Uuid();
        String chatRoomID = uuid.v1();
        saveContactToDB(widget.contact); //自带双向添加好友
        spSaveContact(widget.contact); //添加完后本地持久化
        chatList.add(Chattile(
            email: widget.contact.email,
            contactName: widget.contact.contactName,
            chatRoomID: chatRoomID,
            avatarUrl: widget.contact.avatarUrl));
        //数据库中添加chatRoom
        await Supabase.instance.client.from('chatRooms').upsert({
          'chat_room_id': chatRoomID,
          'chat_user_email': [currentUser.email, widget.contact.email]
        });

        saveChatListToDB(); //同步数据库
        spSaveChatList(); //本地持久化

        //添加好友后发送问候消息
        await Supabase.instance.client.from('chatMessages').upsert({
          'chat_room_id': chatRoomID,
          'sender': currentUser.email,
          'message': "Hellooooo! Let's chat now!",
          'send_time': DateTime.now().toIso8601String(),
        });

        final messageList = await Supabase.instance.client
            .from('chatMessages')
            .select()
            .eq('chat_room_id', chatRoomID)
            .order('send_time', ascending: false);

        String messageID = messageList.first['chat_message_id'];

        await Supabase.instance.client.from('chatRooms').update(
            {'latest_message_id': messageID}).eq('chat_room_id', chatRoomID);

        //根据最近消息时间排列聊天列表
        chatList.sort((a, b) {
          String timeA =
              latestMessageList[a.chatRoomID]!['latestMessageSendTime'];
          String timeB =
              latestMessageList[b.chatRoomID]!['latestMessageSendTime'];
          return timeB.compareTo(timeA);
        });
      }
      // 更新状态
      setState(() {
        _isAdded = true;
      });
      widget.onAdded();
    } catch (e) {
      print('Error adding contact: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (contactEmailList.contains(widget.contact.email)) {
      _isAdded = true;
    }
    return CupertinoButton(
      onPressed: _isAdded ? null : _toggleAdd,
      child: Text(_isAdded ? '已添加' : '添加',style: const TextStyle(fontSize: 13),),
    );
  }
}
