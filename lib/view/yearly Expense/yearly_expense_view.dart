import 'package:daily_expense/view/yearly%20Expense/yearly_expense_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class YearlyExpenseView extends StatelessWidget {
  const YearlyExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => YearlyExpenseViewmodel(),
        builder: (context, YearlyExpenseViewmodel viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Yearly Overview'),
              centerTitle: true,
              elevation: 0,
            ),
          );
        });
  }
}
