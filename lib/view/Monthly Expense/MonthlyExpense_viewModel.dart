import 'package:daily_expense/app/app.locator.dart';
import 'package:daily_expense/services/expense_service.dart';
import 'package:stacked/stacked.dart';

class MonthlyExpenseViewModel extends BaseViewModel {
  final ExpenseService _expenseService = locator<ExpenseService>();

  int _currentIndex = 0;

  bool get hasData => _expenseService.monthlySummaries.isNotEmpty;

  String get currentMonth => hasData
      ? _expenseService.monthlySummaries[_currentIndex]['month']
      : 'No Data';

  double get totalIncome => hasData
      ? _expenseService.monthlySummaries[_currentIndex]['totalIncome'] ?? 0
      : 0;

  double get totalExpense => hasData
      ? _expenseService.monthlySummaries[_currentIndex]['totalExpense'] ?? 0
      : 0;

  double get savings => hasData
      ? _expenseService.monthlySummaries[_currentIndex]['savings'] ?? 0
      : 0;

  List<Map<String, dynamic>> get expenses => hasData
      ? List<Map<String, dynamic>>.from(
          _expenseService.monthlySummaries[_currentIndex]['expenses'] ?? [])
      : [];

  bool get hasNext => hasData && _currentIndex > 0;
  bool get hasPrevious =>
      hasData && _currentIndex < _expenseService.monthlySummaries.length - 1;

  Future<void> init() async {
    await _expenseService.init();
    if (_expenseService.monthlySummaries.isNotEmpty) {
      _currentIndex = 0;
    }
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
