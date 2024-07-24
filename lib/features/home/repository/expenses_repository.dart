import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/features/home/expenses_model.dart';

class ExpensesRepository {
  final FirebaseFirestore _firestore;

  ExpensesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
  Stream<List<Expenses>> getExpenses() {
    return _firestore.collection('expenses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Expenses.fromDocument(doc)).toList();
    });
  }

  Future<void> addExpenses(Expenses expenses) {
    return _firestore.collection('expenses').add(expenses.toMap());
  }
}
