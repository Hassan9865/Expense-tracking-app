import 'package:daily_expense/app/app.locator.dart';
import 'package:daily_expense/services/expense_service.dart';
import 'package:stacked/stacked.dart';

class YearlyExpenseViewmodel extends BaseViewModel {
  final _expenseService = locator<ExpenseService>();
  int _currentYear = DateTime.now().year; // Initialize with current year
  List<Map<String, dynamic>> _filledMonthlyData = [];

  int get currentYear => _currentYear;
  List<Map<String, dynamic>> get filledMonthlyData => _filledMonthlyData;

  // Use cached values instead of recalculating
  double _yearlyIncome = 0.0;
  double _yearlyExpense = 0.0;
  double _yearlySavings = 0.0;

  double get yearlyIncome => _yearlyIncome;
  double get yearlyExpense => _yearlyExpense;
  double get yearlySavings => _yearlySavings;

  Future<void> init() async {
    try {
      await _expenseService.loadMonthlySummaries();
      await _expenseService.loadYearlySummaries();

      final years = _expenseService.getAvailableYears();
      if (years.isNotEmpty) {
        _currentYear = int.parse(years.first);
      }
      await _loadYearData();
    } catch (e) {
      print('Error initializing YearlyExpenseViewmodel: $e');
      // Consider showing error to user
    }
  }

  Future<void> _loadYearData() async {
    try {
      // Get yearly data or create empty structure
      final yearlyData =
          _expenseService.getYearlyData(_currentYear.toString()) ??
              {
                'year': _currentYear.toString(),
                'actualIncome': 0.0,
                'totalExpense': 0.0,
                'savings': 0.0,
                'monthlySummaries': []
              };

      // Load all months data
      _filledMonthlyData = _loadAllMonthsData();

      // Calculate and cache yearly totals
      _calculateYearlyTotals();

      notifyListeners();
    } catch (e) {
      print('Error loading year data: $e');
    }
  }

  List<Map<String, dynamic>> _loadAllMonthsData() {
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

    return allMonths.map((month) {
      final monthKey = "$month $_currentYear";
      final monthData = _expenseService.monthlyBox.get(monthKey);

      if (monthData != null) {
        final actualIncome = monthData['actualIncome'] ?? 0.0;
        final totalExpense = monthData['totalExpense'] ?? 0.0;

        return {
          'month': month.toUpperCase(),
          'actualIncome': actualIncome,
          'totalExpense': totalExpense,
          'savings': actualIncome - totalExpense,
        };
      }

      return {
        'month': month.toUpperCase(),
        'actualIncome': 0.0,
        'totalExpense': 0.0,
        'savings': 0.0,
      };
    }).toList();
  }

  void _calculateYearlyTotals() {
    _yearlyIncome = _filledMonthlyData.fold(
        0.0, (sum, m) => sum + (m['actualIncome'] ?? 0.0));
    _yearlyExpense = _filledMonthlyData.fold(
        0.0, (sum, m) => sum + (m['totalExpense'] ?? 0.0));
    _yearlySavings = _yearlyIncome - _yearlyExpense;
  }

  void nextYear() {
    final years = _expenseService.getAvailableYears();
    final index = years.indexOf(_currentYear.toString());
    if (index > 0) {
      _currentYear = int.parse(years[index - 1]);
      _loadYearData();
    }
  }

  void previousYear() {
    final years = _expenseService.getAvailableYears();
    final index = years.indexOf(_currentYear.toString());
    if (index < years.length - 1) {
      _currentYear = int.parse(years[index + 1]);
      _loadYearData();
    }
  }
}
