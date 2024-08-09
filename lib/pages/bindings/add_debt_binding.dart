// lib/pages/bindings/add_debt_binding.dart

import 'package:deuda/pages/controller/add_debt_controller.dart';
import 'package:get/get.dart';

class AddDebtBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDebtController>(() => AddDebtController());
  }
}
