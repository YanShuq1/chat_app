import 'package:chat_app/widgets/add_contact_button.dart';
import 'package:flutter/cupertino.dart';

class AddContactPage extends StatefulWidget {
  final VoidCallback onAdded;
  const AddContactPage({super.key, required this.onAdded});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  String searchingID = '';
  bool _tile = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("添加好友"),
      content: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: [
          Container(
            width: 300,
            height: 35,
            decoration: BoxDecoration(
                border:
                    Border.all(width: 1.0, color: CupertinoColors.systemGrey4),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5)),
            child: CupertinoSearchTextField(
              backgroundColor: CupertinoColors.systemGrey5,
              itemColor: CupertinoColors.activeBlue,
              itemSize: 18,
              style:
                  const TextStyle(fontSize: 15, color: CupertinoColors.black),
              onChanged: (value) => setState(() {
                searchingID = value;
                setState(() {
                  _tile = false;
                });
              }),
              onSubmitted: (value) {
                //TODO:提交搜索，添加好友逻辑实现
                if (value.isEmpty) {
                  setState(() {
                    _tile = false;
                  });
                } else {
                  setState(() {
                    _tile = true;
                  });
                }
              },
            ),
          ),
          if (_tile)
            CupertinoListTile(
              leadingToTitle: 5.0,
              //获取好友信息,获取数据库好友数据
              leading: Image.asset(
                'images/defaultAvatar.jpeg',
                width: 30,
                height: 30,
              ),
              title: Text(
                "好友[$searchingID]",
                style: const TextStyle(fontSize: 13),
              ),
              subtitle: Text(
                "chatID:$searchingID",
                style: const TextStyle(fontSize: 10),
              ),
              trailing: AddContactButton(
                chatID: searchingID,
                contactName: "$searchingID[好友]",
                onAdded: widget.onAdded,
              ),
            )
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text("取消"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text("提交搜索"),
          onPressed: () {
            //TODO:提交搜索，添加好友逻辑实现
            if (searchingID.isEmpty) {
              setState(() {
                _tile = false;
              });
            } else {
              setState(() {
                _tile = true;
              });
            }
          },
        ),
      ],
    );
  }
}
