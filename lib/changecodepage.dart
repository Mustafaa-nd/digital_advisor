import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeCodePage extends StatefulWidget {
  const ChangeCodePage({super.key});

  @override
  State<ChangeCodePage> createState() => _ChangeCodePageState();
}

class _ChangeCodePageState extends State<ChangeCodePage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _newCodeController = TextEditingController();
  final _confirmCodeController = TextEditingController();

  static const Color kBg = Color(0xFFD2B48C);   // beige clair
  static const Color kCard = Color(0xFFB88646); // beige foncé
  static const Color kPrimary = Colors.blue;

  // 🔹 Numéro fixe
  final String fixedPhoneNumber = "766247834";

  // @override
  // void initState() {
  //   super.initState();
  //   _phoneController.text = fixedPhoneNumber; // Remplissage automatique
  // }

  void _changeCode() async {
    if (_formKey.currentState!.validate()) {

      // 🔹 Vérification que le numéro correspond
      if (_phoneController.text.trim() != fixedPhoneNumber) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Numéro invalide")),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userPin', _newCodeController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Code changé avec succès pour ${_phoneController.text.trim()} ✅",
          ),
        ),
      );

      _newCodeController.clear();
      _confirmCodeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text("Réinitialiser le code"),
        backgroundColor: kCard,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset('assets/logo.png', height: 80),
              const SizedBox(height: 16),
              const Icon(Icons.lock_reset, size: 90, color: Colors.white70),
              const SizedBox(height: 20),
              const Text(
                "Réinitialisation du code",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kCard.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _phoneController,
                        label: "Numéro de téléphone",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        enabled: true, // ⚡ utilisateur ne peut pas modifier
                        validator: (v) => v == null || v.isEmpty
                            ? "Numéro manquant"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _newCodeController,
                        label: "Nouveau code",
                        icon: Icons.lock,
                        isPassword: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Entre un nouveau code";
                          }
                          if (v.length < 6) return "Min. 6 caractères";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _confirmCodeController,
                        label: "Confirmer le code",
                        icon: Icons.lock_outline,
                        isPassword: true,
                        validator: (v) =>
                            v != _newCodeController.text
                                ? "Les codes ne correspondent pas"
                                : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _changeCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 6,
                          ),
                          child: const Text(
                            "Valider",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool enabled = true, // champ activable/désactivable
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      enabled: enabled,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}
