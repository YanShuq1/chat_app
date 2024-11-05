import 'package:chat_app/model/shot_model.dart';
import 'package:chat_app/model/story_model.dart';
import 'package:chat_app/pages/login/login.dart';
import 'package:chat_app/provider/contact_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化
  await Supabase.initialize(
    url: 'https://cjvsombxqljpbexdpuvy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNqdnNvbWJ4cWxqcGJleGRwdXZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA2OTg0MzYsImV4cCI6MjA0NjI3NDQzNn0.cpRt8LkhLBVDT5Z1VAXQqzl0g4LFlQgiDHpjLGmml-A',
  );

        


  await Hive.initFlutter(); // 初始化 Hive
  Hive.registerAdapter(ShotModelAdapter()); // 注册shot适配器
  Hive.registerAdapter(StoryModelAdapter());
  await Hive.openBox<ShotModel>('shots'); // 打开 Hive 数据库
  await Hive.openBox<StoryModel>('stories');

  final box = Hive.box<ShotModel>('shots'); // 直接获取已打开的 box

  // 清空盒子中的所有数据,测试用的
  await box.clear();
  final b = Hive.box<StoryModel>('stories');
  await b.clear();
  // 打印盒子中的项目数量
  // print('Number of shots: ${box.length}');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ContactProvider()), // 添加 ContactProvider
      ],
      child: const MyApp(), // 启动应用
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
      home: LoginPage());
  }
}
