import 'package:chat_app/pages/chat/private/private_chat.dart';
import 'package:chat_app/widgets/contact_to_top_switch.dart';
import 'package:flutter/cupertino.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contactName});

  final String contactName;

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
        middle: const Text("好友信息"),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start, //水平方向居中对齐
          crossAxisAlignment: CrossAxisAlignment.center, //垂直方向从上到下
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Container(
              //用户头像和ID信息容器
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 2, color: CupertinoColors.systemGrey3))),
              padding: const EdgeInsets.fromLTRB(28.0, 20.0, 20.0, 0),
              height: 125,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                textDirection: TextDirection.ltr,
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/defaultAvatar.jpeg',
                    width: 90,
                    height: 90,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          contactName,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        //TODO:获取用户昵称和ID
                        const Text(
                          "昵称: ID",
                          style: TextStyle(
                            color: CupertinoColors.systemGrey2,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Text(
                          "Chat账号:ChatID",
                          style: TextStyle(
                            color: CupertinoColors.systemGrey2,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              //好友备注ListTile
              //TODO：onTap修改好友备注
              width: 340,
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: CupertinoColors.systemGrey5))),
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: CupertinoListTile(
                  leadingToTitle: 0,
                  title: const Text(
                    "设置好友备注 ",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        Text(
                          contactName,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.systemGrey3,
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.chevron_right,
                          color: CupertinoColors.systemGrey3,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              //好友Moment的ListTile
              //TODO:onTap进入好友Moment
              width: 340,
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: CupertinoColors.systemGrey5))),
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: const CupertinoListTile(
                  leadingToTitle: 0,
                  title: Text(
                    "好友Moment ",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    CupertinoIcons.chevron_right,
                    color: CupertinoColors.systemGrey3,
                  ),
                ),
              ),
            ),
            SizedBox(
              //好友置顶Switch
              //TODO:好友置顶函数
              width: 340,
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: CupertinoColors.systemGrey5))),
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: CupertinoListTile(
                  leadingToTitle: 0,
                  title: const Text(
                    "置顶聊天 ",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: ContactToTopSwitch(contactName: contactName),
                ),
              ),
            ),
            SizedBox(
              //清除聊天记录ListTile
              //TODO:清除聊天记录函数
              width: 340,
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: CupertinoColors.systemGrey5))),
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: const CupertinoListTile(
                  leadingToTitle: 0,
                  title: Text(
                    "清空聊天记录 ",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    CupertinoIcons.chevron_right,
                    color: CupertinoColors.systemGrey3,
                  ),
                ),
              ),
            ),
            SizedBox(
              //发消息ListTile
              width: 340,
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: CupertinoColors.systemGrey5))),
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: CupertinoListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        CupertinoIcons.ellipses_bubble,
                        color: CupertinoColors.black,
                        size: 20.0,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "发消息",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                PrivateChat(contactName: contactName)));
                  },
                ),
              ),
            ),
            SizedBox(
              //删除好友ListTile
              //TODO:删除好友函数
              width: 340,
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1, color: CupertinoColors.systemGrey5))),
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: const CupertinoListTile(
                  title: Center(
                    child: Text(
                      "删除好友",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.systemRed,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}