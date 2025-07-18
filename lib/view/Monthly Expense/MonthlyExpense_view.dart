import 'package:daily_expense/view/Monthly%20Expense/MonthlyExpense_viewModel.dart';
import 'package:daily_expense/view/Monthly%20Expense/widget/m_card.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class MonthlyExpenseView extends StatelessWidget {
  const MonthlyExpenseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => MonthlyExpenseViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(),
        builder: (context, MonthlyExpenseViewModel viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: const Text('Monthly Overview'),
              centerTitle: true,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Month Selector Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.currentMonth,
                                // DateFormat('MMMM yyyy').format(DateTime.now()),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '30 days recorded',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    viewModel.previousMonth();
                                  },
                                  icon: Icon(Icons.chevron_left, size: 24),
                                  color: Colors.indigo,
                                  splashRadius: 20,
                                ),
                                Text(
                                  'Navigate',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    viewModel.nextMonth();
                                  },
                                  icon: Icon(Icons.chevron_right, size: 24),
                                  color: Colors.indigo,
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Summary Cards
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: [
                      MCard(
                        title: 'Income',
                        amount: viewModel.totalIncome,
                        icon: Icons.arrow_upward,
                        color: Colors.green,
                      ),
                      MCard(
                        title: 'Expense',
                        amount: viewModel.totalExpense,
                        icon: Icons.arrow_downward,
                        color: Colors.red,
                      ),
                      MCard(
                        title: 'Savings',
                        amount: viewModel.savings,
                        icon: Icons.savings,
                        color: Colors.blue,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: viewModel.expenses.length,
                          itemBuilder: (context, index) {
                            var currentItem = viewModel.expenses[index];
                            if (viewModel.hasData) {
                              return Center(
                                  child: Text(
                                "No Monthly Data Found",
                                style: TextStyle(fontSize: 50),
                              ));
                            }
                            return Container(
                              decoration: BoxDecoration(
                                  // border: Border(
                                  //   bottom:
                                  //       index != viewModel.expenseList().length - 1
                                  //           ? BorderSide(
                                  //               color: Colors.grey[200]!, width: 1)
                                  //           : BorderSide.none,
                                  // ),
                                  ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.monetization_on_rounded,
                                      color: Colors.white),
                                ),
                                title: Text(
                                  currentItem["Category"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                // subtitle: Text(
                                //   DateFormat('hh:mm a').format(DateTime.parse(
                                //       currentItem['Date'] ??
                                //           DateTime.now().toString())),
                                //   style: TextStyle(
                                //     color: Colors.grey[500],
                                //   ),
                                // ),
                                trailing: Text(
                                  currentItem['amount'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
