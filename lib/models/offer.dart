class Offer {
  final String title;
  final String subtitle;
  final String price;

  Offer({
    required this.title,
    required this.subtitle,
    required this.price,
  });
}


// 🔹 Offres Appel
final appelOffers = {
  "Jour": [
    Offer(title: "Appel 30 min", subtitle: "Durée de validité 24 h", price: "100F CFA"),
    Offer(title: "Appel 80 min", subtitle: "Durée de validité 24 h", price: "250F CFA"),
    Offer(title: "Appel 140 min", subtitle: "Durée de validité 24 h", price: "500F CFA"),
  ],
  "Semaine": [
    Offer(title: "Appel 400 min", subtitle: "Durée de validité 7 jours", price: "1000F CFA"),
    Offer(title: "Appel 500 min", subtitle: "Durée de validité 7 jours", price: "1300F CFA"),
  ],
  "Mois": [
    Offer(title: "Appel 800 min", subtitle: "Durée de validité 30 jours", price: "2000F CFA"),
    Offer(title: "Appel 1000 min", subtitle: "Durée de validité 30 jours", price: "3000F CFA"),
    Offer(title: "Appel 1300 min", subtitle: "Durée de validité 30 jours", price: "5000F CFA"),
    Offer(title: "Appel 2200 min", subtitle: "Durée de validité 30 jours", price: "9000F CFA"),
  ],
};

// 🔹 Offres Internet
final internetOffers = {
  "Jour": [
    Offer(title: "Pass 300 Mo", subtitle: "Durée de validité 24 h", price: "250F CFA"),
    Offer(title: "Pass 800 Mo", subtitle: "Durée de validité 24 h", price: "600F CFA"),
    Offer(title: "Pass 1 Go", subtitle: "Durée de validité 24 h", price: "1000F CFA"),
  ],
  "Semaine": [
    Offer(title: "Pass 900 Mo", subtitle: "Durée de validité 7 jours", price: "1000F CFA"),
    Offer(title: "Pass 1,5 Go", subtitle: "Durée de validité 7 jours", price: "1300F CFA"),
  ],
  "Mois": [
    Offer(title: "Pass 4 Go", subtitle: "Durée de validité 30 jours", price: "2000F CFA"),
    Offer(title: "Pass 9 Go", subtitle: "Durée de validité 30 jours", price: "5000F CFA"),
    Offer(title: "Pass 15 Go", subtitle: "Durée de validité 30 jours", price: "10 000F CFA"),
  ],
};

// 🔹 Offres Illimax
final illimaxOffers = {
  "Jour": [
    Offer(title: "Illimax 60 min • 20 sms • 100 Mo", subtitle: "Durée de validité 24 h", price: "300F CFA"),
    Offer(title: "Illimax 60 min • 20 sms • 2 Go", subtitle: "Durée de validité 24 h", price: "500F CFA"),
    Offer(title: "Illimax 100 min • 50 sms • 3 Go", subtitle: "Durée de validité 24 h", price: "1000F CFA"),
  ],
  "Semaine": [
    Offer(title: "Illimax 400 min • 100 sms • 2 Go", subtitle: "Durée de validité 7 jours", price: "1300F CFA"),
    Offer(title: "Illimax 500 min • 200 sms • 3 Go", subtitle: "Durée de validité 7 jours", price: "1700F CFA"),
    Offer(title: "Illimax 700 min • 200 sms • 5 Go", subtitle: "Durée de validité 7 jours", price: "2100F CFA"),
  ],
  "Mois": [
    Offer(title: "Illimax 400 min • 100 sms • 4 Go", subtitle: "Durée de validité 30 jours", price: "2300F CFA"),
    Offer(title: "Illimax 500 min • 150 sms • 5 Go", subtitle: "Durée de validité 30 jours", price: "3000F CFA"),
    Offer(title: "Illimax 700 min • 200 sms • 7 Go", subtitle: "Durée de validité 30 jours", price: "5000F CFA"),
    Offer(title: "Illimax 1000 min • 300 sms • 10 Go", subtitle: "Durée de validité 30 jours", price: "8000F CFA"),
    Offer(title: "Illimax 1200 min • 400 sms • 15 Go", subtitle: "Durée de validité 30 jours", price: "10 000F CFA"),
  ],
};
