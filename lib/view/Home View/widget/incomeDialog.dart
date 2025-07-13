import 'package:daily_expense/view/Home%20View/home_viewModel.dart';
import 'package:flutter/material.dart';

class IncomeDialog extends StatelessWidget {
  final HomeViewModel viewModel;
  final bool isEdit;

  const IncomeDialog({
    required this.viewModel,
    super.key,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (isEdit) {
      viewModel.incomeController.text = viewModel.getIncome().toString();
    } else {
      viewModel.incomeController.clear();
    }
    return AlertDialog(
      title: Text(isEdit ? "Edit Icome" : "Add Income"),
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
              if (isEdit) {
                await viewModel.editIncome(amount);
              } else {
                await viewModel.addIncome(amount);
              }
              viewModel.incomeController.clear();

              Navigator.pop(context);
            }
          },
          child: Text(isEdit ? "Edit" : "Add"),
        ),
      ],
    );
  }
}
