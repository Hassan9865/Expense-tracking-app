import 'package:daily_expense/app/app.locator.dart';
import 'package:daily_expense/services/expense_service.dart';
import 'package:stacked/stacked.dart';

class YearlyExpenseViewmodel extends BaseViewModel {
  final _expenseService = locator<ExpenseService>();

  // int _currentYear = DateTime.now().year;
  int _currentYear = 0;

  Map<String, dynamic>? _yearData;

  List<Map<String, dynamic>> _filledMonthlyData = [];

  int get currentYear => _currentYear;

  Future<void> init() async {
    await _expenseService.loadMonthlySummaries();
    await _expenseService.loadYearlySummaries();

    final years = _expenseService.getAvailableYears();

    if (years.isNotEmpty) {
      _currentYear = int.parse(years.first);
    }
    // else {
    //   _currentYear = DateTime.now().year;
    // }
    _loadYearData();
  }

  void _loadYearData() {
    // _yearData = _expenseService.getYearlyData(_currentYear.toString());
    _yearData = _expenseService.getYearlyData(_currentYear.toString()) ??
        {
          'year': _currentYear.toString(),
          'actualIncome': 0.0,
          'totalExpense': 0.0,
          'savings': 0.0,
          'monthlySummaries': []
        };

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

    // _filledMonthlyData = allMonths.map((month) {
    //   final key = "$month $_currentYear";
    //   final data = _expenseService.monthlyBox.get(key);
    //   if (data != null) {
    //     return {
    //       'month': month.toUpperCase(),
    //       'actualIncome': data['actualIncome'],
    //       'totalExpense': data['totalExpense'],
    //       'savings': data['savings'],
    //     };
    //   } else {
    //     return {
    //       'month': month.toUpperCase(),
    //       'actualIncome': 0.0,
    //       'totalExpense': 0.0,
    //       'savings': 0.0,
    //     };
    //   }
    // }).toList();
    _filledMonthlyData = allMonths.map((month) {
      final key = "$month $_currentYear";
      final data = _expenseService.monthlyBox.get(key);

      if (data != null) {
        final actualIncome = data['actualIncome'] ?? 0.0;
        final totalExpense = data['totalExpense'] ?? 0.0;
        final calculatedSaving = actualIncome - totalExpense;

        return {
          'month': month.toUpperCase(),
          'actualIncome': actualIncome,
          'totalExpense': totalExpense,
          'savings': calculatedSaving, // override saving
        };
      } else {
        return {
          'month': month.toUpperCase(),
          'actualIncome': 0.0,
          'totalExpense': 0.0,
          'savings': 0.0,
        };
      }
    }).toList();

    notifyListeners();
  }

  List<Map<String, dynamic>> get filledMonthlyData => _filledMonthlyData;

  // double get yearlyIncome => _yearData?['actualIncome'] ?? 0.0;
  // double get yearlyExpense => _yearData?['totalExpense'] ?? 0.0;
  // double get yearlySavings => _yearData?['savings'] ?? 0.0;

  double get yearlyIncome => _filledMonthlyData.fold(
      0.0, (sum, m) => sum + (m['actualIncome'] ?? 0.0));

  double get yearlyExpense => _filledMonthlyData.fold(
      0.0, (sum, m) => sum + (m['totalExpense'] ?? 0.0));

  double get yearlySavings => _filledMonthlyData.fold(
      0.0,
      (sum, m) =>
          sum + ((m['actualIncome'] ?? 0.0) - (m['totalExpense'] ?? 0.0)));

  void nextYear() {
    final years = _expenseService.getAvailableYears();
    final index = years.indexOf(_currentYear.toString());
    if (index > 0) {
      _currentYear = int.parse(years[index - 1]);
      _loadYearData();
    }
    notifyListeners();
  }

  void previousYear() {
    final years = _expenseService.getAvailableYears();
    final index = years.indexOf(_currentYear.toString());
    if (index < years.length - 1) {
      _currentYear = int.parse(years[index + 1]);
      _loadYearData();
    }
    notifyListeners();
  }
}
