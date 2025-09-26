import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart'; 
import 'recommendationpage.dart';
import 'rechargepage.dart';
import 'transfertpage.dart';
import 'offrespage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6CC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2B48C),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("766247834", style: TextStyle(fontSize: 16, color: Colors.black)),
            Text("Mouhamadou Moustapha NDIAYE",
                style: TextStyle(fontSize: 12, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Carte principale (crédit)
            _buildCreditCard(),

            const SizedBox(height: 16),

            // Bouton Recommandation
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecommendationPage()),
                );
              },
              child: const Text("Mon conseiller",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),

            const SizedBox(height: 20),

            // Icônes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAction(Icons.download, "Recharge", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RechargePage()),
                  );
                }),
                _buildAction(Icons.send, "Transfert", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TransfertPage()),
                  );
                }),
                _buildAction(Icons.token, "Offres", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OffresPage()),
                  );
                }),
              ],
            ),

            const SizedBox(height: 20),

            // Historique dynamique
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  // ====== Widgets ======

  Widget _buildCreditCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Crédit principal", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("NEWO",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 10),

        // Crédit dynamique + œil
        Consumer<CreditProvider>(
          builder: (context, creditProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  creditProvider.isHidden
                      ? "******"
                      : "${creditProvider.credit} CFA",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    creditProvider.isHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    creditProvider.toggleVisibility();
                  },
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 20),

        // Ressources dynamiques
        Consumer<CreditProvider>(
          builder: (context, creditProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("Minutes d'appel", style: TextStyle(fontSize: 12)),
                    Text(
                      "${creditProvider.minutes} MIN",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: creditProvider.minutes < 100 ? Colors.red : Colors.blue),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Volume Internet", style: TextStyle(fontSize: 12)),
                    Text(
                      "${creditProvider.internet.toStringAsFixed(2)} GO",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: creditProvider.internet < 1 ? Colors.red : Colors.blue),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("SMS", style: TextStyle(fontSize: 12)),
                    Text(
                      "${creditProvider.sms} SMS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: creditProvider.sms < 50 ? Colors.red : Colors.blue),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    ),
  );
}


  Widget _buildAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Icon(icon, size: 30, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Consumer<CreditProvider>(
      builder: (context, creditProvider, child) {
        final history = creditProvider.history;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Historique", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Voir tout", style: TextStyle(color: Colors.blue)),
                ],
              ),
              const Divider(),

              // Si pas d’historique
              if (history.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Aucune transaction pour le moment"),
                  ),
                ),

              // Sinon on affiche la liste
              for (var t in history)
                Column(
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(t["title"],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(t["subtitle"]),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            t["amount"],
                            style: TextStyle(
                                color: t["positive"] ? Colors.green : Colors.red),
                          ),
                          Text(t["date"], style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
