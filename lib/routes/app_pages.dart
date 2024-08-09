// lib/routes/app_pages.dart

import 'package:deuda/pages/bindings/add_debt_binding.dart';
import 'package:deuda/pages/bindings/all_payables_binding.dart';
import 'package:deuda/pages/views/add_debt_view.dart';
import 'package:deuda/pages/bindings/home_binding.dart';
import 'package:deuda/pages/views/all_payables_view.dart';
import 'package:deuda/pages/views/home_view.dart';
import 'package:get/get.dart';
import 'package:deuda/routes/app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ADD_DEBT,
      page: () => const AddDebtView(),
      binding: AddDebtBinding(),
    ),
    GetPage(
      name: Routes.ALL_PAYABLES,
      page: () => const AllPayablesView(),
      binding: AllPayablesBinding(),
    ),
  ];
}
