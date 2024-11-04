import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Chattile {
  //ChatPage中的消息栏数据结构
  String contactName;
  String email;
  String chatRoomID;
  String avatarUrl;
  Chattile(
      {required this.email,
      required this.contactName,
      required this.chatRoomID,required this.avatarUrl});
}

extension ChattileJson on Chattile {
  //在chatpage中的格式转换逻辑
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'contactName': contactName,
    };
  }

  static Chattile fromJson(Map<String, dynamic> json) {
    return Chattile(
        email: json['email'] ?? 'Empty email',
        contactName: json['contactName'] ?? 'Unnamed User',
        chatRoomID: json['chatRoomID'] ?? 'Null', 
        avatarUrl: json['avatarUrl']?? 'null');
  }
}

late String currentUserEmail;

//聊天栏列表
List<Chattile> chatList = [];

//本地加载ChatList
Future<List<Chattile>> loadChatList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('chatList/$currentUserEmail');
  return jsonList
          ?.map((json) => ChattileJson.fromJson(jsonDecode(json)))
          .toList() ??
      [];
}

//本地保持ChatList
Future<void> saveChatList(Chattile tile) async {
  if (!chatList.contains(tile)) {
  chatList.add(tile);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> saveList =
      chatList.map((chat) => json.encode(chat.toJson())).toList();
  await prefs.setStringList('chatList/$currentUserEmail', saveList);
}
}
