import 'package:flutter/material.dart';

class CreditCard {
  final String cardNumber;
  final String expiryDate;
  final String holderName;
  final String cvv;
  final Color color;
  final String cardType;

  CreditCard({
    required this.cardNumber,
    required this.expiryDate,
    required this.holderName,
    required this.cvv,
    required this.color,
    required this.cardType,
  });
}
