import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  //final _avatarPicker = ImagePicker(); //头像获取

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      // 检查用户是否成功注册
      if (response.user != null) {
        final userId = response.user!.id;

        // 插入用户的个人资料
        await Supabase.instance.client.from('profiles').insert({
          'user_id': userId,
          'email': email,
          'avatar_url':
              'https://cjvsombxqljpbexdpuvy.supabase.co/storage/v1/object/public/user_avatar/default_avatar/default_avatar.jpeg', // 默认头像Storage的URL
          'user_name': 'Unname User',
        });

        await Supabase.instance.client.from('contacts').upsert({
          'user_email': email,
          'contacts_email': [],
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString(); // 捕获并显示其他异常
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('注册'),
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
              onPressed: _register,
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
