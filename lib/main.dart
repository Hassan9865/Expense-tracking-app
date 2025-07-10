import 'package:daily_expense/pages/Home%20View/home_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await setupLocator();
  await Hive.initFlutter();
  await Hive.openBox("expenseBox");
  await Hive.openBox("incomeBox");
  await Hive.openBox("monthlyBox");
  await Hive.openBox("metaBox");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // navigatorKey: StackedService.navigatorKey,
      // onGenerateRoute: StackedRouter().onGenerateRoute,
      home: HomePage(),
    );
  }
}
