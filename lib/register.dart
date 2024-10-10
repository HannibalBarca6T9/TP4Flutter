import 'package:flutter/material.dart';
import 'package:tp4/button.dart';
import 'package:tp4/textfield.dart';
import 'package:tp4/database.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _message = '';
  final TextEditingController _usernameController = TextEditingController();
  static final DatabaseHelper instance = DatabaseHelper.instance;

  Future<void> _register() async {
    final result = await instance.registerUser(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _message = result ?? 'Error during registration';
    });
    print(_message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
          child: Column(
            children: [
              reusableTextField(
                'Name',
                Icons.person,
                false,
                _usernameController,
              ),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                'Email',
                Icons.alternate_email,
                false,
                _emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              reusableTextField(
                  'Password', Icons.lock_outline, true, _passwordController),
              const SizedBox(
                height: 15,
              ),
              customButton(context, 'register', _register),
            ],
          ),
        ),
      ),
    );
  }
}
