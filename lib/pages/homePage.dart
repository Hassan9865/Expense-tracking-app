import 'package:daily_expense/BarGraph/barGraph.dart';
import 'package:daily_expense/functions/functions.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readExpense(setState);
  }

  List<double> weeklySammary = [
    32.2,
    24.3,
    61.63,
    51.1,
    12.2,
    23.5,
    52.6,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModel(context, null, setState);
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
                  itemCount: expenseList.length,
                  itemBuilder: (context, index) {
                    var currentItem = expenseList[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 10, left: 8, right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(currentItem['task']),
                          // trailing: Text("313897"),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
