import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ExpenseService {
  late Box expenseBox;
  late Box incomeBox;
  late Box monthlyBox;

  List<Map<String, dynamic>> expenseList = [];
  List<Map<String, dynamic>> monthlySummaries = [];

  Future<void> init() async {
    expenseBox = await Hive.openBox("expenseBox");
    incomeBox = await Hive.openBox("incomeBox");
    monthlyBox = await Hive.openBox("monthlyBox");
    readExpense();
    loadMonthlySummaries();
    _checkMonthEnd();
    await _handleMonthEndTransition();
  }

  Future<void> _checkMonthEnd() async {
    final now = DateTime.now();
    final lastRecordedMonth = incomeBox.get('lastRecordedMonth');
    final currentMonth = DateFormat('MMM yyyy').format(now);

    if (lastRecordedMonth != null && lastRecordedMonth != currentMonth) {
      await _handleMonthEndTransition();
    }
  }

  Future<void> _handleMonthEndTransition() async {
    // 1. Save current month's data
    final savings = getSaving();
    await _createMonthlySummary();

    // 2. Reset for new month (savings become new income)
    await incomeBox.put('userIncome', savings);
    await expenseBox.clear();
    readExpense();

    // 3. Update last recorded month
    await incomeBox.put(
        'lastRecordedMonth', DateFormat('MMM yyyy').format(DateTime.now()));

    loadMonthlySummaries();
  }

  // Add this method to create monthly summaries
  Future<void> _createMonthlySummary() async {
    final now = DateTime.now();
    final currentMonthYear = DateFormat('MMM yyyy').format(now);

    // Check if summary already exists for this month
    if (monthlyBox.containsKey(currentMonthYear)) {
      return;
    }

    final totalIncome = double.tryParse(getIncome()) ?? 0;
    final totalExpense = getTotalExpense();
    final savings = totalIncome - totalExpense;

    final monthlyData = {
      'month': currentMonthYear,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'savings': savings,
      'expenses': List<Map<String, dynamic>>.from(expenseList),
      // 'expenses': expenseList,
      'timestamp': now.millisecondsSinceEpoch,
    };

    await monthlyBox.put(currentMonthYear, monthlyData);
    // _loadMonthlySummaries();
  }

  Future<void> loadMonthlySummaries() async {
    monthlySummaries = monthlyBox.keys.map((key) {
      final data = monthlyBox.get(key);
      return {
        'month': key,
        'totalIncome': data['totalIncome'],
        'totalExpense': data['totalExpense'],
        'savings': data['savings'],
        'expenses': data['expenses'],
      };
    }).toList();

    // Sort by timestamp (newest first)
    monthlySummaries.sort((a, b) {
      final aTime = monthlyBox.get(a['month'])['timestamp'];
      final bTime = monthlyBox.get(b['month'])['timestamp'];
      return bTime.compareTo(aTime);
    });
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
