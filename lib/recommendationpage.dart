import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart';
import 'models/offer.dart';
import 'offrespage.dart';


class RecommendationPage extends StatelessWidget {
  const RecommendationPage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Mon conseiller",  
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 20),


            // Message dynamique
            Consumer<CreditProvider>(
              builder: (context, creditProvider, child) {
                final lowMinutes = creditProvider.minutes < 100;
                final lowInternet = creditProvider.internet < 1;
                final lowSms = creditProvider.sms < 30;

                String message;
                if (!lowMinutes && !lowInternet && !lowSms) {
                  message =
                      "Tes ressources sont suffisantes, profites en ! Voici tes niveaux actuels:";
                } else {
                  message =
                      "Tes ressources sont insuffisantes. Voici tes niveaux actuels:";
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Salut Mouhamadou, bienvenu chez ton conseiller ",
                        style: const TextStyle(fontSize: 14),
                        children: const [
                          TextSpan(
                            text: "NeWo.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // Stats dynamiques
            Consumer<CreditProvider>(
              builder: (context, creditProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(
                      Icons.phone,
                      "${creditProvider.minutes} MIN",
                      creditProvider.minutes < 100 ? Colors.red : Colors.black,
                    ),
                    _buildStat(
                      Icons.wifi,
                      "${creditProvider.internet.toStringAsFixed(2)} GO",
                      creditProvider.internet < 1 ? Colors.redAccent : Colors.black,
                    ),
                    _buildStat(
                      Icons.message,
                      "${creditProvider.sms} SMS",
                      creditProvider.sms < 50 ? Colors.red : Colors.black,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // Offres recommandées dynamiques avec possibilité d'achat
            Consumer<CreditProvider>(
              builder: (context, creditProvider, child) {
                final lowMinutes = creditProvider.minutes < 100;
                final lowInternet = creditProvider.internet < 1;
                final lowSms = creditProvider.sms < 50;

                // Offres finales à afficher
                List<Widget> offerWidgets = [];

                if (!lowMinutes && !lowInternet && !lowSms) {
                  // Toutes ressources suffisantes : 2 offres par type
                  final appelRecs = appelOffers.values.expand((list) => list).take(2);
                  final internetRecs = internetOffers.values.expand((list) => list).take(2);
                  final illimaxRecs = illimaxOffers.values.expand((list) => list).take(2);

                  if (appelRecs.isNotEmpty) {
                    offerWidgets.add(_buildCategoryTitle("Appel"));
                    offerWidgets.addAll(appelRecs.map((offer) => _buildOfferCard(offer, context)));
                  }
                  if (internetRecs.isNotEmpty) {
                    offerWidgets.add(_buildCategoryTitle("Internet"));
                    offerWidgets.addAll(internetRecs.map((offer) => _buildOfferCard(offer, context)));
                  }
                  if (illimaxRecs.isNotEmpty) {
                    offerWidgets.add(_buildCategoryTitle("Illimax"));
                    offerWidgets.addAll(illimaxRecs.map((offer) => _buildOfferCard(offer, context)));
                  }
                } else if (lowMinutes && !lowInternet && !lowSms) {
                  offerWidgets.add(_buildCategoryTitle("Appel"));
                  offerWidgets.addAll([
                    ...appelOffers["Jour"]!,
                    ...appelOffers["Semaine"]!,
                    ...appelOffers["Mois"]!,
                  ].map((offer) => _buildOfferCard(offer, context)));
                } else if (lowInternet && !lowMinutes && !lowSms) {
                  offerWidgets.add(_buildCategoryTitle("Internet"));
                  offerWidgets.addAll([
                    ...internetOffers["Jour"]!,
                    ...internetOffers["Semaine"]!,
                    ...internetOffers["Mois"]!,
                  ].map((offer) => _buildOfferCard(offer, context)));
                } else if ((lowMinutes && lowInternet) ||
                    (lowMinutes && lowInternet && lowSms) ||
                    (lowInternet && lowSms) ||
                    (lowMinutes && lowSms)) {
                  offerWidgets.add(_buildCategoryTitle("Illimax"));
                  offerWidgets.addAll([
                    ...illimaxOffers["Jour"]!,
                    ...illimaxOffers["Semaine"]!,
                    ...illimaxOffers["Mois"]!,
                  ].map((offer) => _buildOfferCard(offer, context)));
                }

                if (offerWidgets.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(children: offerWidgets);
              },
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Et si tu préfères, ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OffresPage()),
                    );
                  },
                  child: const Text(
                    "Voir tous les offres →",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== Widgets réutilisables =====

  Widget _buildCategoryTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 205, 170, 124), width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 250, 231, 205).withOpacity(0.1), // léger fond beige
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0), // texte beige
        ),
      ),
    );
  }



  static Widget _buildStat(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 5, offset: const Offset(2, 2))
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // Build offer avec possibilité d'achat
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
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (creditProvider.credit >= priceValue) {
                    creditProvider.spendCredit(priceValue, "Achat ${offer.title}");

                    //  Ajouter les ressources selon le type d'offre
                    if (offer.title.contains("min")) {
                      final minutes = int.tryParse(RegExp(r'\d+').firstMatch(offer.title)?.group(0) ?? '0') ?? 0;
                      creditProvider.addMinutes(minutes);
                    }
                    if (offer.title.contains("Go") || offer.title.contains("Mo")) {
                      final match = RegExp(r'(\d+(?:,\d+)?)\s*(Go|Mo)').firstMatch(offer.title);
                      if (match != null) {
                        double value = double.parse(match.group(1)!.replaceAll(',', '.'));
                        if (match.group(2) == 'Mo') value = value / 1024;
                        creditProvider.addInternet(value);
                      }
                    }
                    if (offer.title.contains("sms") || offer.title.contains("SMS")) {
                      final sms = int.tryParse(RegExp(r'\d+\s*(?:sms|SMS)').firstMatch(offer.title)?.group(0)?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0;
                      creditProvider.addSMS(sms);
                    }

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${offer.title} acheté avec succès ✅")),
                    );
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Crédit insuffisant pour cet achat ⚠️")),
                    );
                  }
                },
                child: const Text("Confirmer"),
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
            BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: const Offset(2, 2))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(offer.subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            Text(offer.price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
