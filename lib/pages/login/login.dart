import 'package:chat_app/model/chat_message.dart';
import 'package:chat_app/model/chattile.dart';
import 'package:chat_app/model/contact.dart';
import 'package:chat_app/pages/home/home.dart';
import 'package:chat_app/pages/login/register/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool isAgreed = false;

  Future<void> _login() async {
    if (!isAgreed) {
      _showAgreementWarning();
      return;
    }
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      currentUser.email = _emailController.text.trim();
      //从数据库同步信息并本地保存
      spLoadAndSaveContactEmailListFromDB();
      spLoadAndSaveContactListFromDB();
      spLoadAndSaveChatListFromDB();
      spLoadAndSaveLatestMessageListFromDB();
      Navigator.push(context,
          CupertinoPageRoute(builder: (context) => const MyHomePage()));
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _showAgreementWarning() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("提示"),
          content: Text("请勾选同意《用户协议》和《隐私政策》"),
          actions: [
            CupertinoDialogAction(
              child: Text("确定"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 应用名称
            Text(
              'ChatApp',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 30),
            // 邮箱输入框
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CupertinoTextField(
                  controller: _emailController,
                  placeholder: '邮箱',
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 密码输入框
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CupertinoTextField(
                  controller: _passwordController,
                  placeholder: '密码',
                  obscureText: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // 用户协议复选框
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 25),
                Material(
                  color: Colors.white,
                  child: Transform.scale(
                    scale: 0.8, // 将 scale 设置为小于1的值，比如 0.8 表示缩小到80%
                    child: Checkbox(
                      value: isAgreed,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isAgreed = newValue ?? false;
                        });
                      },
                    ),
                  ),
                ),
                // const SizedBox(width: 0.5),
                Expanded(
                  child: Text(
                    '登录/注册表示您同意《用户协议》和《隐私政策》',
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 登录按钮
            SizedBox(
              width: 200,
              child: CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: _login,
                child: const Text(
                  '登录',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 注册按钮
            SizedBox(
              width: 200,
              child: CupertinoButton(
                color: CupertinoColors.activeBlue.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text(
                  '注册',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
