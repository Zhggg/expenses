import 'package:expenses/features/home/expenses_bloc/bloc_exports.dart';
import 'package:expenses/features/home/expenses_bloc/expenses_event.dart';
import 'package:expenses/features/home/expenses_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/icon_btn.dart';
import '../../common/widgets/textfield.dart';
import 'expenses_bloc/expenses_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController shopNoController;
  late TextEditingController itemController;
  late TextEditingController amountController;
  late ExpensesBloc expensesBloc;
  late SharedPreferences _prefs;
  static const String _remainingBalanceKey = 'remaining_balance';

  double _remainingBalance = 10000.0;

  @override
  void initState() {
    super.initState();

    shopNoController = TextEditingController();
    itemController = TextEditingController();
    amountController = TextEditingController();
    expensesBloc = BlocProvider.of<ExpensesBloc>(context);
    _loadRemainingBalance();
    expensesBloc.add(LoadExpenses());
  }

  Future<void> _loadRemainingBalance() async {
    _prefs = await SharedPreferences.getInstance();
    final storedBalance = _prefs.getDouble(_remainingBalanceKey);
    if (storedBalance != null) {
      setState(() {
        _remainingBalance = storedBalance;
      });
    }
  }

  Future<void> _saveRemainingBalance() async {
    await _prefs.setDouble(_remainingBalanceKey, _remainingBalance);
  }

  @override
  void dispose() {
    shopNoController.dispose();
    itemController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense(BuildContext context) async {
    try {
      final expenses = Expenses(
        id: '',
        shopNo: shopNoController.text.trim(),
        itemName: itemController.text.trim(),
        amount: int.parse(amountController.text.trim()),
      );

      context.read<ExpensesBloc>().add(AddExpenses(expenses: expenses));
      setState(() {
        _remainingBalance -= expenses.amount;
        _saveRemainingBalance();
      });
      shopNoController.clear();
      itemController.clear();
      amountController.clear();

      context.read<ExpensesBloc>().add(LoadExpenses());

      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while saving expenses: $error'),
        ),
      );
    }
  }

  void _addExpense(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Purchased Detail',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: CustomTextField(
                              controller: shopNoController,
                              keyboardType: TextInputType.number,
                              label: "Shop No.",
                              prefixIcon: Icons.store,
                            ),
                          ),
                          const Gap(10),
                          Flexible(
                            flex: 6,
                            child: CustomTextField(
                              controller: itemController,
                              label: "Purchased Item",
                              prefixIcon: Icons.shopping_bag,
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      CustomTextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        label: "Amount",
                        prefixIcon: Icons.currency_rupee,
                      ),
                      const Gap(15),
                      ElevatedButton(
                        onPressed: () => _saveExpense(context),
                        child: const Text(
                          "Save",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpensesBloc, ExpensesState>(
      listener: (context, state) {
        if (state is ExpensesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: ${state.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is ExpensesAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Expense Added Successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          context.read<ExpensesBloc>().add(LoadExpenses());
        }
      },
      builder: (context, state) {
        if (state is ExpensesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExpensesError) {
          return const Center(
            child: Text('An error occurred. Please try again.'),
          );
        } else if (state is ExpensesLoaded) {
          final expenses = state.expenses;

          return Scaffold(
            appBar: AppBar(
              title: const Text("Expenses"),
              actions: [
                CustomIconButton(
                  onPressed: () => _addExpense(context),
                  iconData: Icons.add,
                ),
              ],
            ),
            body: expenses.isNotEmpty
                ? Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                  "Remaining Balance: Rs $_remainingBalance",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )),
                              ),
                              const Gap(10),
                              SizedBox(
                                height: 650,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: expenses.length,
                                  itemBuilder: (context, index) {
                                    final expense = expenses[index];
                                    return ListTile(
                                      leading: Text(expense.shopNo),
                                      title: Text(expense.itemName),
                                      subtitle: Text("Rs ${expense.amount}"),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No expenses added yet'),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
          );
        } else {
          return const Center(child: Text('Something went wrong!'));
        }
      },
    );
  }
}
