import 'package:daily_expense/pages/Home%20View/home_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class ExpenseTracker extends ViewModelWidget<HomeViewModel> {
  const ExpenseTracker({super.key});

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final DateTime today = DateTime.now();
    // var currentItem = viewModel.expenseList;
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade600,
            Colors.purple.shade600,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row with Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Expense Tracker',
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width < 600 ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(today),
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width < 600 ? 14 : 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),

                // Income Row
                _buildAmountRow(
                  context,
                  label: 'Income',
                  amount: viewModel.getIncome().toString(),
                  icon: Icons.arrow_upward,
                  iconColor: Colors.green.shade300,
                ),

                // Saving Row
                _buildAmountRow(
                  context,
                  label: 'Saving',
                  amount: viewModel.getSaving().toString(),
                  icon: Icons.savings,
                  iconColor: Colors.amber.shade300,
                ),

                // Spacer to push button to bottom
                SizedBox(height: 10),
              ],
            ),
          ),
          Positioned(
            bottom: 3,
            right: 15,
            child: IconButton(
                onPressed: () {
                  viewModel.showIncomeModel(context);
                },
                icon: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    Text(
                      "Add Income",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
          )
        ],
      ),
    );
  }
}

Widget _buildAmountRow(
  BuildContext context, {
  required String label,
  required String amount,
  required IconData icon,
  required Color iconColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: MediaQuery.of(context).size.width < 600 ? 20 : 24,
            ),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        Text(
          'Rs. $amount',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width < 600 ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
