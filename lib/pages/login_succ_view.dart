import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'login_page.dart';

class LoginSuccView extends StatelessWidget {
  const LoginSuccView({super.key});

  String generateSignature(Map<String, String> params, String secretKey) {
    final sortedKeys = params.keys.toList()..sort();

    final signStr =
        sortedKeys.map((key) => '$key=${params[key]}').join('&') + secretKey;

    debugPrint('生成的签名: $signStr');

    return md5.convert(utf8.encode(signStr)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试页面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final params = {
                  'uid': '1234',
                  'nickname': 'martin',
                  'language': 'ZH',
                  'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                };

                final signature =
                    generateSignature(params, '32fffaf_afdd3jaf_j230933_P3cc');
                params['sign'] = signature;

                final url =
                    'https://ixcloud.work/index?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
                debugPrint('生成的URL: $url');

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(url: url),
                  ),
                );
              },
              child: const Text('登录成功！'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text('返回登录'),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('网页加载错误: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('浏览器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
