import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:planetbrand/pages/other_page/webview_screen.dart';
import 'package:planetbrand/utils/api_helper.dart';

class AlfalahPaymentScreen extends StatefulWidget {
  const AlfalahPaymentScreen({super.key});

  @override
  State<AlfalahPaymentScreen> createState() => _AlfalahPaymentScreenState();
}

class _AlfalahPaymentScreenState extends State<AlfalahPaymentScreen> {
  final TextEditingController amountController = TextEditingController();
  bool isLoading = false;

  Future<void> initiatePayment() async {
    final String amount = amountController.text.trim();
    final String transactionRef =
        DateTime.now().millisecondsSinceEpoch.toString();

    if (amount.isEmpty || double.tryParse(amount) == null) {
      Get.snackbar("Error", "Enter a valid amount");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await ApiHelper.postRequestWithToken(
        "generate-payment",
        {"amount": amount, "reference": transactionRef},
      );

      final data = json.decode(response.body);
      if (data["success"] == true) {
        final authToken = data["AuthToken"];
        final redirectUrl =
            "https://sandbox.bankalfalah.com/SSO/SSO/SSO?AuthToken=$authToken";
        Get.to(() => WebViewScreen(url: redirectUrl));
      } else {
        print(data);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bank Alfalah Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: "Enter Amount (PKR)",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : initiatePayment,
              child:
                  isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Pay with Bank Alfalah"),
            ),
          ],
        ),
      ),
    );
  }
}
