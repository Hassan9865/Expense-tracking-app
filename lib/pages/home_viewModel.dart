import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  TextEditingController expenseController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var taskBox = Hive.box("taskBox");
  List<Map<String, dynamic>> expenseList = [];

  void showModel(context, contex, int) {
    expenseController.clear();
    amountController.clear();
    descriptionController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      controller: expenseController,
                      decoration: InputDecoration(hintText: "Title"),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      decoration: InputDecoration(hintText: "Amount"),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: "description"),
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
                    "Expense": expenseController.text,
                    "Amount": amountController.text,
                    "Description": descriptionController.text,
                  };
                  addExpense(data);
                  Navigator.of(context).pop();
                },
                child: Text("ADD"))
          ],
        );
      },
    );
  }

  showModel2(context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("What do you want to do?"),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit),
                    Text('Edit'),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
              ),
              IconButton(
                onPressed: () {
                  var currentItem = expenseList[index];
                  deleteExpense(currentItem['key']);
                  Navigator.of(context).pop();
                },
                icon: Column(
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
    await taskBox.add(data);
    readExpense();
  }

  readExpense() {
    var data = taskBox.keys.map((key) {
      final item = taskBox.get(key);
      return {
        'key': key,
        'Expense': item['Expense'],
        'Amount': item['Amount'],
        'Description': item['Description']
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
}
