import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/creditprovider.dart';
import 'models/offer.dart';

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
          "RecommendationPage",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "NEWO\nDIGITAL ADVISOR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Message dynamique
            Consumer<CreditProvider>(
              builder: (context, creditProvider, child) {
                final lowMinutes = creditProvider.minutes < 100;
                final lowInternet = creditProvider.internet < 1;
                final lowSms = creditProvider.sms < 50;

                String message;
                if (!lowMinutes && !lowInternet && !lowSms) {
                  message =
                      "Toutes vos ressources sont suffisantes ! Voici vos niveaux actuels:";
                } else {
                  message =
                      "Ma mission est de te recommander les offres qui répondent le mieux à tes besoins:";
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

            // 🔹 Stats dynamiques
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

            // 🔹 Offres recommandées dynamiques avec possibilité d'achat
            Consumer<CreditProvider>(
              builder: (context, creditProvider, child) {
                final lowMinutes = creditProvider.minutes < 100;
                final lowInternet = creditProvider.internet < 1;
                final lowSms = creditProvider.sms < 50;

                List<Offer> recommendedOffers = [];

                if (lowMinutes && !lowInternet && !lowSms) {
                  recommendedOffers = [
                    ...appelOffers["Jour"]!,
                    ...appelOffers["Semaine"]!,
                    ...appelOffers["Mois"]!,
                  ];
                } else if (lowInternet && !lowMinutes && !lowSms) {
                  recommendedOffers = [
                    ...internetOffers["Jour"]!,
                    ...internetOffers["Semaine"]!,
                    ...internetOffers["Mois"]!,
                  ];
                } else if ((lowMinutes && lowInternet) ||
                    (lowMinutes && lowInternet && lowSms) ||
                    (lowInternet && lowSms) ||
                    (lowMinutes && lowSms)) {
                  recommendedOffers = [
                    ...illimaxOffers["Jour"]!,
                    ...illimaxOffers["Semaine"]!,
                    ...illimaxOffers["Mois"]!,
                  ];
                }

                if (recommendedOffers.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: recommendedOffers
                      .map((offer) => _buildOfferCard(offer, context))
                      .toList(),
                );
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
                  onPressed: () {},
                  child: const Text("Voir tous les offres →",
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== Widgets réutilisables =====
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

  // 🔹 Build offer avec possibilité d'achat
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

                    // 🔹 Ajouter les ressources selon le type d'offre
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
