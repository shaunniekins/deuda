// lib/data/services/storage_service.dart

import 'package:deuda/data/models/debt_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late GetStorage _box;
  final debts = <DebtModel>[].obs;

  Future<StorageService> init() async {
    _box = GetStorage();
    loadDebts();
    return this;
  }

  void loadDebts() {
    final debtsJson = _box.read<List>('debts') ?? [];
    debts.value = debtsJson.map((json) => DebtModel.fromJson(json)).toList();
  }

  void addDebt(DebtModel debt) {
    debts.add(debt);
    _saveDebts();
  }

  void updateDebt(int index, DebtModel updatedDebt) {
    debts[index] = updatedDebt;
    _saveDebts();
  }

  void _saveDebts() {
    _box.write('debts', debts.map((debt) => debt.toJson()).toList());
  }
}