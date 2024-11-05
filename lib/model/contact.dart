import 'dart:convert';
import 'package:chat_app/model/chattile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
Future<void> spSaveContact(Contact person) async {
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

//保存从网络上扒取的联系人列表，要先执行spSaveContactEmailListFromDB()
Future<void> spLoadAndSaveContactListFromDB() async {
  final dbInstance = Supabase.instance.client;
  Contact tempContact;
  for (var i in contactEmailList) {
    final dbResponse =
        await dbInstance.from('profiles').select().eq('email', i).single();
    tempContact = Contact(
        contactName: dbResponse['user_name'],
        email: dbResponse['email'],
        avatarUrl: dbResponse['avatar_url']);
    contactList.add(tempContact);
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> saveList =
      contactList.map((contact) => json.encode(contact.toJson())).toList();
  await prefs.setStringList('contactList/$currentUserEmail', saveList);
}

//本地加载联系人列表
Future<List<Contact>> spLoadContactList() async {
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
Future<List<String>> spLoadContactEmailList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('contactEmailList/$currentUserEmail') ?? [];
}

//本地保存从网络上扒取的联系人邮箱列表
Future<void> spLoadAndSaveContactEmailListFromDB() async {
  final dbResponse = await Supabase.instance.client
      .from('contacts')
      .select()
      .eq('user_email', currentUserEmail)
      .single();
  contactEmailList = List<String>.from(dbResponse['contacts_email']);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
      'contactEmailList/$currentUserEmail', contactEmailList);
}

Future<void> saveContactToDB(String email) async {
  contactEmailList.add(email);
  try {
    await Supabase.instance.client.from('contacts').upsert({
      'user_email': currentUserEmail,
      'contacts_email': contactEmailList,
    });
    //双向添加好友
    final dbResponse = await Supabase.instance.client
        .from('contacts')
        .select()
        .eq('user_email', email)
        .single();
    List<String> tempList = dbResponse['contact_email']??[];
    tempList.add(currentUserEmail);
    await Supabase.instance.client.from('contacts').upsert({
      'user_email': email,
      'contacts_email': tempList,
    });
  } catch (e) {
    print(e);
  }
}
