class Summary {
  double income;
  double expense;

  Summary ({ required this.expense, required this.income});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      income: json['totalIncome'],
      expense: json['totalExpense']
    );
  }
}