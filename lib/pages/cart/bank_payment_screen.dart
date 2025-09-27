import 'package:flutter/material.dart';
import 'package:bank_alfalah_payment/bank_alfalah_payment.dart';
import 'package:get/get.dart';
import 'package:planetbrand/pages/landing/landing_screen.dart';

class BankPaymentBottomSheet extends StatefulWidget {
  final String amount;
  final String orderId;

  const BankPaymentBottomSheet({
    super.key,
    required this.amount,
    required this.orderId,
  });

  @override
  State<BankPaymentBottomSheet> createState() => _BankPaymentBottomSheetState();
}

class _BankPaymentBottomSheetState extends State<BankPaymentBottomSheet> {
  String _paymentResult = '';
  late final BankAlfalahPaymentService _paymentService;

  @override
  void initState() {
    super.initState();
    _paymentService = BankAlfalahPaymentService(
      config: BankAlfalahConfig(
        merchantId: '19931',
        merchantPassword: 'ozxDRerrJJdvFzk4yqF7CA==',
        merchantUsername: 'bakoho',
        merchantHash:
            'OUU362MB1uqOvabSg7KsREd15e+opQs5owxfJyA/w/y58zMHDXkv9r4jVGOZSzy+gg2QnBILcTM=',
        storeId: '025471',
        returnUrl: 'https://planetsbrand.com/payment/gateway/alfa/return',
        firstKey: 'y9M49qgpVxdEahGq',
        secondKey: '2961623217328605',
        debugMode: true,
      ),
    );
  }

  Future<void> _initiatePayment() async {
    final request = PaymentRequest(
      amount: widget.amount,
      orderId: widget.orderId,
    );

    final result = await _paymentService.initiatePayment(
      request: request,
      context: context,
    );

    setState(() {
      if (result.isSuccess) {
        _paymentResult = '✅ Payment Successful!';
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(() => LandingScreen());
        });
      } else {
        _paymentResult =
            '❌ Payment Failed: ${result.errorMessage ?? result.response?.message ?? 'Unknown error'}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Payable Amount: PKR ${widget.amount}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initiatePayment,
                child: const Text('Pay with Bank Alfalah'),
              ),
              const SizedBox(height: 10),
              if (_paymentResult.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        _paymentResult.contains('Successful')
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _paymentResult,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
