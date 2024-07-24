import 'package:cloud_firestore/cloud_firestore.dart';

class Expenses {
  final String id;
  final String shopNo;
  final String itemName;
  final int amount;

  Expenses({
    required this.id,
    required this.shopNo,
    required this.itemName,
    required this.amount,
  });

  factory Expenses.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Expenses(
      id: doc.id,
      shopNo: data['shopNo'],
      itemName: data['itemName'] ?? '',
      amount: data['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopNo': shopNo,
      'itemName': itemName,
      'amount': amount,
    };
  }

  Expenses copyWith({
    String? id,
    String? shopNo,
    String? itemName,
    int? amount,
  }) {
    return Expenses(
      id: id ?? this.id,
      shopNo: shopNo ?? this.shopNo,
      itemName: itemName ?? this.itemName,
      amount: amount ?? this.amount,
    );
  }
}
