import 'package:hive/hive.dart';

class ExpenseService {
  late Box expenseBox;
  late Box incomeBox;
  late Box monthlyBox;

  List<Map<String, dynamic>> expenseList = [];

  Future<void> init() async {
    expenseBox = Hive.box("expenseBox");
    incomeBox = Hive.box("incomeBox");
    monthlyBox = Hive.box("monthlyBox");

    readExpense(); // Optional: Load data initially
  }

  double getTotalExpense() {
    double total = 0;
    for (var item in expenseList) {
      final amount = double.tryParse(item['Amount'] ?? '0') ?? 0;
      total += amount;
    }
    return total;
  }

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
    // notifyListeners();
  }

  updateExpense(int key, Map<String, dynamic> data) async {
    await expenseBox.put(key, data);
    readExpense();
  }

  Future<void> editIncome(String amount) async {
    final value = double.tryParse(amount) ?? 0.0;
    await incomeBox.put('userIncome', value);
    // notifyListeners();
  }

  Future<void> addIncome(String amount) async {
    try {
      final newIncome = double.tryParse(amount) ?? 00;
      final previousIncome = double.tryParse(
              incomeBox.get('userIncome', defaultValue: 0).toString()) ??
          0.0;
      final totalIncome = previousIncome + newIncome;

      await incomeBox.put('userIncome', totalIncome);
      // notifyListeners();
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
