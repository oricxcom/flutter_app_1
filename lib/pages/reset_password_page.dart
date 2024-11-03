import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _verificationCodeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  String? _codeError;
  String? _passwordError;
  Timer? _timer;
  int _countDown = 60;
  bool _showCountDown = false;
  bool _isLengthValid = false;
  bool _hasRequiredTypes = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _startCountDown(); // 页面加载时自动开始倒计时
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

  void _onResetPassword() {
    final verifyCode = _verificationCodeController.text;
    final password = _newPasswordController.text;

    setState(() {
      _codeError = null;
      _passwordError = null;
    });

    bool hasError = false;

    // Check if the verification code is empty or not equal to 666666
    if (verifyCode.isEmpty || verifyCode != '666666') {
      setState(() {
        _codeError = "Invalid verification code";
      });
      hasError = true;
    }

    // Check if the password meets the requirements
    if (!_isPasswordValid(password)) {
      setState(() {
        _passwordError = "Password does not meet the requirements";
      });
      hasError = true;
    }

    if (hasError) return;

    // Show success message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text(
              'Password reset successful. Click OK to log in again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(), // 确保 LoginPage 已导入
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _isPasswordValid(String password) {
    return _isLengthValid && _hasRequiredTypes;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset your password',
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email (只读)
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 验证码
                  const Text(
                    'Verification code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _verificationCodeController,
                    onChanged: (value) {
                      setState(() {
                        _codeError = null;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter code from your email',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      errorText: _codeError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'We sent a code to your inbox',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const Text(' · '),
                      if (_showCountDown)
                        Text(
                          'Resend in ${_countDown}s',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: _startCountDown,
                          child: const Text(
                            'Resend',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 新密码
                  const Text(
                    'New password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: !_isPasswordVisible,
                    onChanged: _checkPassword,
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      errorText: _passwordError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
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
                                _newPasswordController.clear();
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
                  const SizedBox(height: 24),

                  // Reset Password 按钮
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _onResetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3440),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Reset password',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
    _verificationCodeController.dispose();
    _newPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
