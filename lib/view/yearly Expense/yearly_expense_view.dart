import 'package:daily_expense/app/app.locator.dart';
import 'package:daily_expense/services/expense_service.dart';
import 'package:daily_expense/view/yearly%20Expense/widget/info_card.dart';
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4),
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
                          icon: const Icon(Icons.chevron_left, size: 28),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.indigo.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                          icon: const Icon(Icons.chevron_right, size: 28),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.indigo.shade50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InfoCard(),
                // Card(
                //   elevation: 2,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         IconButton(
                //           onPressed: () {
                //             viewModel.previousYear();
                //             print(
                //                 "Yearly Box Keys: ${locator<ExpenseService>().yearlyBox.keys}");
                //             print(
                //                 "Monthly Box Keys: ${locator<ExpenseService>().monthlyBox.keys}");
                //           },
                //           icon: const Icon(Icons.chevron_left),
                //         ),
                //         Text(
                //           '${viewModel.currentYear}',
                //           style: TextStyle(
                //             fontSize: 24,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.indigo[800],
                //           ),
                //         ),
                //         IconButton(
                //           onPressed: () {
                //             viewModel.nextYear();
                //           },
                //           icon: Icon(Icons.chevron_right),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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

// import 'package:daily_expense/app/app.locator.dart';
// import 'package:daily_expense/services/expense_service.dart';
// import 'package:daily_expense/view/yearly%20Expense/widget/info_card.dart';
// import 'package:daily_expense/view/yearly%20Expense/yearly_expense_viewModel.dart';
// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';

// class YearlyExpenseView extends StatelessWidget {
//   const YearlyExpenseView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder.reactive(
//       viewModelBuilder: () => YearlyExpenseViewmodel(),
//       onViewModelReady: (viewModel) => viewModel.init(),
//       builder: (context, YearlyExpenseViewmodel viewModel, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Yearly Overview'),
//             centerTitle: true,
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             foregroundColor: Colors.indigo,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Year Selector with improved UI
//                 Card(
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0, vertical: 4),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             viewModel.previousYear();
//                             print(
//                                 "Yearly Box Keys: ${locator<ExpenseService>().yearlyBox.keys}");
//                             print(
//                                 "Monthly Box Keys: ${locator<ExpenseService>().monthlyBox.keys}");
//                           },
//                           icon: const Icon(Icons.chevron_left, size: 28),
//                           style: IconButton.styleFrom(
//                             backgroundColor: Colors.indigo.shade50,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           '${viewModel.currentYear}',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.indigo[800],
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             viewModel.nextYear();
//                           },
//                           icon: const Icon(Icons.chevron_right, size: 28),
//                           style: IconButton.styleFrom(
//                             backgroundColor: Colors.indigo.shade50,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 // Info Cards
//                 const InfoCard(),

//                 const SizedBox(height: 20),

//                 // Summary Cards Row

//                 const SizedBox(height: 20),

//                 // Table Header
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           'Month',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           'Income',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey.shade700,
//                           ),
//                           textAlign: TextAlign.right,
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           'Expense',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey.shade700,
//                           ),
//                           textAlign: TextAlign.right,
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           'Saving',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey.shade700,
//                           ),
//                           textAlign: TextAlign.right,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 // Monthly Data List
//                 Expanded(
//                   child: ListView(
//                     children: [
//                       // Monthly data items
//                       ...viewModel.filledMonthlyData.map((month) {
//                         final bool isPositiveSaving =
//                             (month['savings'] ?? 0) >= 0;

//                         return Card(
//                           elevation: 1,
//                           margin: const EdgeInsets.symmetric(
//                               vertical: 4, horizontal: 4),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     month['month'],
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     month['actualIncome'].toStringAsFixed(0),
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       color: Colors.green.shade700,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     month['totalExpense'].toStringAsFixed(0),
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       color: Colors.red.shade700,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Text(
//                                     month['savings'].toStringAsFixed(0),
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       color: isPositiveSaving
//                                           ? Colors.blue.shade700
//                                           : Colors.orange.shade700,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }).toList(),

//                       // Total row
//                       Card(
//                         color: Colors.indigo.shade50,
//                         elevation: 2,
//                         margin: const EdgeInsets.only(top: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: Text(
//                                   "TOTAL",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.indigo.shade800,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   viewModel.yearlyIncome.toStringAsFixed(0),
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.indigo.shade800,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   viewModel.yearlyExpense.toStringAsFixed(0),
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.indigo.shade800,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   viewModel.yearlySavings.toStringAsFixed(0),
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.indigo.shade800,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
