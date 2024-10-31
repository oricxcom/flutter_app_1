import 'package:flutter/material.dart';
import 'login_succ_view.dart';
import 'dart:async';
import 'fill_userinfo_view.dart';

enum LoginPageStatus {
  pgChkEmail, // 检查邮箱阶段
  pgChkPwd, // 检查密码阶段
  pgChkValidateCode // 检查验证码阶段
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  String? _errorText;
  LoginPageStatus _pageStatus = LoginPageStatus.pgChkEmail; // 初始状态
  Timer? _timer;
  int _countDown = 60;
  bool _showCountDown = false;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _onEmailChanged(String value) {
    if (_pageStatus != LoginPageStatus.pgChkEmail) {
      setState(() {
        _pageStatus = LoginPageStatus.pgChkEmail;
        _passwordController.clear();
        _verificationCodeController.clear();
        _errorText = null;
      });
    }
  }

  void _startCountDown() {
    setState(() {
      _showCountDown = true;
      _countDown = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDown > 0) {
          _countDown--;
        } else {
          _showCountDown = false;
          timer.cancel();
        }
      });
    });
  }

  void _onContinuePressed() {
    final email = _emailController.text;

    switch (_pageStatus) {
      case LoginPageStatus.pgChkEmail:
        if (!_isValidEmail(email)) {
          setState(() {
            _errorText = "Email is not reachable, please check and retry.";
          });
        } else if (email == "new@qq.com") {
          setState(() {
            _errorText = null;
            _pageStatus = LoginPageStatus.pgChkValidateCode;
            _startCountDown();
          });
        } else {
          setState(() {
            _errorText = null;
            _pageStatus = LoginPageStatus.pgChkPwd;
          });
        }
        break;

      case LoginPageStatus.pgChkPwd:
        final password = _passwordController.text;
        if (password == '123456') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginSuccView(),
            ),
          );
        } else {
          setState(() {
            _errorText = "Invalid password";
          });
        }
        break;

      case LoginPageStatus.pgChkValidateCode:
        final verificationCode = _verificationCodeController.text;
        if (verificationCode == '666666') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const FillUserInfoView(),
            ),
          );
        } else {
          setState(() {
            _errorText = "Invalid verification code";
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 邮箱输入框（始终显示）
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: _onEmailChanged,
              ),
              const SizedBox(height: 20),

              // 密码输入框（仅在检查密码阶段显示）
              if (_pageStatus == LoginPageStatus.pgChkPwd) ...[
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
              ],

              // 验证码输入框（仅在验证码阶段显示）
              if (_pageStatus == LoginPageStatus.pgChkValidateCode) ...[
                TextField(
                  controller: _verificationCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Verification Code',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                if (_showCountDown)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'We sent a code to your inbox. Resend in ${_countDown}S',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 20),
              ],

              ElevatedButton(
                onPressed: _onContinuePressed,
                child: const Text('Continue'),
              ),

              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }
}
