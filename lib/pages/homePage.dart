import 'package:daily_expense/BarGraph/barGraph.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
                height: 200,
                child: MyBarGraph(
                  weeklySammary: weeklySammary,
                )),
          ],
        ),
      ),
    );
  }
}
