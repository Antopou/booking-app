import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';
import 'package:booking_app/models/user_profile_models.dart';

class PersonalInformationScreen extends StatefulWidget {
  final UserProfile? userProfile;
  const PersonalInformationScreen({super.key, this.userProfile, required VoidCallback onProfileUpdated});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "${widget.userProfile?.firstName ?? ''} ${widget.userProfile?.lastName ?? ''}");
    _emailController = TextEditingController(text: widget.userProfile?.email ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("Personal Info", style: AppTextStyles.subHeading),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGrey),
        actions: [
          TextButton(onPressed: () {}, child: const Text("Save", style: TextStyle(color: AppColors.brandGold, fontWeight: FontWeight.bold)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildInput("Full Name", _nameController),
            const SizedBox(height: 20),
            _buildInput("Email Address", _emailController),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.brandGold)),
          ),
        ),
      ],
    );
  }
}