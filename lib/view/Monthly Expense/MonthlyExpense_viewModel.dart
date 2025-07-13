import 'package:stacked/stacked.dart';

class MonthlyExpenseViewModel extends BaseViewModel {
  // ViewModel implementation would go here
  // This should include all the data and methods needed by the view

  DateTime selectedMonth = DateTime.now();
  int totalDays = 30;
  double totalIncome = 75000;
  double totalExpense = 45000;
  double savings = 30000;
  double dailyAverage = 1500;

  List<Map<String, dynamic>> categoryExpenses = [
    {'category': 'Food', 'amount': 12000, 'percentage': 0.3},
    {'category': 'Transport', 'amount': 8000, 'percentage': 0.2},
    {'category': 'Shopping', 'amount': 10000, 'percentage': 0.25},
    {'category': 'Bills', 'amount': 7000, 'percentage': 0.175},
    {'category': 'Entertainment', 'amount': 8000, 'percentage': 0.2},
  ];

  List<Map<String, dynamic>> recentTransactions = [
    {
      'category': 'Food',
      'amount': '1,200',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'expense'
    },
    {
      'category': 'Salary',
      'amount': '25,000',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'type': 'income'
    },
    // Add more transactions...
  ];

  void init() async {
    // Load initial data
    setBusy(true);
    // await fetchData();
    setBusy(false);
  }

  void selectMonth() {
    // Implement month selection logic
  }

  void viewAllTransactions() {
    // Navigate to full transactions list
  }
}
