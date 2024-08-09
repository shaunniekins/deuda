// lib/pages/views/add_debt_view.dart

import 'package:deuda/pages/controller/add_debt_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDebtView extends GetView<AddDebtController> {
  const AddDebtView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Debt')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.debtorNameController,
                decoration: const InputDecoration(labelText: 'Debtor Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: controller.principalAmountController,
                decoration:
                    const InputDecoration(labelText: 'Principal Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<int>(
                value: controller.selectedTerms.value,
                items: List.generate(10, (index) => index + 1).map((term) {
                  return DropdownMenuItem<int>(
                    value: term,
                    child: Text('$term ${term == 1 ? 'term' : 'terms'}'),
                  );
                }).toList(),
                onChanged: (value) => controller.updateSelectedTerms(value!),
                decoration: const InputDecoration(labelText: 'Number of Terms'),
              ),
              Obx(() => Column(
                    children:
                        List.generate(controller.selectedTerms.value, (index) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller:
                                  controller.termAmountControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Amount for Term ${index + 1}',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller:
                                  controller.termDueDateControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Due Date for Term ${index + 1}',
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Required' : null,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365 * 5)),
                                );
                                if (pickedDate != null) {
                                  controller
                                          .termDueDateControllers[index].text =
                                      "${pickedDate.year.toString().padLeft(4, '0')}-"
                                      "${pickedDate.month.toString().padLeft(2, '0')}-"
                                      "${pickedDate.day.toString().padLeft(2, '0')}";
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  )),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FloatingActionButton.extended(
          onPressed: controller.saveDebt,
          label: const Text('Save Debt'),
          icon: const Icon(Icons.save),
          backgroundColor: Colors.deepPurple[900],
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
