import 'package:daily_expense/BarGraph/barGraph.dart';
import 'package:daily_expense/pages/home_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    @override
    final List<double> weeklySammary = [
      1.23,
      12.21,
      5.12,
      7.13,
      6.13,
      9.41,
      1.34
    ];
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (viewModel) => viewModel.readExpense(),
        builder: (context, HomeViewModel viewModel, index) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                viewModel.showModel(context, context, null);
              },
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                      height: 200,
                      child: MyBarGraph(
                        weeklySammary: weeklySammary,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: viewModel.expenseList.length,
                        itemBuilder: (context, index) {
                          var currentItem = viewModel.expenseList[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: () =>
                                    viewModel.showModel2(context, index),
                                child: ListTile(
                                  title: Text(currentItem['Expense'] ?? ""),
                                  subtitle:
                                      Text(currentItem['Description'] ?? ""),
                                  trailing: Text(currentItem['Amount'] ?? ""),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
