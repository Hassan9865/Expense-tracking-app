import 'package:daily_expense/app/app.locator.dart';
import 'package:daily_expense/services/expense_service.dart';
import 'package:daily_expense/view/Home%20View/home_viewModel.dart';
import 'package:flutter/material.dart';

class ExpenseDialog extends StatelessWidget {
  final HomeViewModel viewModel;
  final int? expensekey;
  const ExpenseDialog(
      {super.key, required this.viewModel, required this.expensekey});

  @override
  Widget build(BuildContext context) {
    viewModel.amountController.clear();
    viewModel.categoryController.clear();
    if (expensekey != null) {
      final item = locator<ExpenseService>()
          .expenseList
          .firstWhere((element) => element['key'] == expensekey);
      viewModel.categoryController.text = item["Category"];
      viewModel.amountController.text = item["Amount"];
      // descriptionController.text = item["Description"];
    }
    return AlertDialog(
      title: Text(expensekey == null ? "Add Expense" : "Edit Expense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: viewModel.categoryController,
            decoration: InputDecoration(hintText: "Category"),
          ),
          TextField(
            controller: viewModel.amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Amount"),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
            onPressed: () {
              var data = {
                "Category": viewModel.categoryController.text,
                "Amount": viewModel.amountController.text,
              };
              if (expensekey == null) {
                viewModel.addExpense(data);
              } else {
                viewModel.updateExpense(expensekey!, data);
              }
              Navigator.of(context).pop();
            },
            child: Text(expensekey == null ? "ADD" : "Edit"))
      ],
    );
  }
}
