import 'dart:convert';

import 'package:chat_app/model/contact.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessage {
  // 聊天信息的数据结构
  String sender; // 发送者ID
  String message; // 单次聊天气泡数据记录
  String sendTime; // 该次聊天发送的时间
  String chatRoomID; // 关联聊天室

  ChatMessage({
    required this.sender,
    required this.message,
    required this.sendTime,
    required this.chatRoomID,
  });
}

// 最近消息列表 <chatRoomID, <lastMessage, latestMessageSendTime>>
Map<String, Map<String, dynamic>> latestMessageList = {};

// 从数据库上扒取最近消息列表并保存至本地
Future<void> spLoadAndSaveLatestMessageListFromDB() async {
  final dbInstance = Supabase.instance.client;

  // 获取所有聊天室的信息，包括 chatRoomID 和 latest_message_id
  final chatRoomsResponse = await dbInstance
      .from('chatRooms')
      .select('chat_room_id, latest_message_id')
      .contains('chat_user_email', [currentUser.email]);

  for (var room in chatRoomsResponse) {
    String chatRoomID = room['chat_room_id'];
    String latestMessageID = room['latest_message_id'];

    // 根据 latest_message_id 查询 chatMessages 表来获取最新消息内容和时间
    final messageResponse = await dbInstance
        .from('chatMessages')
        .select('message, send_time, sender')
        .eq('chat_message_id', latestMessageID)
        .single();

    String message = messageResponse['message'];
    String sendTime = DateTime.parse(messageResponse['send_time'])
        .toLocal()
        .toString()
        .substring(0, 19);

    // 保存最新消息及其发送时间到 latestMessageList
    latestMessageList[chatRoomID] = {
      'latestMessage': message,
      'latestMessageSendTime': sendTime,
    };
  }



  // 将获取的最新消息列表保存到本地 SharedPreferences
  await _saveLatestMessageListToLocal();
}

// 将最新消息列表保存到 SharedPreferences
Future<void> _saveLatestMessageListToLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 将 latestMessageList 转换为字符串并保存
  Map<String, String> stringMap = {};
  latestMessageList.forEach((key, value) {
    stringMap[key] =
        '${value['latestMessage']},${value['latestMessageSendTime']}';
  });

  // 保存至 SharedPreferences
  await prefs.setString(
      'latestMessageList/${currentUser.email}', stringMap.toString());
}

// 从 SharedPreferences 中加载本地存储的最新消息列表
Future<void> _loadLatestMessageListFromLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 获取保存的字符串
  String? savedData = prefs.getString('latestMessageList/${currentUser.email}');

  if (savedData != null) {
    // 将字符串转换回 Map 并解析
    Map<String, String> loadedData = Map.from(jsonDecode(savedData));

    loadedData.forEach((key, value) {
      List<String> parts = value.split(',');
      if (parts.length == 2) {
        latestMessageList[key] = {
          'latestMessage': parts[0],
          'latestMessageSendTime': parts[1],
        };
      }
    });
  }
}
