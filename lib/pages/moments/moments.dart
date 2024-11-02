import 'package:chat_app/pages/moments/shot/shot.dart';
import 'package:chat_app/pages/moments/story/story.dart';
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
            const SingleChildScrollView(
              padding: EdgeInsets.only(top: 60), // 给搜索框留出空间
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shot Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                    child: Shot(), // 使用 Shot Widget
                  ),

                  // Story Section
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Story',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Story(), // 使用 Story Widget
                ],
              ),
            ),

            // 搜索栏
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SearchBar(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
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
                backgroundColor: const Color.fromARGB(255, 168, 195, 224),
                child: const Icon(CupertinoIcons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SearchBar: 自定义搜索栏小部件
class SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9, // 设置透明度为90%
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CupertinoSearchTextField(
          onChanged: onChanged,
          onSubmitted: (value) {
            // 处理搜索提交逻辑
          },
          backgroundColor: CupertinoColors.systemGrey.withOpacity(0.3),
          placeholder: "Search...", // 提示文字
        ),
      ),
    );
  }
}

// CustomDivider: 自定义分割线小部件
class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 1,
      color: CupertinoColors.separator,
    );
  }
}
