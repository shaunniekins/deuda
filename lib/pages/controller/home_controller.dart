// lib/pages/controller/home_controller.dart

import 'package:deuda/data/models/debt_model.dart';
import 'package:deuda/data/services/storage_service.dart';
import 'package:get/get.dart';
import 'debt_controller_mixin.dart';

class HomeController extends GetxController with DebtControllerMixin {
  final StorageService _storageService = Get.find<StorageService>();

  final totalBalance = 0.0.obs;
  final percentageOfTotalPaid = 0.0.obs;
  final totalDebts = 0.obs;
  final upcomingDues = <DebtModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(_storageService.debts, (_) => _updateData());
    _updateData();
  }

  void _updateData() {
    final debts = _storageService.debts;
    totalDebts.value = debts.length;

    double total = 0;
    double paid = 0;

    for (var debt in debts) {
      total += debt.principalAmount;
      paid += debt.paidAmount;
    }

    totalBalance.value = total - paid;
    percentageOfTotalPaid.value = total > 0 ? (paid / total) * 100 : 0;

    upcomingDues.value = debts.toList()
      ..sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
  }
}
