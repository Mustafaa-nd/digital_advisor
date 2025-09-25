import 'package:flutter/material.dart';
import 'models/offer.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart';


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
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6CC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2B48C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "NEWO Digital Advisor",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Onglets en chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(_tabs.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(
                      _tabs[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    selected: _selectedIndex == index,
                    selectedColor: const Color(0xFFD2B48C), // beige foncé
                    backgroundColor: const Color(0xFFF5E6CC), // beige clair
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: _selectedIndex == index
                            ? Colors.blue
                            : Colors.brown.shade200,
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: data.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry.key,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...entry.value.map((offer) => _buildOfferCard(offer, context)).toList(),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildOfferCard(Offer offer, BuildContext context) {
    final creditProvider = Provider.of<CreditProvider>(context, listen: false);
    final priceValue = int.tryParse(offer.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

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
                child: const Text("Annuler")
              ),
              ElevatedButton(
                onPressed: () {
                  if (creditProvider.credit >= priceValue) {
                    // Débiter le crédit
                    creditProvider.spendCredit(priceValue, "Achat ${offer.title}");

                    // 🔹 Ajouter les ressources selon le type d'offre
                    if (offer.title.contains("min")) {
                      // Extrait le nombre de minutes
                      final minutes = int.tryParse(RegExp(r'\d+').firstMatch(offer.title)?.group(0) ?? '0') ?? 0;
                      creditProvider.addMinutes(minutes);
                    }
                    if (offer.title.contains("Go") || offer.title.contains("Mo")) {
                      // Extrait le volume Internet
                      final match = RegExp(r'(\d+(?:,\d+)?)\s*(Go|Mo)').firstMatch(offer.title);
                      if (match != null) {
                        double value = double.parse(match.group(1)!.replaceAll(',', '.'));
                        if (match.group(2) == 'Mo') value = value / 1024; // Convertir Mo → Go
                        creditProvider.addInternet(value);
                      }
                    }
                    if (offer.title.contains("sms") || offer.title.contains("SMS")) {
                      // Extrait le nombre de SMS
                      final sms = int.tryParse(RegExp(r'\d+\s*(?:sms|SMS)').firstMatch(offer.title)?.group(0)?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0;
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
                child: const Text("Confirmer")
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(offer.subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            Text(offer.price,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
          ],
        ),
      ),
    );
  }

}
