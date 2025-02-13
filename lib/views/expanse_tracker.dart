import 'package:flutter/material.dart';

import '../model/expense.dart';
import 'package:intl/intl.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final List<Expense> _expense = [];
  final List<String> _category = [
    'Food',
    'Transport',
    'Entertainment',
    'Bills'
  ];
  double total = 0.0;
  void _addExpense(
      String title, double amount, DateTime date, String category) {
    setState(() {
      _expense.add(Expense(
          title: title, amount: amount, category: category, date: date));
      total += amount;
    });
  }

  void _showForm(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    String selectedCategory = _category.first;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                items: _category
                    .map((category) => DropdownMenuItem(
                        value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) => selectedCategory = value!,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        double.tryParse(amountController.text) == null) {
                      return;
                    }
                    _addExpense(
                        titleController.text,
                        double.tryParse(amountController.text)!,
                        DateTime.now(),
                        selectedCategory);
                    titleController.clear();
                    amountController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Add Expense'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: () {
              _showForm(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Center(
            child: Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Total: \$$total',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expense.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(_expense[index].category[0]),
                    ),
                    title: Text(_expense[index].title),
                    subtitle:
                        Text(DateFormat.yMMMd().format(_expense[index].date)),
                    trailing: Text('\$${_expense[index].amount.toString()}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
