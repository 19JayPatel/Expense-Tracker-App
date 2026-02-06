import 'package:expense_tracker/Screen/SplaceScreen.dart';
import 'package:expense_tracker/Screen/add_expence.dart';
import 'package:expense_tracker/Screen/expense_card.dart';
import 'package:expense_tracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/services/firestore_services.dart';
import 'package:expense_tracker/models/expense.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ExpenseTracker());
}

class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          background: Color(0xFFF6F8FB),
          primary: Color(0xFF3550DD),
          secondary: Color(0xFF00BFA6),
        ),
        scaffoldBackgroundColor: Color(0xFFF6F8FB),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF3550DD),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3550DD),
          foregroundColor: Colors.white,
        ),
      ),
      home: SplaceScreen(),
      routes: {'/home': (context) => ExpenseTrackerHome()},
    );
  }
}

class ExpenseTrackerHome extends StatefulWidget {
  const ExpenseTrackerHome({super.key});

  @override
  State<ExpenseTrackerHome> createState() => _ExpenseTrackerHomeState();
}

class _ExpenseTrackerHomeState extends State<ExpenseTrackerHome> {
  late DateTime _month = DateTime.now();
  bool _monthview = false;
  final _service = FirestoreService();

  void _chgmonth(int o) {
    setState(() {
      _month = DateTime(_month.year, _month.month + o, 1);
    });
  }

  void _snack(String msg, [bool err = false]) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: err ? Colors.red : null),
      );

  void _sheet([Expense? expenseToEdit, Exception? e]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (c) => AddExpenseScreen(
        expenseToEdit: expenseToEdit,
        onSave: () => _snack(
          expenseToEdit == null
              ? (e == null
                    ? 'Expense added successfully'
                    : 'Failed to add expense')
              : (e == null
                    ? 'Expense updated successfully'
                    : 'Failed to update expense'),
          e != null,
        ),
      ),
    );
  }

  void delete(String id) => showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: Text('Delete Expense'),
      content: Text('Are you sure you want to delete this expense?'),
      actions: [
        TextButton(
          onPressed: () async {
            await _service.deleteExpense(id);
            Navigator.pop(c);
            _snack('Expense deleted successfully');
          },
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _monthview = !_monthview;
              });
            },
            icon: Icon(
              _monthview ? Icons.calendar_month : Icons.calendar_today,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_monthview)
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _chgmonth(-1);
                        });
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][_month.month - 1]} ${_month.year}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _chgmonth(1);
                        });
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: StreamBuilder(
              stream: _monthview
                  ? _service.getTotalExpenseByMonth(_month)
                  : _service.getTotalExpense(),
              builder: (c, s) => Card(
                elevation: 8,
                color: Colors.blueAccent,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        _monthview ? 'Monthly Expense' : 'Total Expense',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${(s.data ?? 0.0).toStringAsFixed(2)} ₹',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Expense>>(
              stream: _monthview
                  ? _service.getExpensesByMonth(_month)
                  : _service.getAllExpenses(),
              builder: (c, s) {
                if (s.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final exp = s.data ?? [];
                if (exp.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 70, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No expenses found'),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: exp.length,
                  itemBuilder: (c, i) => ExpenseCard(
                    expense: exp[i],
                    onDelete: () => delete(exp[i].id),
                    onEdit: () => _sheet(exp[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _sheet(),
        child: Icon(Icons.add),
      ),
    );
  }
}
