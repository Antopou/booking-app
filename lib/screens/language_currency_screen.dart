import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';

class LanguageCurrencyScreen extends StatefulWidget {
  const LanguageCurrencyScreen({super.key});

  @override
  State<LanguageCurrencyScreen> createState() => _LanguageCurrencyScreenState();
}

class _LanguageCurrencyScreenState extends State<LanguageCurrencyScreen> {
  String _selectedLang = "English (US)";
  String _selectedCurrency = "USD";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("Preferences", style: AppTextStyles.subHeading),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGrey),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Language", style: AppTextStyles.caption),
          const SizedBox(height: 12),
          _buildOption("English (US)", _selectedLang == "English (US)", () => setState(() => _selectedLang = "English (US)")),
          _buildOption("French", _selectedLang == "French", () => setState(() => _selectedLang = "French")),
          const SizedBox(height: 32),
          Text("Currency", style: AppTextStyles.caption),
          const SizedBox(height: 12),
          _buildOption("USD (\$)", _selectedCurrency == "USD", () => setState(() => _selectedCurrency = "USD")),
          _buildOption("EUR (€)", _selectedCurrency == "EUR", () => setState(() => _selectedCurrency = "EUR")),
        ],
      ),
    );
  }

  Widget _buildOption(String title, bool isSelected, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppTextStyles.body),
      trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.brandGold) : null,
    );
  }
}