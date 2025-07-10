import 'package:daily_expense/pages/Home%20View/home_view.dart';
import 'package:daily_expense/pages/Monthly%20Expense/MonthlyExpense_view.dart';
import 'package:daily_expense/pages/Splash%20View/splash_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: SplashView, initial: true),
    MaterialRoute(page: HomePage),
    MaterialRoute(page: MonthlyExpenseView),
  ],
  dependencies: [
    Singleton(classType: NavigationService),
  ],
)
class App {}
