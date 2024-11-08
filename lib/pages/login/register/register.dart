import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _insurePasswordController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage; // 用于存储选中的图片
  String? _errorMessage;
  bool _isPickingImage = false; //防止重复点击头像选取

  Future<void> _pickImage() async {
    if (_isPickingImage) return; //正在选取，只保留一个进程

    setState(() {
      _isPickingImage = true;
    });
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // 可改为 ImageSource.camera 以使用相机拍照
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final userName = _userNameController.text.trim();
    final insurePassword = _insurePasswordController.text.trim();
    setState(() {
      _errorMessage = '';
    });

    if (password == insurePassword) {
      try {
        _errorMessage = null;

        // 注册用户
        final response = await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );

        if (response.user != null) {
          final userId = response.user!.id;
          String? avatarUrl;

          // 上传头像
          if (_selectedImage != null) {
            final fileName = 'avatar/$email.jpg';
            final fileBytes = await _selectedImage!.readAsBytes();
            Supabase.instance.client.storage
                .from('user_avatar') // Supabase 的存储桶名称
                .uploadBinary(fileName, fileBytes);

            avatarUrl = Supabase.instance.client.storage
                .from('user_avatar')
                .getPublicUrl(fileName);
          }

          // 插入用户的个人资料
          await Supabase.instance.client.from('profiles').insert({
            'user_id': userId,
            'email': email,
            'avatar_url': avatarUrl ??
                'https://cjvsombxqljpbexdpuvy.supabase.co/storage/v1/object/public/user_avatar/default_avatar/default_avatar.jpeg', //默认头像
            'user_name': userName.isEmpty ? "Unnamed User" : userName,
          });

          await Supabase.instance.client.from('contacts').upsert({
            'user_email': email,
            'contacts_email': [],
          });

        }
      } catch (e) {
        setState(() {
          _errorMessage = e.toString(); // 捕获并显示其他异常
        });
      } finally {
        if (_errorMessage == null) {
          Navigator.pop(context);
        }
      }
    } else {
      setState(() {
        _errorMessage = "确认密码与密码不一致！";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 头像选择
            GestureDetector(
              onTap: _isPickingImage ? null : _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor:
                    _selectedImage == null ? CupertinoColors.activeBlue : null,
                backgroundImage: _isPickingImage
                    ? null
                    : _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                child: _isPickingImage
                    ? const CircularProgressIndicator()
                    : _selectedImage == null
                        ? const Icon(
                            CupertinoIcons.photo_camera,
                            size: 45,
                            color: CupertinoColors.white,
                          )
                        : null,
              ),
            ),
            const SizedBox(height: 20),
            // 其他注册字段 (用户名、邮箱、密码等)
            _buildInputField(
                controller: _userNameController, placeholder: '用户名'),
            const SizedBox(height: 16),
            _buildInputField(controller: _emailController, placeholder: '邮箱'),
            const SizedBox(height: 16),
            _buildInputField(
                controller: _passwordController,
                placeholder: '密码',
                obscureText: true),
            const SizedBox(height: 16),
            _buildInputField(
                controller: _insurePasswordController,
                placeholder: '确认密码',
                obscureText: true),
            const SizedBox(height: 20),
            // 注册按钮
            CupertinoButton.filled(
              onPressed: _register,
              child: const Text('注册并返回'),
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

  Widget _buildInputField(
      {required TextEditingController controller,
      required String placeholder,
      bool obscureText = false}) {
    return Padding(
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
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          obscureText: obscureText,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
