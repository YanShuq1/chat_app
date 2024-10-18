import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Chattile {
  //ChatPage中的消息栏数据结构
  String contactName;
  String chatID;
  Chattile({required this.chatID, required this.contactName});
}

extension ChattileJson on Chattile {
  //在chatpage中的格式转换逻辑
  Map<String, dynamic> toJson() {
    return {
      'chatID': chatID,
      'contactName': contactName,
    };
  }

  static Chattile fromJson(Map<String, dynamic> json) {
    return Chattile(
      chatID: json['chatID'],
      contactName: json['contactName'],
    );
  }
}

//聊天栏列表
List<Chattile> chatList = [];

  //本地加载ChatList
  Future<List<Chattile>> loadChatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('chatList');
    return jsonList
            ?.map((json) => ChattileJson.fromJson(jsonDecode(json)))
            .toList() ??
        [];
  }

  //本地保持ChatList
  Future<void> saveChatList(Chattile tile) async {
    chatList.add(tile);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> saveList =
        chatList.map((chat) => json.encode(chat.toJson())).toList();
    await prefs.setStringList('chatList', saveList);
  }