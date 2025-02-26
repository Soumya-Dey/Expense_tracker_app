import 'package:flutter/foundation.dart';

class Transaction {
  @required
  final String id;
  @required
  String title;
  @required
  double amount;
  @required
  DateTime date;

  Transaction({
    this.id,
    this.title,
    this.amount,
    this.date,
  });
}
