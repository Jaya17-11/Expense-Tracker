import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

// ------------------------------- DASHBOARD -------------------------------

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> expenses = [];
  int totalAmount = 0;

  void updateTotal() {
    totalAmount = expenses.fold(
      0,
      (sum, item) => sum + (item["amount"] as int), // ✅ FIXED
    );
    setState(() {});
  }

  void addExpense(Map<String, dynamic> item) {
    setState(() {
      expenses.add(item);
      updateTotal();
    });
  }

  void deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
      updateTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff0f4ff),

      appBar: AppBar(
        title: Text("Expense Tracker"),
        backgroundColor: Colors.deepPurple,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddExpenseScreen()),
          );

          if (newExpense != null) {
            addExpense(newExpense);
          }
        },
      ),

      body: Column(
        children: [
          // Total Balance Card
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Spent",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                Text(
                  "₹ $totalAmount",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Expense List
          Expanded(
            child: expenses.isEmpty
                ? Center(
                    child: Text(
                      "No expenses added yet.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, i) {
                      final e = expenses[i];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Icon(Icons.currency_rupee, color: Colors.white),
                          ),
                          title: Text(e["title"]),
                          subtitle: Text(e["date"]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "₹ ${e["amount"]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  deleteExpense(i);
                                },
                              )
                            ],
                          ),
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

// ------------------------------- ADD EXPENSE -------------------------------

class AddExpenseScreen extends StatefulWidget {
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(
                labelText: "Expense Title",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                if (title.text.isEmpty || amount.text.isEmpty) return;

                Navigator.pop(context, {
                  "title": title.text,
                  "amount": int.parse(amount.text),
                  "date": "Today",
                });
              },
              child: Text(
                "Save Expense",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
