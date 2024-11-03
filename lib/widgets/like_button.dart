// 带动画效果的 LikeButton
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

    overlay.insert(overlayEntry);
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
