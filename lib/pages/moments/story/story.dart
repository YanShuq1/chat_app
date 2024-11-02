import 'package:chat_app/model/storyModel.dart';
import 'package:chat_app/pages/moments/story/likeButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Story extends StatelessWidget {
  const Story({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadStories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<StoryModel> stories = snapshot.data as List<StoryModel>;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stories.length,
          itemBuilder: (context, index) {
            return _buildStoryItem(context, stories[index]);
          },
        );
      },
    );
  }

  Future<List<StoryModel>> _loadStories() async {
    var box = await Hive.openBox<StoryModel>('stories');
    await box.clear();
    // 如果没有数据，初始化一个默认故事
    if (box.isEmpty) {
      var defaultStory = StoryModel(
        username: '海小宝',
        avatarUrl: 'images/avatar1.jpeg',
        timestamp: '1 hour ago',
        text: '月色好美!!!',
        imageUrl: 'images/story1.png',
        likes: 2500,
        comments: 400,
      );
      await box.add(defaultStory);
      var defaultStory1 = StoryModel(
        username: '海小宝',
        avatarUrl: 'images/avatar1.jpeg',
        timestamp: '1 hour ago',
        text: '月色好美!!!',
        imageUrl: 'images/story_image1.jpeg',
        likes: 2500,
        comments: 400,
      );
      await box.add(defaultStory1);
    }

    return box.values.toList();
  }

  // 构建 Story 的项目
  Widget _buildStoryItem(BuildContext context, StoryModel story) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(story.avatarUrl),
                radius: 24,
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    story.timestamp,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.inactiveGray,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(CupertinoIcons.ellipsis),
                onPressed: () {
                  // 更多选项逻辑
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 文本内容
          Text(story.text),
          const SizedBox(height: 10),
          // 图片内容
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              story.imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          // 点赞和评论数量
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(CupertinoIcons.hand_thumbsup_fill,
                    color: Colors.blue, size: 18),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(CupertinoIcons.heart_fill,
                    color: Colors.red, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                '${story.likes} K',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${story.comments} comments',
                style: const TextStyle(
                  color: CupertinoColors.inactiveGray,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 互动按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LikeButtonWithAnimation(),
              _buildActionButton(
                icon: CupertinoIcons.chat_bubble_text,
                label: 'Comment',
              ),
              _buildActionButton(
                icon: CupertinoIcons.bell,
                label: 'Share',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建底部互动按钮
  Widget _buildActionButton(
      {required IconData icon, required String label, Color? color}) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: color ?? Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: CupertinoColors.systemGrey3),
        ),
      ),
      onPressed: () {
        // 按钮的逻辑
      },
      icon: Icon(icon, size: 18, color: color ?? Colors.black),
      label: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
