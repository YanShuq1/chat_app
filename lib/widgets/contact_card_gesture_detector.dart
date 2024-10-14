import 'package:chat_app/pages/chat/contact_card/contact_card.dart';
import 'package:flutter/cupertino.dart';

//进入联系人card监听手势组件
class ContactCardGestureDetector extends StatelessWidget {
  const ContactCardGestureDetector({super.key, required this.contactName});

  final String contactName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ContactCard(contactName: contactName)));
      },
      child: const Icon(CupertinoIcons.ellipsis),
    );
  }
}