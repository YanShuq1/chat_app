import 'package:chat_app/model/shotModel.dart';
import 'package:chat_app/pages/home/home.dart';
import 'package:chat_app/provider/contact_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ShotModelAdapter()); // 注册适配器
  runApp(
    ChangeNotifierProvider(
      //监听覆盖
      create: (_) => ContactProvider(),
      child: const MyApp(),
    ),
  );
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
