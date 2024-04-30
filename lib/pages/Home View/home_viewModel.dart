import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  TextEditingController expenseController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var taskBox = Hive.box("taskBox");
  List<Map<String, dynamic>> expenseList = [];

  void showModel(context, contex, int? key) async {
    expenseController.clear();
    amountController.clear();
    descriptionController.clear();

    if (key != null) {
      final item = expenseList.firstWhere((element) => element['key'] == key);
      expenseController.text = item["Expense"];
      amountController.text = item["Amount"];
      descriptionController.text = item["Description"];
    }
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(key == null ? "Add Expense" : "Edit Expense"),
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
                      keyboardType: TextInputType.number,
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

  updateExpense(int key, Map<String, dynamic> data) async {
    await taskBox.put(key, data);
    readExpense();
  }
}
