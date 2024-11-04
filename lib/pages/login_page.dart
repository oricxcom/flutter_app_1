import 'package:flutter/material.dart';
import 'login_succ_view.dart';
import 'dart:async';
import 'fill_userinfo_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/gestures.dart';
import '../legal/privacy_policy.dart';
import '../legal/terms_of_service.dart';
import './reset_password_page.dart';

enum LoginPageStatus {
  pgChkEmail, // 检查邮箱阶段
  pgChkPwd, // 检查密码阶段Y
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
  String? _emailError; // 邮箱错误提示
  String? _passwordError; // 密码错误提示
  String? _codeError; // 验证码错误提示
  LoginPageStatus _pageStatus = LoginPageStatus.pgChkEmail; // 初始状态
  Timer? _timer;
  int _countDown = 60;
  bool _showCountDown = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '444615335740-rg44p8cl73sehcji1steok8oum1frafm.apps.googleusercontent.com',
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
  bool _isPasswordVisible = false;

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        if (account.email == "need_fill_user_info@qq.com") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const FillUserInfoView(),
            ),
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginSuccView(),
            ),
            (route) => false,
          );
        }
        print('Google Sign in succeeded: ${account.email}');
      }
    } catch (error) {
      print('Google Sign in failed: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Sign in failed. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _onEmailChanged(String value) {
    setState(() {
      _emailError = null;
    });

    if (_pageStatus != LoginPageStatus.pgChkEmail) {
      setState(() {
        _pageStatus = LoginPageStatus.pgChkEmail;
        _passwordController.clear();
        _verificationCodeController.clear();
      });
    }
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _passwordError = null;
    });
  }

  void _onVerificationCodeChanged(String value) {
    setState(() {
      _codeError = null;
    });
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
            _emailError =
                "We could not reach the email address you provided. Please try again with a different email.";
            _passwordError = null;
            _codeError = null;
          });
        } else if (email == "new@qq.com") {
          setState(() {
            _emailError = null;
            _passwordError = null;
            _codeError = null;
            _pageStatus = LoginPageStatus.pgChkValidateCode;
            _startCountDown();
          });
        } else {
          setState(() {
            _emailError = null;
            _passwordError = null;
            _codeError = null;
            _pageStatus = LoginPageStatus.pgChkPwd;
          });
        }
        break;

      case LoginPageStatus.pgChkPwd:
        final password = _passwordController.text;
        if (password == '123456') {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginSuccView(),
            ),
            (route) => false,
          );
        } else {
          setState(() {
            _emailError = null;
            _passwordError = "Invalid password";
            _codeError = null;
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
            _emailError = null;
            _passwordError = null;
            _codeError = "Invalid verification code";
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 根据页面状态确定按钮文本
    String buttonText = 'Continue';
    if (_pageStatus == LoginPageStatus.pgChkPwd) {
      buttonText = 'Continue with password';
    }

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
                    'Log in to your MotionG account',
                    style: const TextStyle(
                      fontSize: 18, // 可以根据需要调整这个值
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Google登录按钮
                  OutlinedButton(
                    onPressed: _handleGoogleSignIn,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/google_icon.png',
                            height: 24),
                        const SizedBox(width: 12),
                        const Text('Continue with Google'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 邮箱显示/输入
                  _buildEmailSection(),

                  const SizedBox(height: 16),

                  // 密码或验证码输入
                  if (_pageStatus == LoginPageStatus.pgChkPwd)
                    _buildPasswordSection(),

                  if (_pageStatus == LoginPageStatus.pgChkValidateCode)
                    _buildVerificationCodeSection(),

                  const SizedBox(height: 16),

                  // Continue 按钮
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _onContinuePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3440),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Terms and Conditions
                  _buildTermsAndConditions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 修改输入框部分的内边距
  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            errorText: _emailError,
            errorMaxLines: 2, // 允许错误信息最多显示2行
            errorStyle: const TextStyle(
              height: 1.2, // 调整行高
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: _onEmailChanged,
        ),
      ],
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                if (_passwordController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordController.clear();
                      });
                    },
                  ),
              ],
            ),
          ),
          onChanged: _onPasswordChanged,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_passwordError != null)
              Text(
                _passwordError!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              )
            else
              const SizedBox(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordPage(
                      email: _emailController.text,
                    ),
                  ),
                );
              },
              child: const Text(
                'Forgot your password?',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerificationCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verification Code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _verificationCodeController,
                decoration: InputDecoration(
                  hintText: 'Enter code from email',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  errorText: _codeError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                keyboardType: TextInputType.number,
                onChanged: _onVerificationCodeChanged,
              ),
            ),
          ],
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
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfServicePage(),
                  ),
                );
              },
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyPage(),
                  ),
                );
              },
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12),
    );
  }

  @override
  void dispose() {
    // 清理控制
    _emailController.dispose();
    _passwordController.dispose();
    _verificationCodeController.dispose();

    // 清理定时器
    _timer?.cancel();

    // 清状态
    _emailError = null;
    _passwordError = null;
    _codeError = null;
    _pageStatus = LoginPageStatus.pgChkEmail;
    _showCountDown = false;
    _countDown = 60;

    super.dispose();
  }
}
