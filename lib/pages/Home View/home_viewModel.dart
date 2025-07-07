import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController incomeController = TextEditingController();

  var taskBox = Hive.box("taskBox");
  List<Map<String, dynamic>> expenseList = [];

  var incomeBox = Hive.box("incomeBox");

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

  showIncomeModel(
    context,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Income"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: incomeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Amount"),
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
            TextButton(
                onPressed: () {
                  var amount = incomeController.text;
                  setIncome(amount);
                  Navigator.pop(context);
                },
                child: Text("Add"))
          ],
        );
      },
    );
  }

  addExpense(Map<String, dynamic> data) async {
    await taskBox.add(data);
    readExpense();
  }

  readExpense() {
    var data = taskBox.keys.map((key) {
      final item = taskBox.get(key);
      return {
        'key': key,
        'Category': item['Category'],
        'Amount': item['Amount'],
        // 'Description': item['Description']
      };
    }).toList();

    expenseList = data.reversed.toList();
    notifyListeners();
  }

  deleteExpense(int? key) async {
    await taskBox.delete(key);
    readExpense();
    notifyListeners();
  }

  updateExpense(int key, Map<String, dynamic> data) async {
    await taskBox.put(key, data);
    readExpense();
  }

  Future<void> setIncome(String amount) async {
    await incomeBox.put('userIncome', amount);
    notifyListeners();
  }

  String getIncome() {
    return incomeBox.get('userIncome', defaultValue: 0);
  }

  double getSaving() {
    double income = double.tryParse(getIncome()) ?? 0;
    double totalExpense = getTotalExpense();
    return income - totalExpense;
  }
}
