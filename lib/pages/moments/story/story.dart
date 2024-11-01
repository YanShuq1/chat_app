import 'package:chat_app/pages/moments/story/likeButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Story extends StatelessWidget {
  const Story({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildStoryItem(context);
      },
    );
  }

  // 构建Story的项目
  Widget _buildStoryItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户信息
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('images/avatar1.jpeg'),
                radius: 24,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '海小宝',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '1 hour ago',
                    style: TextStyle(
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
          const Text("月色好美!!!"),
          const SizedBox(height: 10),
          // 图片内容
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'images/avatar1.jpeg',
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
              const Text(
                '2.5 K',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Text(
                '400 comments',
                style: TextStyle(
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
              LikeButtonWithAnimation(), // 替换为带动画效果的 LikeButton
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
