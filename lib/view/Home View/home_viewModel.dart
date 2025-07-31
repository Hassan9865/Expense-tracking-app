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
}
