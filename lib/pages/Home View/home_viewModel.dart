import 'package:daily_expense/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService navigationService = NavigationService();
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController incomeController = TextEditingController();

  navigateToMonthlyExpenseView() {
    navigationService.navigateToMonthlyExpenseView();
  }

  var expenseBox = Hive.box("expenseBox");
  List<Map<String, dynamic>> expenseList = [];

  var incomeBox = Hive.box("incomeBox");
  var monthlyBox = Hive.box("monthlyBox");
  var metaBox = Hive.box("metaBox");

  String getCurrentMonthKey() {
    final now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}-${now.year}';
  }

  void checkAndResetIfNewMonth() {
    String currentMonthKey = getCurrentMonthKey();
    String? lastSavedMonth = metaBox.get('lastSavedMonth');

    // If first time or new month detected
    if (lastSavedMonth != currentMonthKey) {
      // Save old month’s summary
      saveMonthlySummary(lastSavedMonth ?? currentMonthKey);

      // Clear taskBox (expenses)
      expenseBox.clear();

      // Set new income = previous savings
      double saving = getSaving();
      editIncome(saving.toString());

      // Save current as last saved
      metaBox.put('lastSavedMonth', currentMonthKey);
    }
  }

  void saveMonthlySummary(String monthKey) {
    final income = double.tryParse(getIncome()) ?? 0;
    final expenses = expenseBox.values.toList();
    double totalExpense = 0;
    List<Map<String, dynamic>> expenseList = [];

    for (var item in expenses) {
      double amount = double.tryParse(item['Amount'] ?? '0') ?? 0;
      totalExpense += amount;
      expenseList.add({
        'Category': item['Category'] ?? 'unknown',
        'Amount': amount,
      });
    }

    double saving = income - totalExpense;

    monthlyBox.put(monthKey, {
      'income': income,
      'totalExpense': totalExpense,
      'savings': saving,
      'expenses': expenseList,
    });
  }

  List<String> getAllMonths() {
    return monthlyBox.keys.cast<String>().toList();
  }

  Map<String, dynamic> getMonthData(String key) {
    return monthlyBox.get(key);
  }

  double getTotalExpense() {
    double total = 0;
    for (var item in expenseList) {
      final amount = double.tryParse(item['Amount'] ?? '0') ?? 0;
      total += amount;
    }
    return total;
  }

  void showModel(context, contex, int? key) async {
    categoryController.clear();
    amountController.clear();

    if (key != null) {
      final item = expenseList.firstWhere((element) => element['key'] == key);
      categoryController.text = item["Category"];
      amountController.text = item["Amount"];
      // descriptionController.text = item["Description"];
    }
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(key == null ? "Add Expense" : "Edit Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: InputDecoration(hintText: "Category"),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Amount"),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
                onPressed: () {
                  var data = {
                    "Category": categoryController.text,
                    "Amount": amountController.text,
                  };
                  if (key == null) {
                    addExpense(data);
                  } else {
                    updateExpense(key, data);
                  }
                  Navigator.of(context).pop();
                },
                child: Text(key == null ? "ADD" : "Edit"))
          ],
        );
      },
    );
  }

  showModel2(context, int index) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("What do you want to do?"),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  var currentItem = expenseList[index];
                  showModel(context, context, currentItem["key"]);
                },
                icon: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit),
                    Text('Edit'),
                  ],
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              IconButton(
                onPressed: () {
                  var currentItem = expenseList[index];
                  deleteExpense(currentItem['key']);
                  Navigator.of(context).pop();
                },
                icon: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
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
    notifyListeners();
  }

  deleteExpense(int? key) async {
    await expenseBox.delete(key);
    readExpense();
    notifyListeners();
  }

  updateExpense(int key, Map<String, dynamic> data) async {
    await expenseBox.put(key, data);
    readExpense();
  }

  Future<void> editIncome(String amount) async {
    await incomeBox.put('userIncome', amount);
    notifyListeners();
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
