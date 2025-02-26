import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/custom_app_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Perform login logic here
      final email = _emailController.text;
      final password = _passwordController.text;
      print('Email: $email, Password: $password');
    }
    Navigator.pushNamed(context, '/username');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Create your account \nand start exploring Mozaik",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'hello@youremail.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Your Password',
                        suffixIcon: Icon(FluentIcons.eye_24_regular),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Material(
                      color: AppColors.primary, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                        side: const BorderSide(
                          // Border color
                          width: 1, // Border width
                        ),
                      ),
                      child: InkWell(
                        onTap: _register,
                        splashFactory:
                            NoSplash.splashFactory, // Remove splash effect
                        child: const SizedBox(
                          width: double.infinity,
                          height: 56, // Adjust height as needed
                          child: Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white, // Text color
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey, // Line color
                            thickness: 1, // Line thickness
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey, // Line color
                            thickness: 1, // Line thickness
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Material(
                      color: AppColors.background, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                        side: const BorderSide(
                          // Border color
                          width: 0.5, // Border width
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Handle button press
                        },
                        splashFactory:
                            NoSplash.splashFactory, // Remove splash effect
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(13),
                              child: Icon(
                                FontAwesomeIcons.google,
                                size: 21,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 48, // Adjust height as needed
                              child: Center(
                                child: Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.battleshipGray
                                      // Text color
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Material(
                      color: AppColors.background, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                        side: const BorderSide(
                          // Border color
                          width: 0.5, // Border width
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Handle button press
                        },
                        splashFactory:
                            NoSplash.splashFactory, // Remove splash effect
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.facebook,
                                color: Colors.grey.shade700,
                                size: 24,
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: 48, // Adjust height as needed
                              child: Center(
                                child: Text(
                                  'Continue with Facebook',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color:
                                          AppColors.battleshipGray // Text color
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.battleshipGray,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    splashFactory:
                        NoSplash.splashFactory, // Remove splash effect
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2, vertical: 8), // Add padding if needed
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.start, // Align text to the start
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
