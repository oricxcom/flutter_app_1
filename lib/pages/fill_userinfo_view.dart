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
  String? _nicknameError;
  String? _passwordError;

  bool _isPasswordVisible = false;
  bool _isLengthValid = false;
  bool _hasRequiredTypes = false;

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

  void _checkPassword(String password) {
    setState(() {
      _passwordError = null;
      _isLengthValid = password.length >= 8 && password.length <= 32;

      bool hasDigit = password.contains(RegExp(r'[0-9]'));
      bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
      bool hasSpecialChar =
          password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      int typeCount = 0;
      if (hasDigit) typeCount++;
      if (hasUpperCase || hasLowerCase) typeCount++;
      if (hasSpecialChar) typeCount++;

      _hasRequiredTypes = typeCount >= 2;
    });
  }

  void _onContinue() {
    setState(() {
      _nicknameError = null;
      _passwordError = null;
    });

    final nickname = _nicknameController.text;
    final password = _passwordController.text;

    bool hasError = false;

    if (nickname.isEmpty) {
      setState(() {
        _nicknameError = 'Please enter a nickname';
      });
      hasError = true;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Please set a password';
      });
      hasError = true;
    } else if (!(_isLengthValid && _hasRequiredTypes)) {
      setState(() {
        _passwordError = 'Password does not meet the requirements';
      });
      hasError = true;
    }

    if (hasError) return;

    debugPrint('保存用户信息: 昵称=$nickname, 头像=${_imageFile?.path}');

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
        title: const Text(
          'MotionG APP',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Create a profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'This is how you\'ll appear in MotionG',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : const AssetImage('assets/images/tx1.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Add a photo',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Nickname',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'This is your default display name',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _nicknameController,
                    decoration: InputDecoration(
                      hintText: 'A name you want others to call you',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _nicknameError,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Set a password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    onChanged: _checkPassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorText: _passwordError,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _passwordController.clear();
                                _checkPassword('');
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordRule(
                      'A string of 8 to 32 characters', _isLengthValid),
                  _buildPasswordRule(
                      'Including digits, case, and special characters',
                      _hasRequiredTypes),
                  _buildPasswordRule(
                      'At least 2 or more types should be included',
                      _hasRequiredTypes),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _onContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E2E2E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildPasswordRule(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isValid ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isValid ? Colors.green : Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
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
