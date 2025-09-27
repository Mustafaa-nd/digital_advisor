import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'changecodepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/themeprovider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _input = "";
  static const double keyW = 72;
  static const double keyH = 56;

  String get _masked => List.filled(_input.length, '•').join();

  void _onNumberPressed(String number) {
    setState(() {
      if (_input.length < 6) _input += number;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_input.isNotEmpty) _input = _input.substring(0, _input.length - 1);
    });
  }

  void _onValidate() async {
    if (_input.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Code incomplet")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedPin = prefs.getString('userPin') ?? "123456";

    if (_input == storedPin) {
      await prefs.setBool('isLoggedIn', true);
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final padColor = Theme.of(context).cardColor;
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text("Connexion"),
        centerTitle: true,
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),

            // Logo
            Image.asset('assets/logo.png', height: 80),

            const SizedBox(height: 32),

            // Label
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Code de connexion",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
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
                        color: padColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: primaryColor, width: 1.6),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(31, 243, 243, 243),
                            blurRadius: 3,
                            offset: Offset(1, 2),
                          )
                        ],
                      ),
                      child: Text(
                        _masked,
                        style: TextStyle(fontSize: 22, letterSpacing: 6, color: textColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: _onValidate,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: primaryColor,
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
              height: 330,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: bgColor == Colors.white
                      ? Colors.grey.shade200
                      : const Color.fromARGB(255, 106, 106, 106),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildKeypadRow(["1", "2", "3"], padColor, textColor),
                    _buildKeypadRow(["4", "5", "6"], padColor, textColor),
                    _buildKeypadRow(["7", "8", "9"], padColor, textColor),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ChangeCodePage()),
                                );
                              },
                              child: const Text(
                                "Code oublié ?",
                                style: TextStyle(color: Color.fromARGB(255, 24, 176, 138)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Center(child: _buildNumberButton("0", padColor, textColor))),
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
                                  border: Border.all(color: primaryColor, width: 2),
                                ),
                                child: Icon(Icons.arrow_back, color: primaryColor),
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

            // // Lien inscription
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text("Pas encore inscrit? "),
            //     GestureDetector(
            //       onTap: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (_) => const SignUpPage()),
            //           );
            //         },
            //       child: const Text(
            //         "Crée ton compte",
            //         style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ],
            // ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );

  }

  Widget _buildKeypadRow(List<String> numbers, Color padColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: numbers.map((n) => _buildNumberButton(n, padColor, textColor)).toList(),
      ),
    );
  }

  Widget _buildNumberButton(String number, Color padColor, Color textColor) {
    return SizedBox(
      width: keyW,
      height: keyH,
      child: Material(
        color: padColor.withOpacity(0.8),
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _onNumberPressed(number),
          child: Center(
            child: Text(
              number,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
