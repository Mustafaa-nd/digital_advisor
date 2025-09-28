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
import 'models/themeprovider.dart'; 


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
    _timer?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("766247834",
                style: TextStyle(fontSize: 16, color: Colors.white)),
            Text("Mouhamadou Moustapha NDIAYE",
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          // 👇 Bouton switch clair/sombre
          IconButton(
            icon: Icon(
              themeProvider.isDark ? Icons.wb_sunny : Icons.nights_stay,
              color: Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              if (value == 'logout') {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);

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
                backgroundColor: Theme.of(context).primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RecommendationPage()),
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
                    MaterialPageRoute(
                        builder: (context) => const RechargePage()),
                  );
                }),
                _buildAction(Icons.send, "Transfert", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TransfertPage()),
                  );
                }),
                _buildAction(Icons.token, "Offres", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OffresPage()),
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Crédit principal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Image.asset(
                'assets/logo.png',
                height: 50,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Consumer<CreditProvider>(
            builder: (context, creditProvider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    creditProvider.isHidden
                        ? "******"
                        : "${creditProvider.credit} CFA",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  IconButton(
                    icon: Icon(
                      creditProvider.isHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Theme.of(context).primaryColor,
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
          Consumer<CreditProvider>(
            builder: (context, creditProvider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildResource(
                    "Minutes d'appel",
                    "${creditProvider.minutes} MIN",
                    creditProvider.minutes < 100
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                  ),
                  _buildResource(
                    "Volume Internet",
                    "${creditProvider.internet.toStringAsFixed(2)} GO",
                    creditProvider.internet < 1
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                  ),
                  _buildResource(
                    "SMS",
                    "${creditProvider.sms} SMS",
                    creditProvider.sms < 50
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResource(String title, String value, Color color) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
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
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(icon,
                size: 30, color: Theme.of(context).iconTheme.color),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Consumer<CreditProvider>(
      builder: (context, creditProvider, child) {
        final history = creditProvider.history;
        final recentHistory =
            history.length > 4 ? history.sublist(0, 4) : history;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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
                  Text(
                    "Historique",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HistoryPage()),
                      );
                    },
                    child: const Text(
                      "Voir tout",
                      style: TextStyle(color: Color.fromARGB(255, 24, 176, 138)),
                    ),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                height: 300,
                child: recentHistory.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text("Aucune transaction pour le moment",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: recentHistory.length,
                        itemBuilder: (context, index) {
                          final t = recentHistory[index];
                          return Card(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              title: Text(
                                t["title"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color),
                              ),
                              subtitle: Text(t["subtitle"],
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color)),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    t["amount"],
                                    style: TextStyle(
                                        color: t["positive"]
                                            ? const Color.fromARGB(255, 73, 192, 148)
                                            : Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    t["date"],
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color),
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
