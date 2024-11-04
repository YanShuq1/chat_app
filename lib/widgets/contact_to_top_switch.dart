import 'package:chat_app/model/chattile.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

//置顶聊天switch开关
class ContactToTopSwitch extends StatefulWidget {
  const ContactToTopSwitch({super.key, required this.chattile});

  final Chattile chattile;

  @override
  State<ContactToTopSwitch> createState() => _ContactToTopSwitchState();
}

class _ContactToTopSwitchState extends State<ContactToTopSwitch> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  //加载本地switch状态
  Future<void> _loadSwitchValue() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      _value = pref.getBool(widget.chattile.chatRoomID) ?? false; //若找不到状态，默认为false
    });
  }

  //保存switch状态到本地
  Future<void> _saveSwitchValue(bool value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(widget.chattile.chatRoomID, value);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
        value: _value,
        onChanged: (value) {
          setState(() {
            _value = value;
            _saveSwitchValue(_value);
          });
        });
  }
}
