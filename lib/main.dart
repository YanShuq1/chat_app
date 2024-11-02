import 'package:chat_app/model/shotModel.dart';
import 'package:chat_app/pages/home/home.dart';
import 'package:chat_app/provider/contact_provider.dart';
import 'package:chat_app/provider/shot_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化

  await Hive.initFlutter(); // 初始化 Hive
  Hive.registerAdapter(ShotModelAdapter()); // 注册适配器
  await Hive.openBox<ShotModel>('shots'); // 打开 Hive 数据库

  final box = Hive.box<ShotModel>('shots'); // 直接获取已打开的 box
  // 清空盒子中的所有数据,测试用的
  // await box.clear();
  // 打印盒子中的项目数量
  print('Number of shots: ${box.length}');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ContactProvider()), // 添加 ContactProvider
        ChangeNotifierProvider(
            create: (_) => ShotProvider()), // 添加 ShotProvider
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
      home: MyHomePage(),
    );
  }
}
