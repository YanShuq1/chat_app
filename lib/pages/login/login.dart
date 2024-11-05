import 'package:chat_app/model/chattile.dart';
import 'package:chat_app/model/contact.dart';
import 'package:chat_app/pages/home/home.dart';
import 'package:chat_app/pages/login/register/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      currentUser.email = _emailController.text.trim();
      spLoadAndSaveContactEmailListFromDB();
      spLoadAndSaveContactListFromDB();
      spLoadAndSaveChatListFromDB();
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => const MyHomePage()));
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('登录'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextField(
              controller: _emailController,
              placeholder: '邮箱',
            ),
            const SizedBox(height: 16),
            CupertinoTextField(
              controller: _passwordController,
              placeholder: '密码',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              onPressed: _login,
              child: const Text('登录'),
            ),
            const SizedBox(
              height: 12,
            ),
            CupertinoButton.filled(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const RegisterPage()));
              },
              child: const Text('注册'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_errorMessage!,
                    style: const TextStyle(color: CupertinoColors.systemRed)),
              ),
          ],
        ),
      ),
    );
  }
}
