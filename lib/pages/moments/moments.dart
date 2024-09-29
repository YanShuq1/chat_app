import 'package:chat_app/widgets/my_moment_manage_gesture_detector.dart';
import 'package:flutter/cupertino.dart';

class MyMomemntsPage extends StatefulWidget {
  const MyMomemntsPage({super.key});

  @override
  State<MyMomemntsPage> createState() => _MyMomemntsPageState();
}

class _MyMomemntsPageState extends State<MyMomemntsPage> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: MyMomentManageGestureDetector(),
        middle: Text("Moment"),
      ),
      child: Center(
        child: Text("Moment Content Here."),
      )
      );
  }
}