import 'package:chat_app/pages/home/home.dart';
import 'package:chat_app/provider/contact_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(    
    ChangeNotifierProvider(
      //监听覆盖
      create: (_) => ContactProvider(),
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatApp Demo',
      home: MyHomePage(),
    );
  }
}
