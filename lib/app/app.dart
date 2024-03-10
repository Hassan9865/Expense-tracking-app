import 'package:daily_expense/pages/homeview.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  MaterialRoute(page: HomePage, initial: true),
], dependencies: [
  Singleton(classType: NavigationService),
])
class app {}
