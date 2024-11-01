import 'package:chat_app/provider/contact_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:lpinyin/lpinyin.dart';

class MyContactsPage extends StatefulWidget {
  const MyContactsPage({super.key});

  @override
  State<MyContactsPage> createState() => _MyContactsPageState();
}

class _MyContactsPageState extends State<MyContactsPage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // 在此加载联系人列表
    //Provider.of<ContactProvider>(context, listen: false).loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);

    String? currentLetter;

    // 按照拼音首字母排序
    contactProvider.contacts.sort((a, b) =>
        PinyinHelper.getFirstWordPinyin(a.contactName).toUpperCase().compareTo(
            PinyinHelper.getFirstWordPinyin(b.contactName).toUpperCase()));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Contacts"),
      ),
      child: CupertinoScrollbar(
        controller: _controller,
        child: ListView(
          controller: _controller,
          children: [
            for (var i in contactProvider.contacts)
              () {
                String firstLetter =
                    PinyinHelper.getFirstWordPinyin(i.contactName)[0]
                        .toUpperCase();
                if (currentLetter != firstLetter) {
                  currentLetter = firstLetter;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: CupertinoListTile(
                          title: Text(currentLetter!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          backgroundColor: CupertinoColors.systemGrey5,
                        ),
                      ),
                      CupertinoListTile(
                        leading: const Icon(CupertinoIcons.person),
                        title: Text(i.contactName),
                        onTap: () {},
                      ),
                    ],
                  );
                } else {
                  return CupertinoListTile(
                    leading: const Icon(CupertinoIcons.person),
                    title: Text(i.contactName),
                    onTap: () {},
                  );
                }
              }(),
          ],
        ),
      ),
    );
  }
}
