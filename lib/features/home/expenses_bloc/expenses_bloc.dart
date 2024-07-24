import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/expenses_repository.dart';
import 'expenses_event.dart';
import 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final ExpensesRepository _expensesRepository;

  ExpensesBloc(this._expensesRepository) : super(ExpensesLoading()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpenses>(_onAddExpenses);
  }

  Future<void> _onLoadExpenses(
      LoadExpenses event, Emitter<ExpensesState> emit) async {
    emit(ExpensesLoading());
    try {
      final expenses = await _expensesRepository.getExpenses().first;
      emit(ExpensesLoaded(expenses));
    } catch (e) {
      emit(ExpensesError(message: e.toString()));
    }
  }

  Future<void> _onAddExpenses(
      AddExpenses event, Emitter<ExpensesState> emit) async {
    try {
      await _expensesRepository.addExpenses(event.expenses);
      emit(ExpensesAdded());
    } on FirebaseException catch (e) {
      emit(ExpensesError(message: e.toString(), errorCode: e.code));
    } catch (e) {
      emit(ExpensesError(message: e.toString()));
    }
  }
}
