import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mozaik/app_colors.dart';
import 'package:mozaik/components/custom_app_bar.dart';
import 'package:mozaik/components/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/home');
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Log in to Mozaik",
                  style: Theme.of(context).textTheme.headlineMedium,
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
                      CustomTextField(controller: _emailController, hintText: 'hello@youremail.com',validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },),
        
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
                      CustomTextField(controller: _passwordController, hintText: 'Your Password',obscureText: true,validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },),
        
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {},
                        splashFactory: NoSplash.splashFactory,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                          child: Text(
                            "Forgot Password?",
                            style: Theme.of(context).textTheme.labelMedium,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Material(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: _login,
                          splashFactory: NoSplash.splashFactory,
                          child:  SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: Center(
                              child: Text(
                                'Login',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                       Row(
        
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'OR',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Material(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
        
                        ),
                        child: InkWell(
                          onTap: () {},
                          splashFactory: NoSplash.splashFactory,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(13),
                                child: Icon(
                                  FontAwesomeIcons.google,
                                  size: 21,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                               SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: Center(
                                  child: Text(
                                    'Continue with Google',
                                    style: Theme.of(context).textTheme.labelLarge,
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
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
        
                        ),
                        child: InkWell(
                          onTap: () {},
                          splashFactory: NoSplash.splashFactory,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  Icons.facebook,
                                  color: Theme.of(context).primaryColor,
                                  size: 24,
                                ),
                              ),
                               SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: Center(
                                  child: Text(
                                    'Continue with Facebook',
                                    style: Theme.of(context).textTheme.labelLarge,
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
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.battleshipGray,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      splashFactory: NoSplash.splashFactory,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
