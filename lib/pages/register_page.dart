import 'package:chat/services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

String? errorMessage = '';

//textfield controller

final emailController = TextEditingController();
final passwordController = TextEditingController();

class _RegisterPageState extends State<RegisterPage> {
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Register',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              const Expanded(child: SizedBox()),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Email'),
                controller: emailController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Password'),
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.blueGrey[800]),
                    foregroundColor: WidgetStateProperty.all(Colors.white)),
                onPressed: signUp,
                child: const Text('Sign Up'),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
