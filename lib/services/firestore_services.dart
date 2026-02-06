import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionPath = 'expenses';

  Stream<List<Expense>> getAllExpenses() {
    return _db
        .collection(collectionPath)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Expense.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<double> getTotalExpenseByMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final firstTs = Timestamp.fromDate(firstDay);
    final lastTs = Timestamp.fromDate(lastDay);

    return _db
        .collection(collectionPath)
        .where('date', isGreaterThanOrEqualTo: firstTs)
        .where('date', isLessThanOrEqualTo: lastTs)
        .snapshots()
        .map((snapshot) {
          double total = 0.0;

          for (var doc in snapshot.docs) {
            final data = doc.data();
            total += (data['amount'] as num?)?.toDouble() ?? 0.0;
          }
          return total;
        });
  }

  //Get total expense overall
  Stream<double> getTotalExpense() {
    return _db.collection(collectionPath).snapshots().map((snapshot) {
      double total = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        total += (data['amount'] as num?)?.toDouble() ?? 0.0;
      }
      return total;
    });
  }

  //Get Expense for specific month

  Stream<List<Expense>> getExpensesByMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final firstTs = Timestamp.fromDate(firstDay);
    final lastTs = Timestamp.fromDate(lastDay);

    return _db
        .collection(collectionPath)
        .where('date', isGreaterThanOrEqualTo: firstTs)
        .where('date', isLessThanOrEqualTo: lastTs)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Expense.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  //Add expense

  Future<void> addExpense(Expense expense) async {
    try {
      final docRef = await _db
          .collection(collectionPath)
          .add(expense.toFirestore());
      print('Firestore: added expense id=${docRef.id}');
    } catch (e, st) {
      print('Firestore: addExpense failed: $e\n$st');
      throw Exception('Failed to add expense: $e');
    }
  }

  //Update expense

  Future<void> updateExpense(Expense expense) async {
    try {
      if (expense.id.isEmpty) {
        // If id is missing, fall back to add to avoid failing silently
        final docRef = await _db
            .collection(collectionPath)
            .add(expense.toFirestore());
        print(
          'Firestore: updateExpense fallback added expense id=${docRef.id}',
        );
        return;
      }

      await _db
          .collection(collectionPath)
          .doc(expense.id)
          .update(expense.toFirestore());
      print('Firestore: updated expense id=${expense.id}');
    } catch (e) {
      print('Firestore: updateExpense failed: $e');
      throw Exception('Failed to update expense: $e');
    }
  }

  //Delete expense
  Future<void> deleteExpense(String id) async {
    try {
      await _db.collection(collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }
}
