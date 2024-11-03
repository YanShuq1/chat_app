import 'package:hive/hive.dart';

part 'story_model.g.dart'; // 生成的适配器会在这个文件中

@HiveType(typeId: 1) // 确保 typeId 唯一
class StoryModel {
  @HiveField(0)
  final String username; // 用户名

  @HiveField(1)
  final String avatarUrl; // 用户头像 URL

  @HiveField(2)
  final String timestamp; // 发布时间

  @HiveField(3)
  final String text; // 文本内容

  @HiveField(4)
  final String imageUrl; // 图片 URL

  @HiveField(5)
  final int likes; // 点赞数量

  @HiveField(6)
  final int comments; // 评论数量

  StoryModel({
    required this.username,
    required this.avatarUrl,
    required this.timestamp,
    required this.text,
    required this.imageUrl,
    required this.likes,
    required this.comments,
  });
}
