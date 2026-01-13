import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/cards_provider.dart';
import '../models/credit_card.dart';
import 'card_payment_screen.dart'; // For formatters

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cardNumberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _holderNameCtrl = TextEditingController();

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _holderNameCtrl.dispose();
    super.dispose();
  }

  void _saveCard() {
    if (_formKey.currentState!.validate()) {
      final newCard = CreditCard(
        cardNumber: _cardNumberCtrl.text,
        expiryDate: _expiryCtrl.text,
        holderName: _holderNameCtrl.text,
        cvv: _cvvCtrl.text,
        // Assign a random attractive color
        color: [
          const Color(0xFF1E63FF), // Blue
          const Color(0xFF2E7D32), // Green
          const Color(0xFFD32F2F), // Red
          const Color(0xFF7B1FA2), // Purple
          const Color(0xFFFB8C00), // Orange
          const Color(0xFF455A64), // Blue Grey
        ][Random().nextInt(6)],
        cardType: _cardNumberCtrl.text.startsWith('4')
            ? "Visa"
            : (_cardNumberCtrl.text.startsWith('5') ? "MasterCard" : "Card"),
      );

      Provider.of<CardsProvider>(context, listen: false).addCard(newCard);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.blue, size: 60),
              const SizedBox(height: 16),
              const Text(
                "Card Saved Successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close Dialog
                Navigator.pop(context); // Close Screen
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Add New Card",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Card Number"),
                TextFormField(
                  controller: _cardNumberCtrl,
                  decoration: _inputDecoration("0000 0000 0000 0000", Icons.credit_card),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    CardNumberInputFormatter(),
                  ],
                  validator: (val) {
                    if (val == null || val.length < 19) return "Invalid card number";
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("Expiry Date"),
                          TextFormField(
                            controller: _expiryCtrl,
                            decoration: _inputDecoration("MM/YY", Icons.calendar_today),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                               FilteringTextInputFormatter.digitsOnly,
                               LengthLimitingTextInputFormatter(4),
                               CardDateInputFormatter(),
                            ],
                            validator: (val) {
                              if (val == null || val.isEmpty) return "Required";
                              if (val.length < 5) return "Invalid Date";
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("CVV"),
                          TextFormField(
                            controller: _cvvCtrl,
                            decoration: _inputDecoration("", Icons.lock_outline),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                             inputFormatters: [
                               FilteringTextInputFormatter.digitsOnly,
                               LengthLimitingTextInputFormatter(3),
                            ],
                            validator: (val) {
                              if (val == null || val.length < 3) return "Invalid CVV";
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildLabel("Cardholder Name"),
                TextFormField(
                  controller: _holderNameCtrl,
                  decoration: _inputDecoration("", Icons.person_outline),
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _saveCard,
                    child: const Text(
                      "Save Card",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1E63FF), width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
