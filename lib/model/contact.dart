import 'dart:convert';
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

Contact currentUser = Contact(
    email: '',
    contactName: 'Unnamed User',
    avatarUrl:
        'https://cjvsombxqljpbexdpuvy.supabase.co/storage/v1/object/public/user_avatar/default_avatar/default_avatar.jpeg');

Future<void> loadCurrentUser() async {
  //同步登录用户
  final loginResponse = await Supabase.instance.client
      .from('profiles')
      .select()
      .eq('email', currentUser.email)
      .single();
  currentUser.avatarUrl = loginResponse['avatar_url'];
  currentUser.contactName = loginResponse['user_name'];
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
  if (!(contactEmailList.any((i) => i == person.email))) {
    contactList.add(person);
    contactEmailList.add(person.email);
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> saveList =
      contactList.map((contact) => json.encode(contact.toJson())).toList();
  await prefs.setStringList('contactList/${currentUser.email}', saveList);
  await prefs.setStringList(
      'contactEmailList/${currentUser.email}', contactEmailList);
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
    if (!contactList.any((i) => i.email == tempContact.email)) {
      contactList.add(tempContact);
    }
  }
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> saveList =
      contactList.map((contact) => json.encode(contact.toJson())).toList();
  await prefs.setStringList('contactList/${currentUser.email}', saveList);
}

//本地加载联系人列表
Future<List<Contact>> spLoadContactList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? jsonList =
      prefs.getStringList('contactList/${currentUser.email}');
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
  return prefs.getStringList('contactEmailList/${currentUser.email}') ?? [];
}

//本地保存从网络上扒取的联系人邮箱列表
Future<void> spLoadAndSaveContactEmailListFromDB() async {
  contactEmailList.clear();
  final dbResponse = await Supabase.instance.client
      .from('contacts')
      .select('contacts_email')
      .eq('user_email', currentUser.email).single();
  contactEmailList = List<String>.from(dbResponse['contacts_email']);
  print("contactEmailList:$contactEmailList");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
      'contactEmailList/${currentUser.email}', contactEmailList);
}

Future<void> saveContactToDB(Contact contact) async {
  try {
    contactEmailList.add(contact.email);
    print(contactEmailList);
    await Supabase.instance.client.from('contacts').upsert({
      'user_email': currentUser.email,
      'contacts_email': contactEmailList,
    });
    contactList.add(contact);
    //双向添加好友
    final dbResponse = await Supabase.instance.client
        .from('contacts')
        .select()
        .eq('user_email', contact.email)
        .single();
    // print(dbResponse);
    List<String> tempList = List<String>.from(dbResponse['contacts_email']);
    tempList.add(currentUser.email);
    print(contactEmailList);
    await Supabase.instance.client.from('contacts').upsert({
      'user_email': contact.email,
      'contacts_email': tempList,
    });
  } catch (e) {
    print(e);
  }
}
