import 'package:daily_expense/app/app.locator.dart';
import 'package:daily_expense/services/expense_service.dart';
import 'package:daily_expense/view/yearly%20Expense/yearly_expense_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class YearlyExpenseView extends StatelessWidget {
  const YearlyExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => YearlyExpenseViewmodel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, YearlyExpenseViewmodel viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Yearly Overview'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Year Selector Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            viewModel.previousYear();
                            print(
                                "Yearly Box Keys: ${locator<ExpenseService>().yearlyBox.keys}");
                            print(
                                "Monthly Box Keys: ${locator<ExpenseService>().monthlyBox.keys}");
                          },
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          '${viewModel.currentYear}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[800],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            viewModel.nextYear();
                          },
                          icon: Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Compact Data Table
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DataTable(
                        columnSpacing: 24,
                        dataRowHeight: 48,
                        headingRowHeight: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        columns: const [
                          DataColumn(
                              label: Text('Month',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Income',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text(
                            'Expense',
                          )),
                          DataColumn(
                              label: Text('Saving',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: [
                          ...viewModel.filledMonthlyData.map((month) {
                            return DataRow(cells: [
                              DataCell(Text(month['month'])),
                              DataCell(Text(
                                  month['actualIncome'].toStringAsFixed(0))),
                              DataCell(Text(
                                  month['totalExpense'].toStringAsFixed(0))),
                              DataCell(
                                  Text(month['savings'].toStringAsFixed(0))),
                            ]);
                          }).toList(),

                          // Total row
                          DataRow(
                            color: WidgetStateProperty.resolveWith<Color?>(
                              (states) => Colors.indigo[50],
                            ),
                            cells: [
                              const DataCell(Text(
                                "TOTAL",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(
                                viewModel.yearlyIncome.toStringAsFixed(0),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(
                                viewModel.yearlyExpense.toStringAsFixed(0),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(
                                viewModel.yearlySavings.toStringAsFixed(0),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
