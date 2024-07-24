

import 'package:equatable/equatable.dart';

import '../expenses_model.dart';

abstract class ExpensesEvent extends Equatable {
  const ExpensesEvent();

  @override
  List<Object> get props => [];
}

class LoadExpenses extends ExpensesEvent {}

class AddExpenses extends ExpensesEvent {
  final Expenses expenses;

  const AddExpenses({required this.expenses});

  @override
  List<Object> get props => [expenses];
}


