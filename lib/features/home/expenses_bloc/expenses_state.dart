import '../expenses_model.dart';

abstract class ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<Expenses> expenses;

  ExpensesLoaded(this.expenses);
}

class ExpensesError extends ExpensesState {
  final String message;
  final String? errorCode;

  ExpensesError({required this.message, this.errorCode});
}

class ExpensesAdded extends ExpensesState {}
