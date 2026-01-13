import 'package:flutter/material.dart';
import '../models/credit_card.dart';

class CardsProvider with ChangeNotifier {
  final List<CreditCard> _cards = [];

  List<CreditCard> get cards => _cards;

  void addCard(CreditCard card) {
    _cards.add(card);
    notifyListeners();
  }

  void removeCard(CreditCard card) {
    _cards.remove(card);
    notifyListeners();
  }
}
