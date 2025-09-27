import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart'; 

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _filter = "Tout"; // Filtre par défaut
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique complet"),
        backgroundColor: const Color(0xFFD2B48C),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 242, 233, 216),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<CreditProvider>(
          builder: (context, creditProvider, child) {
            // Filtrage par type
            var history = _filter == "Tout"
                ? creditProvider.history
                : creditProvider.history
                    .where((t) => _filter == "Crédit"
                        ? t["positive"] == true
                        : t["positive"] == false)
                    .toList();

            // Filtrage par recherche
            if (_searchText.isNotEmpty) {
              history = history
                  .where((t) => t["title"]
                      .toString()
                      .toLowerCase()
                      .contains(_searchText.toLowerCase()))
                  .toList();
            }

            if (history.isEmpty) {
              return const Center(
                child: Text(
                  "Aucune transaction pour le moment",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return Column(
              children: [
                // Champ de recherche
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Rechercher une transaction...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),

                // Dropdown de filtre
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Filtre : "),
                    DropdownButton<String>(
                      value: _filter,
                      items: const [
                        DropdownMenuItem(value: "Tout", child: Text("Tout")),
                        DropdownMenuItem(value: "Crédit", child: Text("Crédit")),
                        DropdownMenuItem(value: "Débit", child: Text("Débit")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _filter = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Liste filtrée
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final t = history[index];
                      return Card(
                        color: const Color.fromARGB(255, 238, 217, 191),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
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
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
