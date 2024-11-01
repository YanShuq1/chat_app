import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateStory extends StatelessWidget {
  const CreateStory({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Create Story'),
      ),
      child: Center(
        child: Text(
          'This is the Create Story page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
