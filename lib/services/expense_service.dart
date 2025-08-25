import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ExpenseService {
  late Box expenseBox;
  late Box incomeBox;
  late Box monthlyBox;
  late Box yearlyBox;

  List<Map<String, dynamic>> expenseList = [];
  List<Map<String, dynamic>> monthlySummaries = [];

  Future<void> init() async {
    expenseBox = await Hive.openBox("expenseBox");
    incomeBox = await Hive.openBox("incomeBox");
    monthlyBox = await Hive.openBox("monthlyBox");
    yearlyBox = await Hive.openBox("yearlyBox");
    readExpense();
    await loadMonthlySummaries();
    await _checkMonthEnd();
    await _checkYearEnd();
  }

  Future<void> _checkMonthEnd() async {
    final now = DateTime(2025, 9, 1);
    // final now = DateTime.now();
    final lastRecordedMonth = incomeBox.get('lastRecordedMonth');
    final currentMonth = DateFormat('MMM yyyy').format(now);

    if (lastRecordedMonth == null) {
      await incomeBox.put('lastRecordedMonth', currentMonth);
      return;
    }

    if (lastRecordedMonth != currentMonth) {
      await _handleMonthEndTransition();
    }
  }

  Future<void> _handleMonthEndTransition() async {
    final now = DateTime(2025, 9, 1);

    // final now = DateTime.now();
    final previousMonthDate = DateTime(now.year, now.month - 1, 1);
    // 1. Save current month's data
    await _createMonthlySummary(previousMonthDate);
    final savings = getSaving();
    await incomeBox.put('lastMonthSaving', savings);

    // 2. Reset for new month (savings become new income)
    await incomeBox.put('userIncome', savings);
    await expenseBox.clear();
    readExpense();

    // 3. Update last recorded month
    final currentMonthYear = DateFormat('MMM yyyy').format(now);

    await incomeBox.put('lastRecordedMonth', currentMonthYear);

    await _checkYearEnd();

    loadMonthlySummaries();
  }

  Future<void> _createMonthlySummary(DateTime date) async {
    final currentMonthYear = DateFormat('MMM yyyy').format(date);

    final totalIncome = double.tryParse(getIncome()) ?? 0;
    final totalExpense = getTotalExpense();
    final lastMonthSaving = incomeBox.get('lastMonthSaving') ?? 0.0;
    final actualIncome = totalIncome - lastMonthSaving;
    final savings = totalIncome - totalExpense;

    final monthlyData = {
      'month': currentMonthYear,
      'totalIncome': totalIncome,
      'actualIncome': actualIncome,
      'lastMonthSaving': lastMonthSaving,
      'totalExpense': totalExpense,
      'savings': savings,
      'expenses': List<Map<String, dynamic>>.from(expenseList),
      // 'expenses': expenseList,
      'timestamp': date.millisecondsSinceEpoch,
    };

    await monthlyBox.put(currentMonthYear, monthlyData);
    print('Created monthly summary for $currentMonthYear');

    // _loadMonthlySummaries();
    // print('=== Monthly Summary ===');
    // print('userIncome: $totalIncome');
    // print('lastMonthSaving: $lastMonthSaving');
    // print('actualIncome (userIncome - lastSaving): $actualIncome');
    // print('totalExpense: $totalExpense');
    // print('savings: $savings');
  }

  Future<void> loadMonthlySummaries() async {
    monthlySummaries = monthlyBox.keys.map((key) {
      final data = monthlyBox.get(key);
      return {
        'month': key,
        'actualIncome': data['actualIncome'] ?? 0.0,
        'lastMonthSaving': data['lastMonthSaving'] ?? 0.0,
        'totalIncome': data['totalIncome'],
        'totalExpense': data['totalExpense'],
        'savings': data['savings'],
        'expenses': data['expenses'],
      };
    }).toList();

    monthlySummaries.sort((a, b) {
      final aTime = monthlyBox.get(a['month'])['timestamp'];
      final bTime = monthlyBox.get(b['month'])['timestamp'];
      return bTime.compareTo(aTime);
    });
  }

  Map<String, dynamic> getCurrentMonthSummary() {
    final now = DateTime(2025, 9, 1);

    // final now = DateTime.now();
    final currentMonthYear = DateFormat('MMM yyyy').format(now);

    final totalIncome = double.tryParse(getIncome()) ?? 0;
    final totalExpense = getTotalExpense();
    final lastMonthSaving = incomeBox.get('lastMonthSaving') ?? 0.0;
    final actualIncome = totalIncome - lastMonthSaving;
    final savings = totalIncome - totalExpense;

    return {
      'month': currentMonthYear,
      'totalIncome': totalIncome,
      'actualIncome': actualIncome,
      'lastMonthSaving': lastMonthSaving,
      'totalExpense': totalExpense,
      'savings': savings,
      'expenses': List<Map<String, dynamic>>.from(expenseList),
    };
  }

  Future<void> _checkYearEnd() async {
    // final currentYear = 2027;
    final currentYear = DateTime.now().year;
    final lastRecordedYear = incomeBox.get('lastRecordedYear');

    if (lastRecordedYear != null && lastRecordedYear != currentYear) {
      await _handleYearEndTransition();
    } else if (lastRecordedYear == null) {
      await incomeBox.put('lastRecordedYear', currentYear);
    }
  }

  Future<void> _handleYearEndTransition() async {
    final now = DateTime.now();
    // final now = DateTime(2027, 2, 1);
    final previousYear = (now.year - 1).toString();

    final yearSummaries = monthlyBox.keys
        .where((key) => key.toString().endsWith(previousYear))
        .map((key) {
      final data = monthlyBox.get(key);
      return Map<String, dynamic>.from(data);
    }).toList();

    final yearlyIncome =
        yearSummaries.fold(0.0, (sum, m) => sum + (m['actualIncome'] ?? 0));
    final yearlyExpense =
        yearSummaries.fold(0.0, (sum, m) => sum + (m['totalExpense'] ?? 0));
    final yearlySavings = yearlyIncome - yearlyExpense;
    // print('Yearly Income: $yearlyIncome');
    // print('Yearly Expense: $yearlyExpense');
    // print('Calculated Yearly Savings: $yearlySavings');

    final yearlyData = {
      'year': previousYear,
      'actualIncome': yearlyIncome,
      'totalExpense': yearlyExpense,
      'savings': yearlySavings,
      'monthlySummaries': yearSummaries,
      'timestamp': now.millisecondsSinceEpoch,
    };

    await yearlyBox.put(previousYear, yearlyData);
    await incomeBox.put('lastRecordedYear', now.year);
  }

  Future<void> loadYearlySummaries() async {
    final yearlyData = yearlyBox.keys.map((key) {
      final data = yearlyBox.get(key);
      return Map<String, dynamic>.from({
        'year': key,
        'actualIncome': data['actualIncome'] ?? 0.0,
        'totalExpense': data['totalExpense'] ?? 0.0,
        'savings': data['savings'] ?? 0.0,
        'monthlySummaries': data['monthlySummaries'] ?? [],
      });
    }).toList();

    yearlyData
        .sort((a, b) => (b['year'] as String).compareTo(a['year'] as String));
  }

  Map<String, dynamic>? getYearlyData(String year) {
    final data = yearlyBox.get(year);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  List<String> getAvailableYears() {
    // final now = DateTime(2027, 4, 1);

    // final currentYear = now.year.toString();

    final currentYear = DateTime.now().year.toString();

    final keys = yearlyBox.keys.map((e) => e.toString()).toList();
    if (!keys.contains(currentYear)) {
      keys.add(currentYear);
    }
    keys.sort((a, b) => b.compareTo(a));
    // print('Available years: $keys');
    return keys;
  }

  double getTotalExpense() {
    return expenseList.fold(
        0, (sum, item) => sum + (double.tryParse(item['Amount'] ?? '0') ?? 0));
  }

  // double getTotalExpense() {
  //   double total = 0;
  //   for (var item in expenseList) {
  //     final amount = double.tryParse(item['Amount'] ?? '0') ?? 0;
  //     total += amount;
  //   }
  //   return total;
  // }

  addExpense(Map<String, dynamic> data) async {
    await expenseBox.add(data);
    readExpense();
  }

  readExpense() {
    var data = expenseBox.keys.map((key) {
      final item = expenseBox.get(key);
      return {
        'key': key,
        'Category': item['Category'] ?? 'unknown',
        'Amount': item['Amount'] ?? 0,
        // 'Description': item['Description']
      };
    }).toList();

    expenseList = data.reversed.toList();
    // notifyListeners();
  }

  deleteExpense(int? key) async {
    await expenseBox.delete(key);
    readExpense();
  }

  updateExpense(int key, Map<String, dynamic> data) async {
    await expenseBox.put(key, data);
    readExpense();
  }

  Future<void> editIncome(String amount) async {
    final value = double.tryParse(amount) ?? 0.0;
    await incomeBox.put('userIncome', value);
  }

  Future<void> addIncome(String amount) async {
    try {
      final newIncome = double.tryParse(amount) ?? 00;
      final previousIncome = double.tryParse(
              incomeBox.get('userIncome', defaultValue: 0).toString()) ??
          0.0;
      final totalIncome = previousIncome + newIncome;

      await incomeBox.put('userIncome', totalIncome);
    } catch (e) {
      print('Error adding income: $e');
    }
  }

  String getIncome() {
    return incomeBox.get('userIncome', defaultValue: 0).toString();
  }

  double getSaving() {
    double income = double.tryParse(getIncome()) ?? 0;
    double totalExpense = getTotalExpense();
    return income - totalExpense;
  }
}
