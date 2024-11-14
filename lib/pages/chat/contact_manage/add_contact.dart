import 'package:chat_app/model/contact.dart';
import 'package:chat_app/widgets/add_contact_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddContactPage extends StatefulWidget {
  final VoidCallback onAdded;
  const AddContactPage({super.key, required this.onAdded});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  String searchingEmail = '';
  bool _tile = false;
  Map<String, dynamic>? user;

  String? _errorMessage = null;

  Future<void> searchForFriend(String email) async {
    try {
      setState(() {
        _errorMessage = null;
      });
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('email', email)
          .single();
      user = response;
      setState(() {
        _tile = true;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _tile = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("添加好友"),
      content: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 380,
            height: 40,
            decoration: BoxDecoration(
              border:
                  Border.all(width: 1.0, color: CupertinoColors.systemGrey4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CupertinoSearchTextField(
              onChanged: (value) {
                setState(() {
                  searchingEmail = value;
                  _tile = false;
                });
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) searchForFriend(value);
              },
            ),
          ),
          if (_tile && user != null)
            CupertinoListTile(
              leading: user!['avatar_url'] != null
                  ? Image.network(user!['avatar_url'], width: 20, height: 20)
                  : const Icon(CupertinoIcons.person),
              title: Text(user!['user_name'],
                  style: const TextStyle(fontSize: 13)),
              subtitle:
                  Text(user!['email'], style: const TextStyle(fontSize: 10)),
              trailing: AddContactButton(
                contact: Contact(
                  contactName: user!['user_name'],
                  email: user!['email'],
                  avatarUrl: user!['avatar_url'],
                ),
                onAdded: widget.onAdded,
              ),
            ),
          if (_tile == false && _errorMessage != null)
            CupertinoListTile(
              leadingToTitle: 0,
                title: Text(
              _errorMessage.toString(),
              style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 8),
            )),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text("取消"),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: const Text("提交搜索"),
          onPressed: () {
            if (searchingEmail.isNotEmpty) {
              searchForFriend(searchingEmail);
            }
          },
        ),
      ],
    );
  }
}
