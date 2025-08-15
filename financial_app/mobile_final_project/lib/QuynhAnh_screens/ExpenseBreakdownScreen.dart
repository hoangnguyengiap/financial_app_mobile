import 'package:final_project/QuynhAnh_screens/model/ExpenseOverview.dart';
import 'package:final_project/QuynhAnh_screens/service/ExpenseOverview_service.dart';
import 'package:final_project/global_variable/number_format.dart';
import 'package:final_project/model/User.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:final_project/ThemeChanging_HaiAnh/current_theme.dart';
import 'package:intl/intl.dart';

class ExpenseBreakdownScreen extends StatefulWidget {
  final double income;
  final double expense;
  final DateTime currentDate;
  const ExpenseBreakdownScreen({super.key, required this.income, required this.expense, required this.currentDate});
  
  @override
  State<StatefulWidget> createState() => _ExpenseBreakdownScreenState();
}

class _ExpenseBreakdownScreenState extends State<ExpenseBreakdownScreen> {
  int? userId;
  final ExpenseOverview_service eos = ExpenseOverview_service();

  final DateFormat dateExpense = DateFormat("MM/yyyy");
  List<ExpenseOverview> expenseCategory = [];

  void showExpensebyCategory() async {
    userId = await User.getStoredUserId();
    List<ExpenseOverview> result = await eos.showExpensebyCategory(userId!, widget.currentDate.month, widget.currentDate.year);
    setState(() {
      expenseCategory = result;
      print(expenseCategory);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showExpensebyCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentTheme.background_color,
      appBar: AppBar(
        backgroundColor: currentTheme.background_color,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: currentTheme.main_text_color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Expense Breakdown",
          style: TextStyle(color: currentTheme.main_text_color, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryRow(),
            const SizedBox(height: 20),
            _buildPieChartSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSummaryCard(
          icon: Icons.arrow_upward,
          color: Colors.green,
          title: "This month",
          amount: "${numFormat.format(widget.income)} đ" ,
        ),
        _buildSummaryCard(
          icon: Icons.arrow_downward,
          color: Colors.red,
          title: "This month",
          amount: '${numFormat.format(widget.expense)} đ',
        ),
      ],
    );
  }

  Widget _buildPieChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: currentTheme.elevated_background_color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Expense by category",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: currentTheme.main_button_text_color),
              ),
              Text(dateExpense.format(widget.currentDate), 
                style: TextStyle(color: currentTheme.main_button_text_color, fontSize: 18, fontWeight: FontWeight.bold))
            ],
          ),
          const SizedBox(height: 16),
          
          (widget.expense == 0)
          ? Column(
            children: [
              SizedBox(height: 20,),
              Icon(Icons.auto_graph, color: Colors.white, size: 100,),
              SizedBox(height: 20,),
              Text("No expense this month", style: TextStyle(color: Colors.white, fontSize: 18),),
            ],
          )
          :
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: expenseCategory.map((item) {
                  final percent = (double.parse(item.amount) / widget.expense) * 100;
                  return PieChartSectionData(
                    color: item.color,
                    value: double.parse(item.amount),
                    title: "${percent.toStringAsFixed(1)}%",
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                }).toList(),
                centerSpaceRadius: 30,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: expenseCategory.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, size: 12, color: item.color),
                        const SizedBox(width: 8),
                        Text (item.name, style: TextStyle(color: currentTheme.main_text_color, fontWeight: FontWeight.bold, fontSize: 16),),
                      ],
                    ),
                    Text("${numFormat.format(double.parse(item.amount))} (${(100* double.parse(item.amount) / widget.expense).toStringAsFixed(1)}%)", style: TextStyle(color: currentTheme.main_text_color, fontSize: 16)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color color,
    required String title,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 150,
      decoration: BoxDecoration(
        color: currentTheme.sub_button_color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: currentTheme.sub_button_text_color),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
