class Expense {
  final String? id;
  final String name;
  final double amount;
  final DateTime date;
  final String? invoiceUrl;
  final String userId;
  final String currency;

  Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
    this.invoiceUrl,
    required this.userId,
    required this.currency,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'invoiceUrl': invoiceUrl,
      'userId': userId,
      'currency': currency,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: DateTime.parse(map['date']),
      invoiceUrl: map['invoiceUrl'],
      userId: map['userId'] ?? '',
      currency: map['currency'] ?? 'PHP',
    );
  }
} 