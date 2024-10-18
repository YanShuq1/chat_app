import 'package:chat_app/model/chattile.dart';
import 'package:chat_app/model/contact.dart';
import 'package:flutter/cupertino.dart';

//添加好友按钮
class AddContactButton extends StatefulWidget {
  final String contactName;
  final String chatID;

  final VoidCallback onAdded;
  const AddContactButton(
      {super.key,
      required this.chatID,
      required this.contactName,
      required this.onAdded});

  @override
  State<AddContactButton> createState() => _AddContactButtonState();
}

class _AddContactButtonState extends State<AddContactButton> {
  bool _isAdd = false;

  @override
  void initState() {
    super.initState();
    loadContactList();
    setState(() {
      _isAdd = contactList.any((contact) => contact.chatID == widget.chatID);
    });
  }

  void _toggleAdd() {
    setState(() {
      _isAdd = true;
      loadChatList();
      widget.onAdded(); //回调函数，通知父组件
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 30,
      child: CupertinoButton(
          padding: const EdgeInsets.all(0),
          color:
              _isAdd ? CupertinoColors.systemGrey : CupertinoColors.activeBlue,
          onPressed: () {
            saveChatList(Chattile(
                chatID: widget.chatID, contactName: widget.contactName));
            saveContactList(Contact(
                chatID: widget.chatID, contactName: widget.contactName));
            _toggleAdd();
          },
          child: Text(
            _isAdd ? "已添加" : "添加",
            style: const TextStyle(fontSize: 12),
          )),
    );
  }
}
