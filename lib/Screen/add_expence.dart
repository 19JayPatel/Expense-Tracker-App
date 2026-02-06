import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/firestore_services.dart';

class AddExpenseScreen extends StatefulWidget {
  final VoidCallback onSave;
  final Expense? expenseToEdit;

  const AddExpenseScreen({Key? key, required this.onSave, this.expenseToEdit})
    : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final formkey = GlobalKey<FormState>();

  // datavase service
  final Service = FirestoreService();

  // controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // dropdown items
  String selectedCategory = 'Other';

  DateTime selectedDate = DateTime.now();

  //categories list
  final Category = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.expenseToEdit != null) {
      titleController = TextEditingController(
        text: widget.expenseToEdit!.title,
      );
      amountController = TextEditingController(
        text: widget.expenseToEdit!.amount.toString(),
      );
      selectedCategory = widget.expenseToEdit!.category;
      selectedDate = widget.expenseToEdit!.date;
    } else {
      titleController = TextEditingController();
      amountController = TextEditingController();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void saveExpense() async {
    if (!formkey.currentState!.validate()) return;

    try {
      print('AddExpenseScreen: saving expense...');
      final expense = Expense(
        id: widget.expenseToEdit?.id ?? '',
        title: titleController.text,
        amount: double.parse(amountController.text),
        category: selectedCategory,
        date: selectedDate,
      );

      if (widget.expenseToEdit != null) {
        await Service.updateExpense(expense);
        print('AddExpenseScreen: expense updated');
      } else {
        await Service.addExpense(expense);
        print('AddExpenseScreen: expense added');
      }

      widget.onSave();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      print('AddExpenseScreen: saveExpense failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving expense: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expenseToEdit != null;

    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          left: 18,
          right: 18,
          top: 18,
        ),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Expense' : 'Add Expense',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 14),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Icon(Icons.currency_rupee),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 7),
              //Dropdown for category
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: Category.map((cat) {
                  IconData icon;
                  switch (cat) {
                    case 'Food':
                      icon = Icons.fastfood;
                      break;
                    case 'Transport':
                      icon = Icons.directions_car;
                      break;
                    case 'Shopping':
                      icon = Icons.shopping_cart;
                      break;
                    case 'Entertainment':
                      icon = Icons.movie;
                      break;
                    case 'Bills':
                      icon = Icons.receipt;
                      break;
                    default:
                      icon = Icons.more_horiz;
                  }

                  return DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        Icon(icon, size: 20, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(cat),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 14),
              //Date picker
              GestureDetector(
                onTap: pickDate,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey),
                      SizedBox(width: 16),
                      Text(
                        'Date ${selectedDate.toString().split(' ')[0]}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.cancel_outlined),
                      label: Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => saveExpense(),
                      icon: Icon(Icons.check),
                      label: Text(isEditing ? 'Update' : 'Save'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
