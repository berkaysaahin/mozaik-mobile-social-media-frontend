import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'One last step before you dive in,',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'How shall we call you in Mozaik?',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 36),
                TextFormField(
                  controller: _nameController,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    hintText: 'Your cool new username',
                    hintStyle: Theme.of(context).textTheme.labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
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
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      width: 0.1,
                    ),
                  ),
                  child: InkWell(
                    onTap: _saveName,
                    splashFactory: NoSplash.splashFactory,
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Center(
                        child: Text(
                          'Step In!',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
      ),
    );
  }
}
