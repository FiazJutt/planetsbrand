import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:planetbrand/pages/landing/landing_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/config.dart';

class BankAlfalahWebView extends StatefulWidget {
  final String orderId;
  final int amount;

  const BankAlfalahWebView({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  State<BankAlfalahWebView> createState() => _BankAlfalahWebViewState();
}

class _BankAlfalahWebViewState extends State<BankAlfalahWebView> {
  InAppWebViewController? webViewController;
  double progress = 0;

  final String successUrl =
      "https://planetsbrand.com/payment/gateway/alfa/return";

  @override
  Widget build(BuildContext context) {
    final String url =
        "$baseUrl/bank-alfalah-payment?order_id=${widget.orderId}&amount=${widget.amount}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay via Bank Alfalah'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: Column(
        children: [
          progress < 1.0
              ? const LinearProgressIndicator(color: AppColors.green)
              : const SizedBox(height: 4),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(url)),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onProgressChanged: (controller, progressValue) {
                setState(() {
                  progress = progressValue / 100;
                });
              },
              onLoadStop: (controller, url) {
                if (url != null && url.toString().startsWith(successUrl)) {
                  // Optionally: validate query params like RC=00
                  Get.offAll(() => const LandingScreen());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
