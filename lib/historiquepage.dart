import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart';
import 'models/themeprovider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _filter = "Tout";
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;

    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final appBarColor =
        Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final hintColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique"),
        backgroundColor: appBarColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny : Icons.nights_stay,
              color: Colors.white,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<CreditProvider>(
          builder: (context, creditProvider, child) {
            // Toujours partir de la liste complète
            List<Map<String, dynamic>> filteredHistory = creditProvider.history;

            // Filtrage par type
            if (_filter != "Tout") {
              filteredHistory = filteredHistory.where((t) =>
                  _filter == "Crédit" ? t["positive"] == true : t["positive"] == false).toList();
            }

            // Filtrage par recherche
            if (_searchText.isNotEmpty) {
              filteredHistory = filteredHistory
                  .where((t) =>
                      t["title"].toString().toLowerCase().contains(_searchText.toLowerCase()))
                  .toList();
            }

            return Column(
              children: [
                // Champ de recherche
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Rechercher une transaction...",
                    hintStyle: TextStyle(color: hintColor),
                    prefixIcon: Icon(Icons.search, color: hintColor),
                    filled: true,
                    fillColor: cardColor.withOpacity(0.1),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: textColor.withOpacity(0.4), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(height: 10),

                // Dropdown de filtre
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Filtre : ", style: TextStyle(color: textColor)),
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

                // Liste filtrée ou message "Aucune transaction"
                Expanded(
                  child: filteredHistory.isEmpty
                      ? Center(
                          child: Text(
                            "Aucune correspondance trouvée",
                            style: TextStyle(fontSize: 16, color: textColor),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredHistory.length,
                          itemBuilder: (context, index) {
                            final t = filteredHistory[index];
                            return Card(
                              color: cardColor,
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
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: textColor),
                                ),
                                subtitle: Text(
                                  t["subtitle"],
                                  style:
                                      TextStyle(color: textColor.withOpacity(0.7)),
                                ),
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
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: textColor.withOpacity(0.7)),
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
