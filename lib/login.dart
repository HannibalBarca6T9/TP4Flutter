import 'package:flutter/material.dart';
import 'package:tp4/button.dart';
import 'package:tp4/database.dart';
import 'package:tp4/home.dart';
import 'package:tp4/textfield.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static final DatabaseHelper instance = DatabaseHelper.instance;
  String _message = '';

  Future<void> _login() async {
    final result = await instance.loginUser(
      _emailController.text,
      _passwordController.text,
    );
    setState(() {
      _message = result ?? 'Error during login';
    });
    print(_message);
    if (result == 'Login successful') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        _message = result ?? 'Error during login';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text("Login")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: [
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
                customButton(
                  context,
                  'Log in',
                  _login,
                ),
                const SizedBox(
                  height: 5,
                ),
                signUpOption(context),
              ],
            ),
          ),
        ));
  }
}
