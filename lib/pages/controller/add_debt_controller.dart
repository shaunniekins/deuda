// lib/pages/controller/add_debt_controller.dart

import 'package:deuda/data/models/debt_model.dart';
import 'package:deuda/data/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDebtController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final formKey = GlobalKey<FormState>();
  final debtorNameController = TextEditingController();
  final principalAmountController = TextEditingController();
  final selectedTerms = 1.obs;
  final termAmountControllers = <TextEditingController>[].obs;
  final termDueDateControllers = <TextEditingController>[].obs;

  @override
  void onInit() {
    super.onInit();
    updateSelectedTerms(1);
  }

  void updateSelectedTerms(int terms) {
    selectedTerms.value = terms;
    termAmountControllers.clear();
    for (int i = 0; i < terms; i++) {
      termAmountControllers.add(TextEditingController());
      termDueDateControllers.add(TextEditingController());
    }
  }

  void saveDebt() {
    if (formKey.currentState!.validate()) {
      // All form fields are valid, proceed with saving
      try {
        final newDebt = DebtModel(
          debtorName: debtorNameController.text,
          principalAmount: double.parse(principalAmountController.text),
          totalTerms: selectedTerms.value,
          dueDates: termDueDateControllers.map((controller) {
            if (controller.text.isEmpty) {
              throw FormatException('Date field is empty');
            }
            return DateTime.parse(controller.text);
          }).toList(),
          termAmounts: termAmountControllers
              .map((controller) => double.parse(controller.text))
              .toList(),
          isPaid: List.generate(selectedTerms.value, (index) => false),
        );

        _storageService.addDebt(newDebt);
        Get.back();
      } catch (e) {
        // Handle the error (show a snackbar or dialog)
        Get.snackbar(
          'Error',
          'Invalid input: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      // Form is not valid, show an error message
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    debtorNameController.dispose();
    principalAmountController.dispose();
    for (var controller in termAmountControllers) {
      controller.dispose();
    }
    for (var controller in termDueDateControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
