import 'package:flutter/material.dart';
import 'dart:math';


class CreditProvider extends ChangeNotifier {
  int _credit = 0;
  bool _isHidden = true;

  // Ressources
  int _minutes = 130;       // Minutes d'appel initiales
  double _internet = 0.13;  // Volume Internet en Go
  int _sms = 200;           // SMS disponibles

  // Historique sous forme de liste de Map
  final List<Map<String, dynamic>> _history = [];

  // ====== Constructeur pour initialiser l'historique par défaut ======
  CreditProvider() {
    _history.addAll([
      {
        "title": "Mame Tabara",
        "subtitle": "Transfert effectué",
        "amount": "+50 000 CFA",
        "positive": true,
        "date": "25/09/2025 à 20:00",
      },
      {
        "title": "Ibrahima NDIAYE",
        "subtitle": "Achat de pass illimax",
        "amount": "-3000 CFA",
        "positive": false,
        "date": "20/09/2025 à 20:00",
      },
      {
        "title": "Father ❤️",
        "subtitle": "Achat de pass illimax",
        "amount": "-3000 CFA",
        "positive": false,
        "date": "20/09/2025 à 20:00",
      },
      {
        "title": "Recharge de crédit",
        "subtitle": "Recharge effectuée",
        "amount": "+3000 CFA",
        "positive": true,
        "date": "17/09/2025 à 20:00",
      },
      {
        "title": "Recharge de crédit",
        "subtitle": "Recharge effectuée",
        "amount": "+5000 CFA",
        "positive": true,
        "date": "17/09/2025 à 20:00",
      },
      {
        "title": "Recharge de crédit",
        "subtitle": "Recharge effectuée",
        "amount": "+5000 CFA",
        "positive": true,
        "date": "17/09/2025 à 20:00",
      },
    ]);
  }

  // ====== Getters ======
  int get credit => _credit;
  bool get isHidden => _isHidden;
  int get minutes => _minutes;
  double get internet => _internet;
  int get sms => _sms;
  List<Map<String, dynamic>> get history => _history;

  // ====== Crédit ======
  void addCredit(int amount) {
    _credit += amount;

    _history.insert(0, {
      "title": "Recharge de crédit",
      "subtitle": "Recharge effectuée",
      "amount": "+$amount CFA",
      "positive": true,
      "date": DateTime.now().toString().substring(0, 16),
    });

    notifyListeners();
  }

  void spendCredit(int amount, String description) {
    if (_credit >= amount) {
      _credit -= amount;

      _history.insert(0, {
        "title": description,
        "subtitle": "Débit du solde",
        "amount": "-$amount CFA",
        "positive": false,
        "date": DateTime.now().toString().substring(0, 16),
      });

      notifyListeners();
    }
  }

  // ====== Ressources ======
  void addMinutes(int amount) {
    _minutes += amount;
    _history.insert(0, {
      "title": "Ajout de minutes",
      "subtitle": "Minutes ajoutées",
      "amount": "+$amount MIN",
      "positive": true,
      "date": DateTime.now().toString().substring(0, 16),
    });
    notifyListeners();
  }

  void addInternet(double amount) {
    _internet += amount;
    _history.insert(0, {
      "title": "Ajout de volume Internet",
      "subtitle": "Internet ajouté",
      "amount": "+${amount.toStringAsFixed(2)} GO",
      "positive": true,
      "date": DateTime.now().toString().substring(0, 16),
    });
    notifyListeners();
  }

  void addSMS(int amount) {
    _sms += amount;
    _history.insert(0, {
      "title": "Ajout de SMS",
      "subtitle": "SMS ajoutés",
      "amount": "+$amount SMS",
      "positive": true,
      "date": DateTime.now().toString().substring(0, 16),
    });
    notifyListeners();
  }

  

  void useResources({int minutes = 0, double internet = 0.0, int sms = 0}) {
    if (_minutes >= minutes) _minutes -= minutes;
    if (_internet >= internet) _internet -= internet;
    if (_sms >= sms) _sms -= sms;

    _history.insert(0, {
      "title": "Consommation",
      "subtitle": "Ressources utilisées",
      "amount":
          "-${minutes} MIN, -${internet.toStringAsFixed(2)} GO, -${sms} SMS",
      "positive": false,
      "date": DateTime.now().toString().substring(0, 16),
    });

    notifyListeners();
  }

  // ====== Simulation aléatoire ======
  void simulateConsumption() {
    final random = Random();

    int usedMinutes = random.nextInt(16);       // entre 0 et 15 min
    double usedInternet = random.nextDouble() * 1.2; // entre 0.0 et 1.2 Go
    int usedSms = random.nextInt(20);            // entre 0 et 20 SMS

    // Vérifie qu’on a bien assez de ressources avant de consommer
    if (_minutes > 0 || _internet > 0 || _sms > 0) {
      useResources(
        minutes: usedMinutes <= _minutes ? usedMinutes : _minutes,
        internet: usedInternet <= _internet ? usedInternet : _internet,
        sms: usedSms <= _sms ? usedSms : _sms,
      );
    }
  }

  // ====== Visibilité ======
  void toggleVisibility() {
    _isHidden = !_isHidden;
    notifyListeners();
  }
}
