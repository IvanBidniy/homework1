void main() {
  List<double> transactions = [100.0, -50.0, 200.0, -30.0, -20.0, 150.0, -70.0];

  List<double> incomes = transactions.where((t) => t > 0).toList();
  List<double> expenses = transactions.where((t) => t < 0).toList();

  double totalIncome = incomes.fold(0, (sum, t) => sum + t);
  double totalExpense = expenses.fold(0, (sum, t) => sum + t);

  print("Надходження: $incomes");
  print("Витрати: $expenses");
  print("Загальна сума надходжень: $totalIncome");
  print("Загальна сума витрат: $totalExpense");
}
