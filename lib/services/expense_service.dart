import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  ExpenseService({required this.userId});

  // Create expense
  Future<void> addExpense(Expense expense) async {
    await _firestore.collection('expenses').add(expense.toMap());
  }

  // Read expenses
  Stream<List<Expense>> getExpenses() {
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  // Update expense
  Future<void> updateExpense(String id, Expense expense) async {
    await _firestore.collection('expenses').doc(id).update(expense.toMap());
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    await _firestore.collection('expenses').doc(id).delete();
  }

  // Get total balance
  Stream<double> getTotalBalance() {
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      double total = 0;
      for (var doc in snapshot.docs) {
        total += (doc.data()['amount'] ?? 0).toDouble();
      }
      return total;
    });
  }
} 