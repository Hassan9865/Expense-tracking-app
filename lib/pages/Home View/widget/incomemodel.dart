import 'package:daily_expense/pages/Home%20View/home_viewModel.dart';
import 'package:flutter/material.dart';

class IncomeDialog extends StatelessWidget {
  final HomeViewModel viewModel;

  const IncomeDialog({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Income"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: viewModel.incomeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Amount"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            final amount = viewModel.incomeController.text;
            // viewModel.editIncome(amount);

            if (amount.isNotEmpty) {
              await viewModel.addIncome(amount);
              viewModel.incomeController.clear();
              Navigator.pop(context);
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
