import 'package:expenses/features/home/expenses_bloc/expenses_bloc.dart';
import 'package:expenses/features/home/expenses_bloc/expenses_event.dart';
import 'package:expenses/features/home/repository/expenses_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpensesBloc(ExpensesRepository())
        ..add(
          LoadExpenses(),
        ),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expenses',
        themeMode: ThemeMode.system,
        home: HomeScreen(),
      ),
    );
  }
}
