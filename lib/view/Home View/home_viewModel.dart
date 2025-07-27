import 'package:daily_expense/app/app.locator.dart';
import 'package:daily_expense/app/app.router.dart';
import 'package:daily_expense/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final NavigationService navigationService = locator<NavigationService>();
  final ExpenseService _expenseService = locator<ExpenseService>();

  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController incomeController = TextEditingController();

  List<Map<String, dynamic>> expenseList() => _expenseService.expenseList;

  navigateToMonthlyExpenseView() {
    navigationService.navigateToMonthlyExpenseView();
  }

  navigateToYearlyExpenseView() {
    navigationService.navigateToYearlyExpenseView();
  }

  Future<void> addIncome(String amount) async {
    await _expenseService.addIncome(amount);
    notifyListeners();
  }

  Future<void> editIncome(String amount) async {
    await _expenseService.editIncome(amount);
    notifyListeners();
  }

  String getIncome() => _expenseService.getIncome();

  double getSaving() => _expenseService.getSaving();

  Future<void> addExpense(Map<String, dynamic> data) async {
    await _expenseService.addExpense(data);
    notifyListeners();
  }

  Future<void> updateExpense(int key, Map<String, dynamic> data) async {
    await _expenseService.updateExpense(key, data);
    notifyListeners();
  }

  Future<void> deleteExpense(int key) async {
    await _expenseService.deleteExpense(key);
    notifyListeners();
  }

  void readExpense() {
    _expenseService.readExpense();
    notifyListeners();
  }

  double getTotalExpense() => _expenseService.getTotalExpense();
  // var expenseBox = Hive.box("expenseBox");
  // List<Map<String, dynamic>> expenseList = [];

  // var incomeBox = Hive.box("incomeBox");
  // var monthlyBox = Hive.box("monthlyBox");

  // double getTotalExpense() {
  //   double total = 0;
  //   for (var item in expenseList) {
  //     final amount = double.tryParse(item['Amount'] ?? '0') ?? 0;
  //     total += amount;
  //   }
  //   return total;
  // }

  // addExpense(Map<String, dynamic> data) async {
  //   await expenseBox.add(data);
  //   readExpense();
  // }

  // readExpense() {
  //   var data = expenseBox.keys.map((key) {
  //     final item = expenseBox.get(key);
  //     return {
  //       'key': key,
  //       'Category': item['Category'] ?? 'unknown',
  //       'Amount': item['Amount'] ?? 0,
  //       // 'Description': item['Description']
  //     };
  //   }).toList();

  //   expenseList = data.reversed.toList();
  //   notifyListeners();
  // }

  // deleteExpense(int? key) async {
  //   await expenseBox.delete(key);
  //   readExpense();
  //   notifyListeners();
  // }

  // updateExpense(int key, Map<String, dynamic> data) async {
  //   await expenseBox.put(key, data);
  //   readExpense();
  // }

  // Future<void> editIncome(String amount) async {
  //   final value = double.tryParse(amount) ?? 0.0;
  //   await incomeBox.put('userIncome', value);
  //   notifyListeners();
  // }

  // Future<void> addIncome(String amount) async {
  //   try {
  //     final newIncome = double.tryParse(amount) ?? 00;
  //     final previousIncome = double.tryParse(
  //             incomeBox.get('userIncome', defaultValue: 0).toString()) ??
  //         0.0;
  //     final totalIncome = previousIncome + newIncome;

  //     await incomeBox.put('userIncome', totalIncome);
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error adding income: $e');
  //   }
  // }

  // String getIncome() {
  //   return incomeBox.get('userIncome', defaultValue: 0).toString();
  // }

  // double getSaving() {
  //   double income = double.tryParse(getIncome()) ?? 0;
  //   double totalExpense = getTotalExpense();
  //   return income - totalExpense;
  // }
}
