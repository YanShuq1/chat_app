import 'package:chat_app/model/chat_message.dart';
import 'package:chat_app/widgets/contact_card_gesture_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 引入 Firebase Firestore 库
import 'package:firebase_auth/firebase_auth.dart'; // 引入 Firebase Authentication 库
import 'package:flutter/material.dart';

class PrivateChat extends StatefulWidget {
  const PrivateChat({
    super.key,
    required this.contactName,
    required this.chatID,
  });

  final String contactName;
  final String chatID;

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  final ScrollController _controller = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentUserID;

  Future<String?> _getCurrentUserID() async {
    return _auth.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: "返回",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Text(widget.contactName),
        trailing: ContactCardGestureDetector(
          contactName: widget.contactName,
          chatID: widget.chatID,
        ),
      ),
      child: FutureBuilder<String?>(
        future: _getCurrentUserID(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("用户未登录"));
          }

          currentUserID = snapshot.data;

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: CupertinoNavigationBarBackButton(
                previousPageTitle: "返回",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              middle: Text(widget.contactName),
              trailing: ContactCardGestureDetector(
                contactName: widget.contactName,
                chatID: widget.chatID,
              ),
            ),
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestore
                  .collection('chatRooms')
                  .doc(widget.chatID)
                  .collection('messages')
                  .orderBy('sendTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading messages'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs.map((doc) {
                  final data = doc.data();
                  return ChatMessage(
                    sender: data['senderId'],
                    receiver: data['receiverId'],
                    message: data['message'],
                    sendTime: data['sendTime'],
                  );
                }).toList();

                return CupertinoScrollbar(
                  thickness: 5.0,
                  thicknessWhileDragging: 10.0,
                  radius: const Radius.circular(1.5),
                  radiusWhileDragging: const Radius.circular(2.0),
                  scrollbarOrientation: ScrollbarOrientation.right,
                  controller: _controller,
                  thumbVisibility: true,
                  child: ListView.builder(
                    reverse: true, // 倒序显示消息
                    controller: _controller,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageItem(message);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    // 判断消息发送者是否为当前用户
    final isCurrentUser = message.sender == currentUserID;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      alignment: isCurrentUser ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.message,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 4.0),
          Text(
            message.sendTime,
            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
