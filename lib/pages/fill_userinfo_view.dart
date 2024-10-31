import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'login_succ_view.dart';

class FillUserInfoView extends StatefulWidget {
  const FillUserInfoView({super.key});

  @override
  State<FillUserInfoView> createState() => _FillUserInfoViewState();
}

class _FillUserInfoViewState extends State<FillUserInfoView> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('选择图片失败: $e');
    }
  }

  void _onContinue() {
    final nickname = _nicknameController.text;
    final password = _passwordController.text;

    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入昵称')),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请设置密码')),
      );
      return;
    }

    // TODO: 处理用户信息保存
    debugPrint('保存用户信息: 昵称=$nickname, 头像=${_imageFile?.path}');

    // 保存后导航到登录成功页面
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginSuccView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('完善个人信息'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 头像选择
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? const Icon(Icons.add_a_photo, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 30),

            // 昵称输入
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '昵称',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),

            // 密码输入
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '设置密码',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),

            // Continue 按钮
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onContinue,
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
