// import 'package:daily_expense/app/app.locator.dart';
// import 'package:daily_expense/services/expense_service.dart';
// import 'package:stacked/stacked.dart';

// class MonthlyExpenseViewModel extends BaseViewModel {
//   final ExpenseService _expenseService = locator<ExpenseService>();

//   int _currentIndex = 0;

//   bool get hasData => _expenseService.monthlySummaries.isNotEmpty;

//   String get currentMonth => hasData
//       ? _expenseService.monthlySummaries[_currentIndex]['month']
//       : 'No Data';

//   double get totalIncome => hasData
//       ? _expenseService.monthlySummaries[_currentIndex]['totalIncome'] ?? 0
//       : 0;

//   double get actualIncome => hasData
//       ? _expenseService.monthlySummaries[_currentIndex]['actualIncome'] ?? 0
//       : 0;

//   double get lastMonthSaving => hasData
//       ? _expenseService.monthlySummaries[_currentIndex]['lastMonthSaving'] ?? 0
//       : 0;

//   double get totalExpense => hasData
//       ? _expenseService.monthlySummaries[_currentIndex]['totalExpense'] ?? 0
//       : 0;

//   double get savings => hasData
//       ? _expenseService.monthlySummaries[_currentIndex]['savings'] ?? 0
//       : 0;

//   List<Map<String, dynamic>> get expenses {
//     if (!hasData) return [];

//     final rawExpenses =
//         _expenseService.monthlySummaries[_currentIndex]['expenses'] ?? [];

//     // Manually cast each item to Map<String, dynamic>
//     return List<Map<String, dynamic>>.from(
//       (rawExpenses as List)
//           .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)),
//     );
//   }

//   bool get hasNext => hasData && _currentIndex > 0;
//   bool get hasPrevious =>
//       hasData && _currentIndex < _expenseService.monthlySummaries.length - 1;

//   Future<void> init() async {
//     await _expenseService.init();
//     if (_expenseService.monthlySummaries.isNotEmpty) {
//       _currentIndex = 0;
//     }
//     notifyListeners();
//   }

//   void nextMonth() {
//     if (hasNext) {
//       _currentIndex--;
//       print('next month');
//       notifyListeners();
//     }
//   }

//   void previousMonth() {
//     if (hasPrevious) {
//       _currentIndex++;
//       notifyListeners();
//     }
//   }
// }

import 'package:daily_expense/app/app.locator.dart';
import 'package:daily_expense/services/expense_service.dart';
import 'package:stacked/stacked.dart';

class MonthlyExpenseViewModel extends BaseViewModel {
  final ExpenseService _expenseService = locator<ExpenseService>();

  int _currentIndex = 0;

  bool get hasData => _expenseService.monthlySummaries.isNotEmpty;

  /// yeh helper method current month + past months handle karegi
  Map<String, dynamic> get _currentSummary {
    if (_currentIndex == 0) {
      // live current month ka data return karo
      return _expenseService.getCurrentMonthSummary();
    }
    // purane months ka data saved summaries se lo
    return _expenseService.monthlySummaries[_currentIndex - 1];
  }

  String get currentMonth => _currentSummary['month'] ?? 'No Data';
  double get totalIncome => _currentSummary['totalIncome'] ?? 0;
  double get actualIncome => _currentSummary['actualIncome'] ?? 0;
  double get lastMonthSaving => _currentSummary['lastMonthSaving'] ?? 0;
  double get totalExpense => _currentSummary['totalExpense'] ?? 0;
  double get savings => _currentSummary['savings'] ?? 0;

  List<Map<String, dynamic>> get expenses =>
      List<Map<String, dynamic>>.from(_currentSummary['expenses'] ?? []);

  bool get hasNext => _currentIndex > 0;
  bool get hasPrevious =>
      _currentIndex < _expenseService.monthlySummaries.length;

  Future<void> init() async {
    await _expenseService.init();
    _currentIndex = 0; // 0 hamesha current month hoga
    notifyListeners();
  }

  void nextMonth() {
    if (hasNext) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void previousMonth() {
    if (hasPrevious) {
      _currentIndex++;
      notifyListeners();
    }
  }
}
