import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart';
import 'models/themeprovider.dart';

class RechargePage extends StatefulWidget {
  const RechargePage({super.key});

  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  String _amount = "";

  int? get _amountValue =>
      _amount.isEmpty ? null : int.tryParse(_amount); // conversion en int

  bool get _isValidAmount {
    final value = _amountValue;
    if (value == null) return false;
    return value >= 50 && value <= 500000;
  }

  void _onNumberPressed(String number) {
    setState(() {
      if (_amount.length < 6) _amount += number;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amount.isNotEmpty) _amount = _amount.substring(0, _amount.length - 1);
    });
  }

  void _onBuy() {
    if (!_isValidAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Montant invalide. Minimum 50 CFA, maximum 500 000 CFA")),
      );
      return;
    }

    // Met à jour le crédit via Provider
    Provider.of<CreditProvider>(context, listen: false).addCredit(_amountValue!);

    // Message confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Recharge de $_amount CFA effectuée ✅")),
    );

    setState(() => _amount = ""); // reset champ montant
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: theme.appBarTheme.foregroundColor ?? Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("NEWO Digital Advisor",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.appBarTheme.foregroundColor ?? Colors.black)),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDark ? Icons.wb_sunny : Icons.nights_stay,
              color: Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Badge "Achat de crédit"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Achat de crédit",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.appBarTheme.foregroundColor ?? Colors.white)),
          ),
          const SizedBox(height: 20),

          // Carte info utilisateur
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: theme.brightness == Brightness.dark
                        ? Colors.black45
                        : Colors.grey.shade300,
                    blurRadius: 5,
                    offset: const Offset(2, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mouhamadou Moustapha NDIAYE",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.textTheme.bodyLarge?.color)),
                const SizedBox(height: 5),
                Text("766247834",
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                const SizedBox(height: 20),
                Text(
                  _amount.isEmpty ? "Entrez le montant" : "$_amount CFA",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _isValidAmount
                          ? theme.textTheme.bodyLarge?.color
                          : Colors.red),
                ),
                Divider(color: theme.dividerColor),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bouton Acheter
          ElevatedButton(
            onPressed: _isValidAmount ? _onBuy : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isValidAmount
                  ? theme.primaryColor
                  : theme.disabledColor,
              disabledBackgroundColor: theme.disabledColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("Acheter",
                style: TextStyle(
                    fontSize: 18,
                    color: theme.appBarTheme.foregroundColor ?? Colors.white)),
          ),

          const Spacer(),

          // Pavé numérique
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildKeypadRow(["1", "2", "3"], theme),
                _buildKeypadRow(["4", "5", "6"], theme),
                _buildKeypadRow(["7", "8", "9"], theme),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(child: _buildNumberButton("0", theme)),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: _onBackspace,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white, width: 2),
                            ),
                            child: Icon(Icons.arrow_back,
                                color:Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> numbers, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: numbers.map((n) => _buildNumberButton(n, theme)).toList(),
      ),
    );
  }

  Widget _buildNumberButton(String number, ThemeData theme) {
    return SizedBox(
      width: 72,
      height: 56,
      child: Material(
        color: theme.cardColor,
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _onNumberPressed(number),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color),
            ),
          ),
        ),
      ),
    );
  }
}
