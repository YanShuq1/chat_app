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

  void _toggleAdd() async {
    try {
      var uuid = const Uuid();
      String chatRoomID = uuid.v1();

      await Supabase.instance.client.from('chatRooms').upsert({
        'chat_user_email': [currentUserEmail, widget.contact.email],
        'chat_room_id': chatRoomID,
      });
      // Save the contact locally
      saveContact(widget.contact);
      saveChatList(Chattile(
        contactName: widget.contact.contactName,
        email: widget.contact.email,
        chatRoomID: chatRoomID,
        avatarUrl: widget.contact.avatarUrl,
      ));

      // 添加当前用户的联系人信息
      final myResponse = await Supabase.instance.client
          .from('contacts')
          .select()
          .eq('user_email', currentUserEmail)
          .single();

      // 获取当前用户的联系人列表
      List<dynamic> myContacts = myResponse['contacts_email'] ?? [];
      if (!myContacts.contains(widget.contact.email)) {
        myContacts.add(widget.contact.email);
      }

      await Supabase.instance.client.from('contacts').upsert({
        'user_email': currentUserEmail,
        'contacts_email': myContacts,
      });

      // 双向添加好友
      final contactResponse = await Supabase.instance.client
          .from('contacts')
          .select()
          .eq('user_email', widget.contact.email)
          .single();

      // 获取对方的联系人列表
      List<dynamic> contactEmails = contactResponse['contacts_email'] ?? [];
      if (!contactEmails.contains(currentUserEmail)) {
        contactEmails.add(currentUserEmail);
      }

      await Supabase.instance.client.from('contacts').upsert({
        'user_email': widget.contact.email,
        'contacts_email': contactEmails,
      });

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
      child: Text(_isAdded ? '已添加' : '添加'),
    );
  }
}
