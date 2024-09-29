import 'package:chat_app/widgets/contacts_manage_gesture_detector.dart';
import 'package:flutter/cupertino.dart';

class MyChatPage extends StatelessWidget {
  const MyChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: ContactsManageGestureDetector(),
          middle: Text("Chat"),
        ),
        child: Center(
          child: Text("Chat Content Here."),
        ));
  }
}
