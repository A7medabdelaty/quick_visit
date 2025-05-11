import 'package:flutter/material.dart';

class PaymentDetailsWidget extends StatelessWidget {
  final double consultingFee;

  const PaymentDetailsWidget({super.key, required this.consultingFee});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildPaymentRow('Consultation Fee', consultingFee),
              const Divider(),
              _buildPaymentRow('Booking Charge', 2.50),
              const Divider(),
              _buildPaymentRow('Hospital Charge', 0, showDash: true),
              const Divider(),
              _buildPaymentRow(
                'Total Amount',
                consultingFee + 2.50,
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentRow(
    String title,
    double amount, {
    bool isTotal = false,
    bool showDash = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            showDash ? '--' : 'EGP ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
