import 'package:daily_expense/app/app.locator.dart';
import 'package:daily_expense/services/expense_service.dart';
import 'package:stacked/stacked.dart';

class YearlyExpenseViewmodel extends BaseViewModel {
  final _expenseService = locator<ExpenseService>();

  int _currentYear = DateTime.now().year;
  Map<String, dynamic>? _yearData;

  List<Map<String, dynamic>> _filledMonthlyData = [];

  int get currentYear => _currentYear;

  Future<void> init() async {
    await _expenseService.loadMonthlySummaries();
    _loadYearData();
  }

  void _loadYearData() {
    _yearData = _expenseService.getYearlyData(_currentYear.toString());

    final allMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    _filledMonthlyData = allMonths.map((month) {
      final key = "$month $_currentYear";
      final data = _expenseService.monthlyBox.get(key);
      if (data != null) {
        return {
          'month': month.toUpperCase(),
          'totalIncome': data['totalIncome'],
          'totalExpense': data['totalExpense'],
          'savings': data['savings'],
        };
      } else {
        return {
          'month': month.toUpperCase(),
          'totalIncome': 0.0,
          'totalExpense': 0.0,
          'savings': 0.0,
        };
      }
    }).toList();

    notifyListeners();
  }

  List<Map<String, dynamic>> get filledMonthlyData => _filledMonthlyData;

  double get yearlyIncome => _yearData?['totalIncome'] ?? 0.0;
  double get yearlyExpense => _yearData?['totalExpense'] ?? 0.0;
  double get yearlySavings => _yearData?['savings'] ?? 0.0;

  void previousYear() {
    final years = _expenseService.getAvailableYears();
    final index = years.indexOf(_currentYear.toString());
    if (index > 0) {
      _currentYear = int.parse(years[index - 1]);
      _loadYearData();
    }
  }

  void nextYear() {
    final years = _expenseService.getAvailableYears();
    final index = years.indexOf(_currentYear.toString());
    if (index < years.length - 1) {
      _currentYear = int.parse(years[index + 1]);
      _loadYearData();
    }
  }
}
