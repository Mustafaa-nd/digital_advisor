import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart'; 
import 'recommendationpage.dart';
import 'rechargepage.dart';
import 'transfertpage.dart';
import 'offrespage.dart';
import 'historiquepage.dart';
import 'dart:async';
import 'loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Simulation toutes les 3 minutes
    _timer = Timer.periodic(const Duration(minutes: 3), (timer) {
      final provider = context.read<CreditProvider>();
      provider.simulateConsumption(); 
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Nettoyage du timer quand la page est détruite
    super.dispose();
  }

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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) async {
              if (value == 'logout') {
                // 🔹 Déconnexion
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);

                // 🔹 Retour à LoginPage
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Déconnexion'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCreditCard(),
            const SizedBox(height: 16),
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
          children: [
            const Text(
              "Crédit principal",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'assets/logo.png', 
              height: 50,        
            ),
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

      // Limite à 4 dernières transactions
      final recentHistory = history.length > 4 ? history.sublist(0, 4) : history;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Historique",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryPage()),
                    );
                  },
                  child: const Text(
                    "Voir tout",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const Divider(),

            // Liste scrollable
            SizedBox(
              height: 300,
              child: recentHistory.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Aucune transaction pour le moment"),
                      ),
                    )
                  : ListView.builder(
                      itemCount: recentHistory.length,
                      itemBuilder: (context, index) {
                        final t = recentHistory[index];
                        return Card(
                          color: const Color.fromARGB(255, 243, 224, 200),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Text(
                              t["title"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(t["subtitle"]),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  t["amount"],
                                  style: TextStyle(
                                      color: t["positive"]
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t["date"],
                                  style: const TextStyle(fontSize: 10),
                                ),
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
    },
  );
}
}
