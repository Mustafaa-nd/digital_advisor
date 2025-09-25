class Transaction {
  final String title;
  final String subtitle;
  final String amount;
  final String date;
  final bool positive;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.positive,
  });
}



List<Transaction> demoTransactions = [
  Transaction(
    title: "Mame Tabara",
    subtitle: "Transfert d'argent",
    amount: "+50 000 CFA",
    date: "25/09/2025 à 20:00",
    positive: true,
  ),
  Transaction(
    title: "Ibrahima NDIAYE",
    subtitle: "Achat de pass illimax",
    amount: "-3000 CFA",
    date: "20/09/2025 à 20:00",
    positive: false,
  ),
  Transaction(
    title: "Father ❤️",
    subtitle: "Achat de pass illimax",
    amount: "-3000 CFA",
    date: "20/09/2025 à 20:00",
    positive: false,
  ),
  Transaction(
    title: "My self",
    subtitle: "Recharge de credit",
    amount: "-3000 CFA",
    date: "17/09/2025 à 20:00",
    positive: false,
  ),
  Transaction(
    title: "My self",
    subtitle: "Recharge de credit",
    amount: "-5000 CFA",
    date: "17/09/2025 à 20:00",
    positive: false,
  ),
  Transaction(
    title: "My self",
    subtitle: "Recharge de credit",
    amount: "-5000 CFA",
    date: "17/09/2025 à 20:00",
    positive: false,
  ),
];
