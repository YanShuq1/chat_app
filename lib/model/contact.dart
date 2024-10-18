import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Contact {
  //联系人条目的数据结构
  String contactName;
  String chatID;
  Contact({required this.contactName, required this.chatID});
}

extension ContactJson on Contact {
  //在chatpage中的格式转换逻辑
  Map<String, dynamic> toJson() {
    return {
      'chatID': chatID,
      'contactName': contactName,
    };
  }

  static Contact fromJson(Map<String, dynamic> json) {
    return Contact(
      chatID: json['chatID'],
      contactName: json['contactName'],
    );
  }
}

//联系人列表
List<Contact> contactList = [];

//保存联系人列表
Future<void> saveContactList(Contact person) async {
  contactList.add(person);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> saveList =
      contactList.map((contact) => json.encode(contact.toJson())).toList();
  await prefs.setStringList('contactList', saveList);
}

//本地加载联系人列表
Future<List<Contact>> loadContactList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('contactList');
  if (jsonList == null) {
    return [];
  }
  return jsonList
          .map((json) => ContactJson.fromJson(jsonDecode(json)))
          .toList();
}
