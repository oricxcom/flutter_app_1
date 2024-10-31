import 'package:flutter/material.dart';
import 'test_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorText;
  bool _showPassword = false;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _onEmailChanged(String value) {
    if (_showPassword) {
      setState(() {
        _showPassword = false;
        _passwordController.clear();
        _errorText = null;
      });
    }
  }

  void _onContinuePressed() {
    if (!_showPassword) {
      setState(() {
        if (!_isValidEmail(_emailController.text)) {
          _errorText = "Email is not reachable, please check and retry.";
          _showPassword = false;
          _passwordController.clear();
        } else {
          _errorText = null;
          _showPassword = true;
        }
      });
    } else {
      final email = _emailController.text;
      final password = _passwordController.text;

      if (email.isNotEmpty && password == '123456') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TestView(),
          ),
        );
      } else {
        setState(() {
          _errorText = "Invalid password";
        });
      }
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
              if (_showPassword) ...[
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
