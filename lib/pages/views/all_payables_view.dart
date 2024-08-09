// lib/pages/views/all_payables_view.dart

import 'package:deuda/pages/controller/all_payables_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllPayablesView extends GetView<AllPayablesController> {
  const AllPayablesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Payables'),
      ),
      body: FutureBuilder(
        future:
            controller.loadPayables(), // Ensure this method returns a Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (controller.payables.isEmpty) {
            return const Center(child: Text('No payables found'));
          } else {
            // return ListView.builder(
            //   itemCount: controller.payables.length,
            //   itemBuilder: (context, index) {
            //     final debt = controller.payables[index];
            //     return ListTile(
            //       title: Text(debt.debtorName),
            //       subtitle:
            //           Text('Due: ${debt.nextDueDate.toString().split(' ')[0]}'),
            //     );
            //   },
            // );
            return _buildUpcomingDuesList();
          }
        },
      ),
    );
  }

  Widget _buildUpcomingDuesList() {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              controller.payables.length > 5 ? 5 : controller.payables.length,
          itemBuilder: (context, index) {
            final debt = controller.payables[index];
            final isPastDue = debt.nextDueDate.isBefore(DateTime.now());
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
              title: Text(
                debt.debtorName,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isPastDue ? Colors.red : null),
              ),
              subtitle: Text(
                'Due: ${debt.nextDueDate}',
                style: TextStyle(
                    fontSize: 12, color: isPastDue ? Colors.red : null),
              ),
              trailing: Text('${debt.currentTerm} of ${debt.totalTerms} terms'),
              onTap: () => controller.showPaymentPrompt(debt),
            );
          },
        )));
  }
}
