import 'package:flutter/foundation.dart';  // Add for ChangeNotifier
import 'package:chat_app/model/chattile.dart'; // Add import for Chattile model

class ChatProvider extends ChangeNotifier {
  final List<Chattile> _chatList = [];
  List<Chattile> get chatList => _chatList;

  // 加载聊天列表（本地存储 + 从数据库同步）
  Future<void> loadChatList() async {
    await spLoadAndSaveChatListFromDB();  // Load chat list from DB
    notifyListeners(); // Notify listeners to update UI
  }

  // 更新聊天列表
  void updateChatList(Chattile chat) {
    _chatList.add(chat);
    notifyListeners();
  }

  // 删除聊天
  void deleteChat(int index) {
    _chatList.removeAt(index);
    notifyListeners();
  }
}
