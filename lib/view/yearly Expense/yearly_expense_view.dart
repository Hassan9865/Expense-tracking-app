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
                          onPressed: () {},
                          icon: Icon(Icons.chevron_left),
                        ),
                        Text(
                          '2025',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo[800],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
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
                        columns: [
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
                          DataRow(cells: [
                            DataCell(Text("JAN")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("FEB")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("MAR")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("APR")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("MAY")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("JUN")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("JUL")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("AUG")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("SEP")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("OCT")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("NOV")),
                            DataCell(Text("2500")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(cells: [
                            DataCell(Text("DEC")),
                            DataCell(Text("2700")),
                            DataCell(Text("2000")),
                            DataCell(Text("500")),
                          ]),
                          DataRow(
                            color: WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) => Colors.indigo[50],
                            ),
                            cells: [
                              DataCell(Text("TOTAL",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text("30000",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text("24000",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text("6000",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
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
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Yearly Overview'),
    //     centerTitle: true,
    //     elevation: 0,
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Container(
    //           decoration: BoxDecoration(
    //             color: Colors.grey[200],
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               IconButton(
    //                 onPressed: () {
    //                   // viewModel.previousMonth();
    //                 },
    //                 icon: Icon(Icons.chevron_left, size: 24),
    //                 color: Colors.indigo,
    //                 splashRadius: 20,
    //               ),
    //               Text(
    //                 '2025',
    //                 style: TextStyle(
    //                   color: Colors.grey[700],
    //                   fontWeight: FontWeight.w400,
    //                   fontSize: MediaQuery.of(context).size.width * 0.1,
    //                 ),
    //               ),
    //               IconButton(
    //                 onPressed: () {
    //                   // viewModel.nextMonth();
    //                 },
    //                 icon: Icon(Icons.chevron_right, size: 24),
    //                 color: Colors.indigo,
    //                 splashRadius: 20,
    //               ),
    //             ],
    //           ),
    //         ),
    //         DataTable(columns: [
    //           DataColumn(
    //             label: Text('Months'),
    //           ),
    //           DataColumn(
    //             label: Text('Income'),
    //           ),
    //           DataColumn(
    //             label: Text('Expense'),
    //           ),
    //           DataColumn(
    //             label: Text('Saving'),
    //           )
    //         ], rows: [
    // DataRow(cells: [
    //   DataCell(Text("JAN")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("FEB")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("MAR")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("APR")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("MAY")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("JUN")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("JUL")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("AUG")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("SEP")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("OCT")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("NOV")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    // DataRow(cells: [
    //   DataCell(Text("DEC")),
    //   DataCell(Text("2500")),
    //   DataCell(Text("2000")),
    //   DataCell(Text("500")),
    // ]),
    //           DataRow(color: Colors.indigo, cells: [
    //             DataCell(Text(
    //               "TOTAL",
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             )),
    //             DataCell(Text(
    //               "2500",
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             )),
    //             DataCell(Text(
    //               "2000",
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             )),
    //             DataCell(Text(
    //               "500",
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             )),
    //           ]),
    //         ])
    //       ],
    //     ),
    //   ),
    // );
  }
}
