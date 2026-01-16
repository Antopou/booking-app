import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<Map<String, dynamic>> _paymentMethods = [
    {'type': 'Visa', 'last4': '4242', 'expiry': '12/25', 'isDefault': true},
    {'type': 'Mastercard', 'last4': '5555', 'expiry': '08/26', 'isDefault': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("Payment Methods", style: AppTextStyles.subHeading),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGrey),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _paymentMethods.length + 1,
        itemBuilder: (context, index) {
          if (index == _paymentMethods.length) {
            return _buildAddButton();
          }
          final method = _paymentMethods[index];
          return _buildPaymentCard(method);
        },
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(method['type'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              if (method['isDefault'])
                const Chip(label: Text("DEFAULT", style: TextStyle(fontSize: 10, color: Colors.white)), backgroundColor: AppColors.brandGold),
            ],
          ),
          const SizedBox(height: 20),
          Text("**** **** **** ${method['last4']}", style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Expiry: ${method['expiry']}", style: const TextStyle(color: Colors.white70)),
              const Icon(Icons.credit_card, color: Colors.white38),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add),
      label: const Text("Add New Card"),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        foregroundColor: AppColors.brandGold,
        side: const BorderSide(color: AppColors.brandGold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
