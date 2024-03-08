import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

TextEditingController expenseController = TextEditingController();
TextEditingController amountController = TextEditingController();

var taskBox = Hive.box("taskBox");
List<Map<String, dynamic>> expenseList = [];

void showModel(context, int, Function setState) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Add Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: expenseController,
              decoration: InputDecoration(hintText: "expense"),
            ),
            TextField(
              controller: amountController,
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
                var data = {"Expense": expenseController.text};
                addExpense(data, setState);
                Navigator.of(context).pop();
              },
              child: Text("ADD"))
        ],
      );
    },
  );
}

addExpense(Map<String, dynamic> data, Function setState) async {
  await taskBox.add(data);
  readExpense(setState);
}

readExpense(Function setState) {
  var data = taskBox.keys.map((key) {
    final item = taskBox.get(key);
    return {'key': key, 'task': item['task']};
  }).toList();

  setState(() {
    expenseList = data.reversed.toList();
  });
}
