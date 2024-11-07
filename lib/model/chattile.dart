import 'dart:convert';
import 'package:chat_app/model/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Chattile {
  //ChatPage中的消息栏数据结构
  String contactName;
  String email;
  String chatRoomID;
  String avatarUrl;
  Chattile(
      {required this.email,
      required this.contactName,
      required this.chatRoomID,
      required this.avatarUrl});
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
        avatarUrl: json['avatarUrl'] ?? 'null');
  }
}

//聊天栏列表
List<Chattile> chatList = [];

//本地加载ChatList
Future<List<Chattile>> spLoadChatList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('chatList/${currentUser.email}');
  return jsonList
          ?.map((json) => ChattileJson.fromJson(jsonDecode(json)))
          .toList() ??
      [];
}

//本地保持ChatList
Future<void> spSaveChatList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> saveList =
      chatList.map((chat) => json.encode(chat.toJson())).toList();
  await prefs.setStringList('chatList/${currentUser.email}', saveList);
}

 Future<void> spLoadAndSaveChatListFromDB() async {
    chatList.clear(); // 避免重复数据
    final dbResponse = await Supabase.instance.client
        .from('chatRooms')
        .select()
        .contains('chat_user_email', [currentUser.email]);

    for (var room in dbResponse) {
      String chatRoomID = room['chat_room_id'];
      List<dynamic> userEmails = room['chat_user_email'];

      // 查找当前用户之外的邮箱
      String? otherUserEmail = userEmails.firstWhere(
        (email) => email != currentUser.email,
        orElse: () => null,
      );

      if (otherUserEmail != null) {
        // 查询对方用户的资料
        final profileResponse = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('email', otherUserEmail)
            .single();

        if (!chatList.any((chat) => chat.chatRoomID == chatRoomID)) {
          // 如果列表中没有该聊天室，才添加
          chatList.add(Chattile(
            contactName: profileResponse['user_name'] ?? 'Unnamed User',
            email: profileResponse['email'] ?? '',
            chatRoomID: chatRoomID,
            avatarUrl: profileResponse['avatar_url'] ?? '',
          ));
        }
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> saveList =
        chatList.map((chat) => json.encode(chat.toJson())).toList();
    await prefs.setStringList('chatList/${currentUser.email}', saveList);
  }

//数据库上保存聊天室信息
Future<void> saveChatListToDB() async {
  if (chatList.isNotEmpty) {
    // 使用 Future 列表存储每个异步请求
    List<Future> futures = [];

    for (var i in chatList) {
      futures.add(Supabase.instance.client.from('chatRooms').upsert({
        'chat_room_id': i.chatRoomID,
        'chat_user_email': [currentUser.email, i.email],
      }));
    }

    // 等待所有请求完成
    await Future.wait(futures);
  }
}
