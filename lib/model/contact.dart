import 'dart:convert';
import 'package:chat_app/model/chattile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contact {
  //联系人条目的数据结构
  String contactName;
  String avatarUrl;
  String email;
  Contact(
      {required this.contactName,
      required this.email,
      required this.avatarUrl});
}

extension ContactJson on Contact {
  //在chatpage中的格式转换逻辑
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'contactName': contactName,
    };
  }

  static Contact fromJson(Map<String, dynamic> json) {
    return Contact(
      email: json['email'],
      contactName: json['contactName'],
      avatarUrl: json['avatarUrl'] ?? 'null',
    );
  }
}

//联系人列表
List<Contact> contactList = [];

//联系人邮箱列表（以便数据库存储）
List<String> contactEmailList = [];

//保存联系人列表
Future<void> saveContact(Contact person) async {
  if (!(contactList.contains(person) ||
      contactEmailList.contains(person.email))) {
    contactList.add(person);
    contactEmailList.add(person.email);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> saveList =
        contactList.map((contact) => json.encode(contact.toJson())).toList();
    await prefs.setStringList('contactList/$currentUserEmail', saveList);
    await prefs.setStringList(
        'contactEmailList/$currentUserEmail', contactEmailList);
  }
}

//本地加载联系人列表
Future<List<Contact>> loadContactList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonList = prefs.getStringList('contactList/$currentUserEmail');
  if (jsonList == null) {
    return [];
  }
  return jsonList
      .map((json) => ContactJson.fromJson(jsonDecode(json)))
      .toList();
}

//本地加载联系人邮箱列表
Future<List<String>> loadContactEmailList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('contactEmailList/$currentUserEmail') ?? [];
}
