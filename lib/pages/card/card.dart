import 'package:flutter/cupertino.dart';

class MyCardPage extends StatelessWidget {
  const MyCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Card"),
      ),
      child: Center(
        child: Text("Card Content Here."),
      )
      );
  }
}