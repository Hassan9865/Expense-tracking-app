import 'package:daily_expense/app/app.locator.dart';
import 'package:daily_expense/app/app.router.dart';
import 'package:daily_expense/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:stacked_services/stacked_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Hive.initFlutter();
  await Hive.openBox("expenseBox");
  await Hive.openBox("incomeBox");
  await Hive.openBox("monthlyBox");
  await Hive.openBox("yearlyBox");
  await locator<ExpenseService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
