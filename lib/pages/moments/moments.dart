import 'package:chat_app/pages/moments/shot/createshot.dart';
import 'package:chat_app/pages/moments/story/createStory.dart';
import 'package:chat_app/pages/moments/shot/shot.dart';
import 'package:chat_app/pages/moments/story/story.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyMomentsPage extends StatefulWidget {
  const MyMomentsPage({super.key});

  @override
  State<MyMomentsPage> createState() => _MyMomentsPageState();
}

class _MyMomentsPageState extends State<MyMomentsPage> {
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

            // 可展开的浮动按钮
            const Positioned(
              bottom: 16,
              right: 16,
              child: ExpandableFab(),
            ),
          ],
        ),
      ),
    );
  }
}

// 可展开的浮动按钮组件
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({super.key});

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 相机按钮
        Visibility(
          visible: _isExpanded,
          child: _buildExpandedButton(
            icon: Icons.camera_alt,
            heroTag: 'camera_button', // 为每个按钮指定唯一的 heroTag
            onPressed: () {
              // 跳转到 CreateShot 页面
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const CreateShot()),
              );
            },
          ),
        ),
        const SizedBox(height: 12), // 增大间距

        // 编辑按钮
        Visibility(
          visible: _isExpanded,
          child: _buildExpandedButton(
            icon: Icons.edit,
            heroTag: 'edit_button', // 为每个按钮指定唯一的 heroTag
            onPressed: () {
              // 跳转到 CreateStory 页面
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const CreateStory()),
              );
            },
          ),
        ),
        const SizedBox(height: 12), // 增大间距

        // 主浮动按钮
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded; // 切换展开状态
            });
          },
          backgroundColor: const Color.fromARGB(255, 168, 195, 224),
          heroTag: 'main_button', // 为主按钮指定一个唯一的 heroTag
          child: Icon(
            _isExpanded ? Icons.close : CupertinoIcons.add,
          ),
        ),
      ],
    );
  }

  // 构建展开的按钮，并放大尺寸
  Widget _buildExpandedButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String heroTag,
  }) {
    return SizedBox(
      width: 56, // 调整按钮宽度
      height: 56, // 调整按钮高度
      child: FloatingActionButton(
        backgroundColor: Colors.blue,
        heroTag: heroTag, // 设置唯一的 heroTag
        onPressed: onPressed,
        child: Icon(icon, color: Colors.white, size: 28), // 调整图标大小
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
