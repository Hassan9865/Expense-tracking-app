import 'package:daily_expense/view/Monthly%20Expense/MonthlyExpense_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class MCard extends ViewModelWidget<MonthlyExpenseViewModel> {
  final String title;
  final double amount;
  final IconData icon;
  final Color color;
  const MCard(
      {required this.title,
      required this.amount,
      required this.icon,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context, MonthlyExpenseViewModel viewModel) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Icon(icon, color: color.withOpacity(0.8), size: 20),
              ],
            ),
            Text(
              'Rs. ${NumberFormat('#,##0').format(amount)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
