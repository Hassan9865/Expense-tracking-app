import 'package:daily_expense/view/Home%20View/home_viewModel.dart';
import 'package:daily_expense/view/Home%20View/widget/ed_expense.dart';
import 'package:daily_expense/view/Home%20View/widget/expense_dialog.dart';
import 'package:daily_expense/view/Home%20View/widget/expense_tracker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (viewModel) => viewModel.readExpense(),
      builder: (context, HomeViewModel viewModel, index) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              "Daily Expense",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              // IconButton(
              //     onPressed: () {
              // viewModel.navigateToMonthlyExpenseView();
              //     },
              //     icon: Icon(Icons.abc)),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ElevatedButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) =>
                        ExpenseDialog(viewModel: viewModel, expensekey: null),
                  ),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text("Add Expense"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (String value) {
                  // setState(() {
                  //   _selectedView = value;
                  // });
                  // Add your logic to switch between views
                  if (value == 'Monthly Expenses') {
                    viewModel.navigateToMonthlyExpenseView();
                  } else {
                    // Navigate to yearly view
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Monthly Expenses',
                      child: Text('Monthly Expenses'),
                    ),
                    PopupMenuItem<String>(
                      value: 'Yearly Expenses',
                      child: Text('Yearly Expenses'),
                    ),
                  ];
                },
                icon: Icon(Icons.more_vert), // You can use any icon here
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Stats Card
                const ExpenseTracker(),

                // Recent Transactions Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),

                // Transactions List
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: viewModel.expenseList().isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.money_off,
                                    size: 48, color: Colors.grey[400]),
                                SizedBox(height: 16),
                                Text(
                                  "No Expenses Added",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Tap the + button to add your first expense",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: viewModel.expenseList().length,
                              itemBuilder: (context, index) {
                                var currentItem =
                                    viewModel.expenseList()[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: index !=
                                              viewModel.expenseList().length - 1
                                          ? BorderSide(
                                              color: Colors.grey[200]!,
                                              width: 1)
                                          : BorderSide.none,
                                    ),
                                  ),
                                  child: ListTile(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (context) => EdExpense(
                                          viewModel: viewModel, index: index),
                                    ),
                                    //  viewModel.showModel2(context, index),
                                    leading: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: _getCategoryColor(
                                                currentItem['Category'])
                                            .withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(
                                            currentItem['Category']),
                                        color: _getCategoryColor(
                                            currentItem['Category']),
                                      ),
                                    ),
                                    title: Text(
                                      currentItem['Category'] ?? "",
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
                                      "Rs. ${currentItem['Amount'] ?? ""}",
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

                // Total Expense Card
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Expense",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            "Rs. ${viewModel.getTotalExpense().toString()}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[700],
                            ),
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
  }

  // Helper function to get category color
  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'shopping':
        return Colors.pink;
      case 'entertainment':
        return Colors.green;
      case 'bills':
        return Colors.red;
      default:
        return Colors.purple;
    }
  }

  // Helper function to get category icon
  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
        return Icons.receipt;
      default:
        return Icons.money;
    }
  }
}
