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

// 带动画效果的 LikeButton
class LikeButtonWithAnimation extends StatefulWidget {
  const LikeButtonWithAnimation({super.key});

  @override
  _LikeButtonWithAnimationState createState() =>
      _LikeButtonWithAnimationState();
}

class _LikeButtonWithAnimationState extends State<LikeButtonWithAnimation>
    with TickerProviderStateMixin {
  bool isLiked = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<OverlayEntry> _overlayEntries = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: -50).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    if (isLiked) {
      // 仅在点赞时显示爱心动画
      _showHeartAnimation();
    }
  }

  void _showHeartAnimation() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final buttonPosition = renderBox?.localToGlobal(Offset.zero);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedHeart(
          animation: _animation,
          startPosition: buttonPosition!,
          onComplete: () {
            _overlayEntries.remove(overlayEntry);
            overlayEntry.remove();
          },
        );
      },
    );

    overlay?.insert(overlayEntry);
    _overlayEntries.add(overlayEntry);
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    for (var overlay in _overlayEntries) {
      overlay.remove();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: isLiked ? Colors.red : Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: CupertinoColors.systemGrey3),
        ),
      ),
      onPressed: _toggleLike,
      icon: Icon(
        isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
        color: isLiked ? Colors.red : Colors.blue,
      ),
      label: Text(
        'Like',
        style: TextStyle(
          color: isLiked ? Colors.red : Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// 升起爱心动画小部件
class AnimatedHeart extends StatelessWidget {
  final Animation<double> animation;
  final Offset startPosition;
  final VoidCallback onComplete;

  const AnimatedHeart({
    super.key,
    required this.animation,
    required this.startPosition,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: startPosition.dx,
      top: startPosition.dy - 40,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
            opacity: 1 - animation.value / -50,
            child: Transform.translate(
              offset: Offset(0, animation.value),
              child: Icon(
                CupertinoIcons.heart_fill,
                color: Colors.red,
                size: 30,
              ),
            ),
          );
        },
        child: Container(),
      ),
    );
  }
}
