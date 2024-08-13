import 'package:chat/pages/register_page.dart';
import 'package:chat/services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';

//TextField controller

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                onPressed: () {
                  signIn();
                },
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 32,
              ),
              RichText(
                text: TextSpan(
                  text: 'Not a member? ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Register Now',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                          },
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
