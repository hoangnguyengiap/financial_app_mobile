// lib/dashboard_screen.dart
import 'package:final_project/BudgetPlanningScreen_HaiAnh/BudgetPlanning.dart';
import 'package:final_project/DoanAnhVu/DTO/TransactionHistoryDTO.dart';
import 'package:final_project/DoanAnhVu/DTO/TransactionSummary.dart';
import 'package:final_project/DoanAnhVu/services/transaction_service.dart';
import 'package:final_project/DoanAnhVu/transaction_history_screen.dart';
import 'package:final_project/QuynhAnh_screens/ExpenseBreakdownScreen.dart';
import 'package:final_project/QuynhAnh_screens/add_transaction_screen.dart';
import 'package:final_project/QuynhAnh_screens/model/ExpenseOverview.dart';
import 'package:final_project/QuynhAnh_screens/model/Summary.dart';
import 'package:final_project/QuynhAnh_screens/service/ExpenseOverview_service.dart';
import 'package:final_project/global_variable/number_format.dart';
import 'package:final_project/model/User.dart';
import 'package:final_project/screens_Giap/auth_screen.dart';
import 'package:final_project/screens_Giap/category_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project/ThemeChanging_HaiAnh/theme.dart';
import 'package:final_project/ThemeChanging_HaiAnh/current_theme.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? userId;
  String? username;

  
  int _selectedIndex = 0; // To keep track of the selected tab

  // List of screens to navigate to
  List<Widget> _widgetOptions() => [
    _DashboardContent(userId: userId),
    TransactionHistoryScreen(),
    AddTransactionScreen(),
    BudgetPlanning(),
    CategoryManagementScreen(),
  ];

  void _getUserInfo() async {
    final id = await User.getStoredUserId();
    final name = await User.getStoredUsername();
    setState(() {
      userId = id;
      username = name;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String titleName(index) {
    switch (index) {
      case 0:
        return "Dashboard";
      case 1:
        return "Transaction\nHistory";
      case 2:
        return "Add Transaction";
      case 3:
        return "Budget Planning";
      case 4:
        return "Categories";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    if(userId == null || username == null){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: currentTheme.background_color,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: currentTheme.background_color,
        elevation: 0,
        title: (_selectedIndex == 0)? 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleName(_selectedIndex),
              style: TextStyle(
                color: currentTheme.main_text_color,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("Welcome back, $username!", style: TextStyle(fontSize: 18, color: currentTheme.sub_text_color),)
          ],
        )
        :Text(
          titleName(_selectedIndex),
          style: TextStyle(
            color: currentTheme.main_text_color,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              (currentTheme == lightTheme) ? Icons.light_mode : Icons.dark_mode,
              color: currentTheme.sub_text_color,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                currentTheme = (currentTheme == lightTheme)
                    ? darkTheme
                    : lightTheme;
              });
            },
          ),
          _buildSettingsMenu(),
          const SizedBox(width: 8),
        ],
      ),
      body: _widgetOptions()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: currentTheme.background_color,
        selectedItemColor: currentTheme.main_button_color,
        unselectedItemColor: currentTheme.sub_text_color,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all labels are shown
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: currentTheme.main_button_color,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 30),
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Category',
          ),
        ],
      ),
    );
  }

  /// Settings Menu
  Widget _buildSettingsMenu() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings, color: currentTheme.sub_text_color, size: 28),
      onSelected: (value) async {
        if (value == 'signout') {
          // You might want to navigate to a login screen or perform actual sign-out logic here
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear(); // This removes all keys and values
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => AuthScreen()),
            (Route<dynamic> route) => false,
          ); // This will pop the current route (DashboardScreen)
        }
      },
      color: currentTheme.sub_button_color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'signout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "Sign Out",
                style: TextStyle(color: currentTheme.main_text_color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashboardContent extends StatefulWidget {
  int? userId;

  _DashboardContent({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() => __DashboardContentState();
}

// Extract your original dashboard body into a separate widget
class __DashboardContentState extends State<_DashboardContent> {

  final ExpenseOverview_service eos = ExpenseOverview_service();
  final TransactionService rht = TransactionService();
  List<ExpenseOverview> leo = [];
  List<TransactionSummary> ltht = [];

  Summary? sm;
  
  final DateFormat dateFormat = DateFormat("MM/yyyy");
  final DateFormat datetran = DateFormat("dd/MM/yyyy");
  DateTime currentDate = DateTime.now();
  DateTime pickedDate = DateTime.now();


  void _showMonthPicker() async {
    final selected = await showMonthPicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(currentDate.year - 1,currentDate.month),
      lastDate: currentDate,
    );
    if (selected != null) {
      final summary = await eos.showSummary(widget.userId!, selected.month, selected.year);
      final expense = await eos.showtop3ExOverview(widget.userId!, selected.month, selected.year);
      setState(() {
        pickedDate = selected;
        sm = summary;
        leo = expense;
      });
    }
  } 

  void ViewSummary() async {
    final result = await eos.showSummary(widget.userId!, pickedDate.month, pickedDate.year);

    setState(() {
        sm = result;
    });
  }
  


  void _viewRecentTransactionHistory() async {
    final results = await rht.getUserRecentHistory(widget.userId!);
    setState(() {
      ltht = results;
    });

  }


  void CallExpenseOverview () async {
    final result = await eos.showtop3ExOverview(widget.userId!, pickedDate.month, pickedDate.year);
    setState(() {
      leo = result;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CallExpenseOverview();
    _viewRecentTransactionHistory();
    ViewSummary();
  }  

  @override
  Widget build(BuildContext context) {
    if (sm == null) {
      return Center(child: CircularProgressIndicator());
    }

    // context is available here
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildBalanceCard(),
            const SizedBox(height: 20),
            _buildExpenseOverviewCard(context), // Pass context here
            const SizedBox(height: 15),
            _buildRecentTransactions(context), // Pass context here
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  /// Balance Card
  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: currentTheme.elevated_background_color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: _showMonthPicker,
            icon: const Icon(Icons.calendar_today, color: Colors.white, size: 25,),
            label: Text(
              dateFormat.format(pickedDate),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          const SizedBox(height: 10,),
          Text(
            'Balance',
            style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            '${numFormat.format(sm!.income - sm!.expense)} VND',
            style: TextStyle(
              color: (sm!.income - sm!.expense < 0)? Colors.redAccent: Colors.greenAccent,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBalanceDetail('Income', numFormat.format(sm!.income), const Color.fromARGB(255, 0, 255, 4)),
              _buildBalanceDetail('Expense', numFormat.format(sm!.expense), const Color.fromARGB(255, 228, 34, 99))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetail(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        Text(
          "$value VND",
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Expense Overview
  Widget _buildExpenseOverviewCard(BuildContext context) {
    // Accept context
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: currentTheme.sub_button_color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expense Overview',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: currentTheme.main_text_color,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpenseBreakdownScreen(income: sm!.income, expense: sm!.expense, currentDate: pickedDate,),
                    ),
                  );
                },
                child: Text(
                  'View',
                  style: TextStyle(color: currentTheme.sub_text_color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          (leo.isEmpty)?
          Text("No Expense In This Month", style: TextStyle( color: currentTheme.sub_text_color, fontSize: 16),)
          :Row(
            children: [
              // Placeholder for the chart/graph
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8), // Add some rounding
                ),
                child: Center(
                  child: Icon(
                    Icons.bar_chart,
                    size: 40,
                    color: Colors.grey[600],
                  ), // Example icon
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    ...leo.map((lt) => (_buildExpenseItem(lt.name, numFormat.format(double.parse(lt.amount)))))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(String name, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 7, color: Colors.blue),
              const SizedBox(width: 5),
              Text(name, style: TextStyle(color: currentTheme.main_text_color)),
            ],
          ),
          Text(
            '$amount đ',
            style: TextStyle(
              color: currentTheme.main_text_color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Recent Transactions
  Widget _buildRecentTransactions(BuildContext context) {
    // Accept context
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: currentTheme.sub_button_color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: currentTheme.main_text_color,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TransactionHistoryScreen(showAppBar: true),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(color: currentTheme.sub_text_color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...ltht.map((rt) => (
            _buildTransactionItem(rt.categoryName, datetran.format(rt.transactionDate), numFormat.format(rt.amount), (rt.categoryType == "Income")? true:false)
          )),
          if(ltht.isEmpty) Container(
            alignment: AlignmentDirectional.center,
            child: Text("No Recent Transaction", style: TextStyle(color: currentTheme.sub_text_color, fontSize: 16))
          
          )
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String date,
    String amount,
    bool isIncome,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long,
            size: 20,
            color: isIncome ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: currentTheme.main_text_color),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: currentTheme.sub_text_color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "$amount đ",
            style: TextStyle(
              color: isIncome ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
