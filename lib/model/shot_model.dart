import 'package:hive/hive.dart';

part 'shot_model.g.dart'; // 生成的适配器会在这个文件中

@HiveType(typeId: 0)
class ShotModel {
  @HiveField(0)
  final String imagePath;

  @HiveField(1)
  final String avatarPath;

  ShotModel({required this.imagePath, required this.avatarPath});
}
