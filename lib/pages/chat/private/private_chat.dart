import 'package:chat_app/model/chattile.dart';
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
  List<Map<String, dynamic>> _messages = [];

  //数据更新
  late String contactAvatarUrl; //获取好友的头像的url
  late String contactName;

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    //TODO:实现聊天室信息的上传与下载
    await Supabase.instance.client.from('chatMessages').insert({
      'chat_room_id': widget.chattile.chatRoomID,
      'message': message,
      'sender': Supabase.instance.client.auth.currentUser?.id,
      'send_time': DateTime.now().toIso8601String(),
    });

    _messageController.clear();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final response = await Supabase.instance.client
        .from('chatMessages')
        .select()
        .eq('chat_room_id', widget.chattile.chatRoomID)
        .order('send_time', ascending: false);

    final gotContact = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('email', widget.chattile.email)
        .single();
    contactAvatarUrl = gotContact['avatar_url'];
    contactName = gotContact['user_name'];

    // 检查 response 是否为空来判断查询是否成功
    setState(() {
      _messages = List<Map<String, dynamic>>.from(response);
      widget.chattile.avatarUrl = contactAvatarUrl;
      widget.chattile.contactName = contactName;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.chattile.contactName),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.lightBackgroundGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message['message']),
                  ),
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
                  onPressed: _sendMessage,
                  child: const Icon(CupertinoIcons.arrow_up_circle_fill),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
