import 'package:chat_app/model/chattile.dart';
import 'package:chat_app/pages/chat/private/private_chat.dart';
import 'package:chat_app/provider/contact_provider.dart';
import 'package:chat_app/widgets/contacts_manage_gesture_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MyChatPage extends StatefulWidget {
  const MyChatPage({super.key});

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContactProvider>(context, listen: false).freshContact();
    });
  }

  void _onChatChanged() {
    setState(() {
      spLoadAndSaveChatListFromDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    print('chatList:$chatList');
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: ContactsManageGestureDetector(
          onAdded: _onChatChanged,
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
                  },
                );
              },
              child: CupertinoListTile(
                leading: Image.network(chatList[index].avatarUrl),
                title: Text(chatList[index].contactName),
                subtitle:
                    const Text("最近消息...", style: TextStyle(fontSize: 10.0)),
                trailing: Text("8:${index.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                        color: CupertinoColors.systemGrey2, fontSize: 10.0)),
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
