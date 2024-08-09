// lib/pages/bindings/all_payables_binding.dart

import 'package:deuda/pages/controller/all_payables_controller.dart';
import 'package:get/get.dart';

class AllPayablesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllPayablesController>(() => AllPayablesController());
  }
}
