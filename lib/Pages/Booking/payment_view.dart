import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String url;

  const PaymentWebViewScreen({super.key, required this.url});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // هنا بنراقب الرابط اللي اتكلمنا عليه (Deep Link)
            // لو الرابط يحتوي على كلمة success أو الدومين بتاعك
            if (request.url.contains('payment-status')) {
              // حلل الرابط واعرف النتيجة (نجاح أو فشل)
              bool isSuccess = request.url.contains('success=true');

              // ارجع للتطبيق بالنتيجة
              Navigator.pop(context, isSuccess);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الدفع الإلكتروني")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
