// lib/pages/controller/debt_controller_mixin.dart

import 'package:deuda/data/models/debt_model.dart';
import 'package:deuda/data/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin DebtControllerMixin on GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  void showPaymentPrompt(DebtModel debt) {
    Get.defaultDialog(
      title: 'Payment Confirmation',
      middleText: 'Did you pay the due amount for ${debt.debtorName}?',
      textConfirm: 'Paid',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        _markAsPaid(debt);
        Get.back();
      },
    );
  }

  void _markAsPaid(DebtModel debt) {
    final index = _storageService.debts.indexOf(debt);
    if (index != -1) {
      final updatedIsPaid = List<bool>.from(debt.isPaid);
      updatedIsPaid[debt.currentTerm - 1] = true;

      final updatedDebt = DebtModel(
        debtorName: debt.debtorName,
        principalAmount: debt.principalAmount,
        totalTerms: debt.totalTerms,
        dueDates: debt.dueDates,
        termAmounts: debt.termAmounts,
        isPaid: updatedIsPaid,
      );

      _storageService.updateDebt(index, updatedDebt);
    }
  }
}
