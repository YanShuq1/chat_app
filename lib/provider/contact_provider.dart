import 'dart:convert';
import 'package:chat_app/model/chattile.dart';
import 'package:chat_app/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  Future<void> loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('contactList');
    if (jsonList != null) {
      _contacts = jsonList
          .map((json) => ContactJson.fromJson(jsonDecode(json)))
          .toList();
      notifyListeners(); // 通知监听者
    }
  }

  Future<void> addContact(Contact contact) async {
    _contacts.add(contact);
    await spSaveContact(contact);
    notifyListeners(); // 通知监听者
  }

  Future<void> freshContact()  async{
    await spLoadAndSaveChatListFromDB();
    notifyListeners();
  }
  // Future<void> saveContactList(Contact person) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> saveList = _contacts.map((contact) => json.encode(contact.toJson())).toList();
  //   await prefs.setStringList('contactList', saveList);
  // }
}
