import 'package:flutter/cupertino.dart';

class Shot extends StatelessWidget {
  const Shot({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _buildShotItem('images/avatar1.jpeg'),
        _buildShotItem('images/avatar2.jpg'),
        _buildShotItem('images/avatar3.jpg'),
        _buildShotItem('images/avatar4.jpg'),
      ],
    );
  }

  // 构建Shot的图片项目
  Widget _buildShotItem(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          width: 100, // 图片宽度
          height: 100, // 图片高度
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
