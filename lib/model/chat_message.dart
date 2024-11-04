class ChatMessage {
  //聊天信息的数据结构
  String sender; //发送者ID
  String message; //单次聊天气泡数据记录
  String sendTime; //该次聊天发送的时间
  String chatRoomID;
  ChatMessage(
      {required this.sender,
      required this.message,
      required this.sendTime,
      required this.chatRoomID});
}

