import 'package:flutter/material.dart';
import 'models/offer.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart';
import 'models/themeprovider.dart';

class OffresPage extends StatefulWidget {
  const OffresPage({super.key});

  @override
  State<OffresPage> createState() => _OffresPageState();
}

class _OffresPageState extends State<OffresPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<String> _tabs = ["Appel", "Internet", "Illimax"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: Text(
          "NEWO Digital Advisor",
          style: TextStyle(
              color: theme.appBarTheme.foregroundColor ?? Colors.black,
              fontWeight: FontWeight.bold),
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
          // Onglets en chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(_tabs.length, (index) {
                final isSelected = _selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(
                      _tabs[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: theme.primaryColor,
                    backgroundColor: theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? theme.colorScheme.secondary
                            : theme.dividerColor,
                      ),
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedIndex = index;
                        _tabController.animateTo(index);
                      });
                    },
                  ),
                );
              }),
            ),
          ),

          // Contenu des tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                OffersList(data: appelOffers),
                OffersList(data: internetOffers),
                OffersList(data: illimaxOffers),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget réutilisable pour afficher une catégorie d’offres
class OffersList extends StatelessWidget {
  final Map<String, List<Offer>> data;

  const OffersList({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: data.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.key,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                )),
            const SizedBox(height: 8),
            ...entry.value
                .map((offer) => _buildOfferCard(offer, context, theme))
                .toList(),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildOfferCard(Offer offer, BuildContext context, ThemeData theme) {
    final creditProvider = Provider.of<CreditProvider>(context, listen: false);
    final priceValue =
        int.tryParse(offer.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Confirmer l'achat"),
            content: Text("Voulez-vous acheter ${offer.title} pour ${offer.price}?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler")),
              ElevatedButton(
                  onPressed: () {
                    if (creditProvider.credit >= priceValue) {
                      creditProvider.spendCredit(priceValue, "Achat ${offer.title}");

                      if (offer.title.contains("min")) {
                        final minutes = int.tryParse(
                                RegExp(r'\d+')
                                    .firstMatch(offer.title)
                                    ?.group(0) ??
                                    '0') ??
                            0;
                        creditProvider.addMinutes(minutes);
                      }
                      if (offer.title.contains("Go") || offer.title.contains("Mo")) {
                        final match =
                            RegExp(r'(\d+(?:,\d+)?)\s*(Go|Mo)')
                                .firstMatch(offer.title);
                        if (match != null) {
                          double value =
                              double.parse(match.group(1)!.replaceAll(',', '.'));
                          if (match.group(2) == 'Mo') value = value / 1024;
                          creditProvider.addInternet(value);
                        }
                      }
                      if (offer.title.contains("sms") ||
                          offer.title.contains("SMS")) {
                        final sms = int.tryParse(
                                RegExp(r'\d+\s*(?:sms|SMS)')
                                    .firstMatch(offer.title)
                                    ?.group(0)
                                    ?.replaceAll(RegExp(r'[^0-9]'), '') ??
                                    '0') ??
                            0;
                        creditProvider.addSMS(sms);
                      }

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${offer.title} acheté avec succès ✅"),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Crédit insuffisant pour cet achat ⚠️"),
                        ),
                      );
                    }
                  },
                  child: const Text("Confirmer")),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color)),
                Text(offer.subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color)),
              ],
            ),
            Text(offer.price,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 70, 197, 167))),
          ],
        ),
      ),
    );
  }
}
