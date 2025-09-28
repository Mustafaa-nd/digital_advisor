import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart';
import 'models/themeprovider.dart';

class TransfertPage extends StatefulWidget {
  const TransfertPage({super.key});

  @override
  State<TransfertPage> createState() => _TransfertPageState();
}

class _TransfertPageState extends State<TransfertPage> {
  String _amount = "";
  String _recipient = "";

  int? get _amountValue =>
      _amount.isEmpty ? null : int.tryParse(_amount);

  bool get _isValidAmount {
    final value = _amountValue;
    if (value == null) return false;
    return value >= 100 && value <= 500000;
  }

  bool get _isValidRecipient => _recipient.length == 9;

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

  void _onTransfer() {
    if (!_isValidAmount || !_isValidRecipient) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Montant ou numéro bénéficiaire invalide")),
      );
      return;
    }

    // Déduit le crédit et ajoute à l'historique
    Provider.of<CreditProvider>(context, listen: false)
        .spendCredit(_amountValue!, "Transfert vers $_recipient");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Transfert de $_amount CFA vers $_recipient effectué ✅")),
    );

    setState(() {
      _amount = "";
      _recipient = "";
    });
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
          icon: Icon(Icons.arrow_back, color: theme.appBarTheme.foregroundColor ?? Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Transfert Optimus",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.appBarTheme.foregroundColor ?? Colors.black),
        ),
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
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Transfert d'argent",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
                  color: theme.brightness == Brightness.dark ? Colors.black45 : Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mouhamadou Moustapha NDIAYE",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.textTheme.bodyLarge?.color)),
                const SizedBox(height: 5),
                Text("766247834",
                    style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Numéro bénéficiaire",
                    border: const OutlineInputBorder(),
                    labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  onChanged: (val) => setState(() => _recipient = val),
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                ),
                const SizedBox(height: 10),
                Text(
                  _amount.isEmpty ? "Entrez le montant" : "$_amount CFA",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _isValidAmount ? theme.textTheme.bodyLarge?.color : Colors.red),
                ),
                const Divider(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bouton Transférer
          ElevatedButton(
            onPressed: (_isValidAmount && _isValidRecipient) ? _onTransfer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              disabledBackgroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Transférer", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),

          const Spacer(),

          // Pavé numérique
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildKeypadRow(["1", "2", "3"]),
                _buildKeypadRow(["4", "5", "6"]),
                _buildKeypadRow(["7", "8", "9"]),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(child: _buildNumberButton("0")),
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
                              border: Border.all(color:Colors.white, width: 2),
                            ),
                            child: Icon(Icons.arrow_back, color:Colors.white),
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

  Widget _buildKeypadRow(List<String> numbers) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: numbers.map(_buildNumberButton).toList(),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return SizedBox(
      width: 72,
      height: 56,
      child: Material(
        // color: Colors.grey.shade300,
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
                color: Colors.black, 
              ),
            ),
          ),
        ),
      ),
    );
  }

}
