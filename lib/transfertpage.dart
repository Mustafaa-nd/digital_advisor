import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart';

class TransfertPage extends StatefulWidget {
  const TransfertPage({super.key});

  @override
  State<TransfertPage> createState() => _TransfertPageState();
}

class _TransfertPageState extends State<TransfertPage> {
  String _amount = "";
  String _recipient = "";

  int? get _amountValue =>
      _amount.isEmpty ? null : int.tryParse(_amount); // conversion en int

  bool get _isValidAmount {
    final value = _amountValue;
    if (value == null) return false;
    return value >= 100 && value <= 500000;
  }

  bool get _isValidRecipient => _recipient.length == 9; // exemple: numéro à 9 chiffres

  void _onNumberPressed(String number) {
    setState(() {
      if (_amount.length < 6) {
        _amount += number;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amount.isNotEmpty) {
        _amount = _amount.substring(0, _amount.length - 1);
      }
    });
  }

  void _onTransfer() {
    if (!_isValidAmount || !_isValidRecipient) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Montant ou numéro bénéficiaire invalide")),
      );
      return;
    }

    // Déduit le crédit et ajoute à l'historique
    Provider.of<CreditProvider>(context, listen: false)
        .spendCredit(_amountValue!, "Transfert vers $_recipient");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              "Transfert de $_amount CFA vers $_recipient effectué ✅")),
    );

    setState(() {
      _amount = "";
      _recipient = "";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6CC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2B48C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("NEWO Digital Advisor",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Badge "Transfert d'argent"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD2B48C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text("Transfert d'argent",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),

          // Carte info utilisateur
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    offset: const Offset(2, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Mouhamadou Moustapha NDIAYE",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                const Text("766247834",
                    style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Numéro bénéficiaire",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  onChanged: (val) => setState(() => _recipient = val),
                ),
                const SizedBox(height: 10),
                Text(
                  _amount.isEmpty ? "Entrez le montant" : "$_amount CFA",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _isValidAmount ? Colors.black : Colors.red),
                ),
                const Divider(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bouton Transférer
          ElevatedButton(
            onPressed:
                (_isValidAmount && _isValidRecipient) ? _onTransfer : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              disabledBackgroundColor: Colors.grey,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Transférer",
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),

          const Spacer(),

          // Pavé numérique
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFB88646),
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
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child:
                                const Icon(Icons.arrow_back, color: Colors.blue),
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
        color: Colors.grey.shade300,
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _onNumberPressed(number),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
