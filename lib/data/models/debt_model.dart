// lib/data/models/debt_model.dart

class DebtModel {
  final String debtorName;
  final double principalAmount;
  final int totalTerms;
  final List<DateTime> dueDates;
  final List<double> termAmounts;
  final List<bool> isPaid;

  DebtModel({
    required this.debtorName,
    required this.principalAmount,
    required this.totalTerms,
    required this.dueDates,
    required this.termAmounts,
    required this.isPaid,
  });

  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      debtorName: json['debtorName'] as String,
      principalAmount: (json['principalAmount'] as num).toDouble(),
      totalTerms: json['totalTerms'] as int,
      dueDates: (json['dueDates'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      termAmounts: (json['termAmounts'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      isPaid: (json['isPaid'] as List<dynamic>).map((e) => e as bool).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'debtorName': debtorName,
      'principalAmount': principalAmount,
      'totalTerms': totalTerms,
      'dueDates': dueDates.map((date) => date.toIso8601String()).toList(),
      'termAmounts': termAmounts,
      'isPaid': isPaid,
    };
  }

  DateTime get nextDueDate {
    final unpaidIndex = isPaid.indexOf(false);
    return unpaidIndex != -1 ? dueDates[unpaidIndex] : dueDates.last;
  }

  int get currentTerm {
    return isPaid.where((paid) => paid).length + 1;
  }

  double get paidAmount {
    double total = 0;
    for (int i = 0; i < isPaid.length; i++) {
      if (isPaid[i]) total += termAmounts[i];
    }
    return total;
  }
}
