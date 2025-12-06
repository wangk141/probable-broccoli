import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InternalDashboardScreen extends StatefulWidget {
  const InternalDashboardScreen({super.key});

  @override
  State<InternalDashboardScreen> createState() =>
      _InternalDashboardScreenState();
}

class _InternalDashboardScreenState extends State<InternalDashboardScreen> {
  late final WebViewController controller;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              errorMessage = null;
            });
          },
          onPageFinished: (String url) {
            setState(() => isLoading = false);
            controller.runJavaScript('''
              var meta = document.createElement('meta');
              meta.name = 'viewport';
              meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
              document.getElementsByTagName('head')[0].appendChild(meta);
              var style = document.createElement('style');
              style.innerHTML = 'body { overflow-x: hidden; } * { -webkit-tap-highlight-color: transparent; }';
              document.getElementsByTagName('head')[0].appendChild(style);
            ''');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
              errorMessage = 'Error: ${error.description}';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse("http://10.0.0.114:4200"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Internal Tools Dashboard")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading dashboard...'),
                ],
              ),
            ),
          if (errorMessage != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.reload(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}