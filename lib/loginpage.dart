import 'package:flutter/material.dart';
import 'homepage.dart'; // ajuste le nom si ton fichier s'appelle home_page.dart

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color kBg = Color(0xFFD2B48C);     // beige clair
  static const Color kPad = Color(0xFFB88646);    // beige + foncé pour le pavé
  static const double keyW = 72;                  // largeur d'une touche
  static const double keyH = 56;                  // hauteur d'une touche

  String _input = "";

  String get _masked => List.filled(_input.length, '•').join(); // ••••••

  void _onNumberPressed(String number) {
    setState(() {
      if (_input.length < 6) _input += number;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
      }
    });
  }

  void _onValidate() {
    if (_input.length == 6 && _input == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Code incorrect")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // Logo
            const Text(
              "NEWO",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
            ),
            const Text(
              "DIGITAL ADVISOR",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),

            // Label
            const Padding(
              padding: EdgeInsets.only(left: 40, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Code de connexion",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Zone code + bouton →
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue, width: 1.6),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(1, 2),
                          )
                        ],
                      ),
                      child: Text(
                        _masked, // ✅ masqué en ••••••
                        style: const TextStyle(fontSize: 22, letterSpacing: 6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: _onValidate,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Pavé numérique
            SizedBox(
              height: 330, // 🔹 hauteur fixe (ajuste selon ton design Figma)
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: kPad,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // 🔹 commence en haut
                  children: [
                    _buildKeypadRow(["1", "2", "3"]),
                    _buildKeypadRow(["4", "5", "6"]),
                    _buildKeypadRow(["7", "8", "9"]),
                    // ✅ dernière rangée : "Code oublié ?" | 0 centré | backspace
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Code oublié ?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(child: _buildNumberButton("0")),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: _onBackspace,
                              onLongPress: () => setState(() => _input = ""),
                              borderRadius: BorderRadius.circular(22),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.blue, width: 2),
                                ),
                                child: const Icon(Icons.arrow_back, color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Lien inscription
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Pas encore inscrit? "),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "Crée ton compte",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ----------------- Widgets touches -----------------

  Widget _buildKeypadRow(List<String> numbers) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: numbers.map(_buildNumberButton).toList(),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return SizedBox(
      width: keyW,
      height: keyH,
      child: Material(
        color: Colors.grey.shade300,
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _onNumberPressed(number),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
