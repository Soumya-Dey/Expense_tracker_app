import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get transactionValuesForChartBars {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalExpense = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalExpense += recentTransactions[i].amount;
        }
      }

      return {
        "weekday": DateFormat.E()
            .format(weekDay)
            .substring(0, 1), // formatting: Monday => M, Tuesday => T ...
        "amount": totalExpense,
      };
    }).reversed.toList();
  }

  double get totalSpendingOfWeek {
    double totalExpenseOfWeek = 0.0;

    for (var i = 0; i < recentTransactions.length; i++) {
      totalExpenseOfWeek += recentTransactions[i].amount;
    }

    return totalExpenseOfWeek;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: transactionValuesForChartBars.map((data) {
            return Expanded(
              child: ChartBar(
                weekdayLabel: data["weekday"],
                spendingAmount: data["amount"],
                spendingPercentage: totalSpendingOfWeek == 0.0
                    ? 0.0
                    : (data["amount"] as double) / totalSpendingOfWeek,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
