import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'settings_page.dart';

class LoginSuccView extends StatelessWidget {
  static String? _cachedUrl;

  const LoginSuccView({super.key});

  static String generateUrl() {
    if (_cachedUrl != null) {
      return _cachedUrl!;
    }

    final params = {
      'uid': '1234',
      'nickname': 'martin',
      'language': 'ZH',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    final signature =
        _generateSignature(params, '32fffaf_afdd3jaf_j230933_P3cc');
    params['sign'] = signature;

    _cachedUrl =
        'https://ixcloud.work/index?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    return _cachedUrl!;
  }

  static String _generateSignature(
      Map<String, String> params, String secretKey) {
    final sortedKeys = params.keys.toList()..sort();
    final signStr =
        sortedKeys.map((key) => '$key=${params[key]}').join('&') + secretKey;
    return md5.convert(utf8.encode(signStr)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewPage(url: generateUrl());
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
  bool canGoBack = false;

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
          onPageFinished: (String url) async {
            final canGoBackNow = await controller.canGoBack();
            setState(() {
              isLoading = false;
              canGoBack = canGoBackNow;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('网页加载错误: ${error.description}');
          },
        ),
      )
      ..setBackgroundColor(Colors.white)
      ..enableZoom(true)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return Future.value(false);
        if (await controller.canGoBack()) {
          await controller.goBack();
          return Future.value(false);
        }
        controller.loadRequest(Uri.parse(LoginSuccView.generateUrl()));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              controller.loadRequest(Uri.parse(LoginSuccView.generateUrl()));
            },
          ),
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
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
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
      ),
    );
  }
}
