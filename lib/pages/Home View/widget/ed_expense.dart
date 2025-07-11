import 'package:daily_expense/pages/Home%20View/widget/expense_dialog.dart';
import 'package:daily_expense/pages/Home%20View/home_viewModel.dart';
import 'package:flutter/material.dart';

class EdExpense extends StatelessWidget {
  final HomeViewModel viewModel;
  final int index;
  const EdExpense({super.key, required this.viewModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("What do you want to do?"),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () async {
              Navigator.pop(context);
              var currentItem = viewModel.expenseList[index];
              await showDialog(
                context: context,
                builder: (context) => ExpenseDialog(
                  expensekey: currentItem["key"],
                  viewModel: viewModel,
                ),
              );
              // showModel(context, context, currentItem["key"]);
            },
            icon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit),
                Text('Edit'),
              ],
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          IconButton(
            onPressed: () {
              var currentItem = viewModel.expenseList[index];
              viewModel.deleteExpense(currentItem['key']);
              Navigator.of(context).pop();
            },
            icon: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete),
                Text('Delete'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
