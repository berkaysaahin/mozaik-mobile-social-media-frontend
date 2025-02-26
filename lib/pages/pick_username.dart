import 'package:flutter/material.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import "package:flutter/cupertino.dart";

class PickUsernamePage extends StatefulWidget {
  const PickUsernamePage({super.key});

  @override
  State<PickUsernamePage> createState() => _PickUsernamePageState();
}

class _PickUsernamePageState extends State<PickUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  void _saveName() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      print('Name: $name');

      // Save the name to your backend or local storage
      // Example: Firebase, SharedPreferences, etc.

      // Navigate to the home screen or next screen
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leftIcon: const Icon(CupertinoIcons.arrow_left),
        onLeftIconTap: (context) {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'One last step before you dive in,',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'How shall we call you in Mozaik?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  if (value.length < 3) {
                    return 'Name must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Material(
                color: AppColors.primary, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  side: const BorderSide(
                    // Border color
                    width: 0.5, // Border width
                  ),
                ),
                child: InkWell(
                  onTap: _saveName,
                  splashFactory: NoSplash.splashFactory, // Remove splash effect
                  child: const SizedBox(
                    width: double.infinity,
                    height: 48, // Adjust height as needed
                    child: Center(
                      child: Text(
                        'Step In!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          // Text color
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
