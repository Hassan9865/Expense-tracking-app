import 'package:daily_expense/pages/Splash%20View/splash_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  MaterialRoute(page: SplashView, initial: true),
], dependencies: [
  Singleton(classType: NavigationService),
])
class app {}
