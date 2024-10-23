import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyMomemntsPage extends StatefulWidget {
  const MyMomemntsPage({super.key});

  @override
  State<MyMomemntsPage> createState() => _MyMomemntsPageState();
}

class _MyMomemntsPageState extends State<MyMomemntsPage> {
  String _searchQuery = ''; // 保存搜索输入的内容

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Moment"),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // 背景内容可以滚动
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 60), // 给搜索框留出空间
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shot Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Shot',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120, // Shot图片的高度
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildShotItem('images/avatar1.jpeg'),
                        _buildShotItem('images/avatar2.jpg'),
                        _buildShotItem('images/avatar3.jpg'),
                        _buildShotItem('images/avatar4.jpg'),
                      ],
                    ),
                  ),

                  // Story Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Story',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // 禁用滚动让外层滚动生效
                    itemCount: 10, // 示例内容的个数
                    itemBuilder: (context, index) {
                      return _buildStoryItem();
                    },
                  ),
                ],
              ),
            ),

            // 搜索栏固定在顶部，并且设置透明度
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.9, // 设置透明度为90%
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CupertinoSearchTextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onSubmitted: (value) {
                      // 处理搜索提交逻辑
                    },
                    backgroundColor: CupertinoColors.systemGrey
                        .withOpacity(0.3), // 搜索框的背景颜色透明度
                    placeholder: "Search...", // 提示文字
                  ),
                ),
              ),
            ),

            // Add Button (发布按钮)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  // 发布Shot或Story的逻辑
                },
                backgroundColor: CupertinoColors.activeBlue,
                child: Icon(CupertinoIcons.add),
              ),
            ),
          ],
        ),
      ),
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

  // 构建Story的项目
  Widget _buildStoryItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('images/avatar1.jpeg'),
                radius: 24,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            ],
          ),
          SizedBox(height: 10),
          Text("月色好美!!!"),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'images/avatar1.jpeg',
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
