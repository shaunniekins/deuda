// lib/pages/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final numberFormat = NumberFormat('#,##0.00');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deuda'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              _buildBalanceCard(),
              _buildUpcomingDuesList(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  backgroundColor: Colors.deepPurple[900],
                ),
                onPressed: () => Get.toNamed('/all-payables'),
                child: const Text(
                  'See All',
                  style: TextStyle(fontSize: 12.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-debt'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Obx(() => SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.teal,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                children: [
                  const Text(
                    'Remaining Balance',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'P ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: numberFormat
                              .format(controller.totalBalance.value),
                          style: const TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[500]?.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${controller.percentageOfTotalPaid.value.toStringAsFixed(2)}%',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  )
                  // Text('Total debts: ${controller.totalDebts.value}'),
                ],
              ),
            ),
          ),
        )));
  }

  Widget _buildUpcomingDuesList() {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.upcomingDues.length > 5
              ? 5
              : controller.upcomingDues.length,
          itemBuilder: (context, index) {
            final debt = controller.upcomingDues[index];
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
        ));
  }
}
