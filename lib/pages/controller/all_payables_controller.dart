// lib/pages/controller/all_payables_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deuda/data/models/debt_model.dart';
import 'package:deuda/data/services/storage_service.dart';
import 'debt_controller_mixin.dart';

class AllPayablesController extends GetxController with DebtControllerMixin {
  final StorageService _storageService = Get.find<StorageService>();

  final payables = <DebtModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPayables();
  }

  Future<void> loadPayables() async {
    isLoading.value = true;
    await Future.delayed(
        const Duration(seconds: 1)); // Simulate a delay for loading
    payables.value = _storageService.debts;
    payables.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
    isLoading.value = false;
  }

  void showDebtDetails(DebtModel debt) {
    Get.dialog(
      AlertDialog(
        title: Text(debt.debtorName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Principal Amount: P${debt.principalAmount.toStringAsFixed(2)}'),
            Text('Total Terms: ${debt.totalTerms}'),
            Text('Current Term: ${debt.currentTerm}'),
            Text('Next Due Date: ${debt.nextDueDate.toString().split(' ')[0]}'),
            Text(
                'Amount Due: P${debt.termAmounts[debt.currentTerm - 1].toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
