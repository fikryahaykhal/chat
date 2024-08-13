import 'package:chat/pages/chat_page.dart';
import 'package:chat/services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [chatPage(context), signOut(context)],
        ),
      ),
    );
  }
}

Widget chatPage(context) {
  return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const ChatPage()));
      },
      child: const Text('Go To Chat Page'));
}

Widget signOut(context) {
  return ElevatedButton(
      onPressed: () {
        final auth = Provider.of<Auth>(context, listen: false);
        auth.signOut();
      },
      child: const Text('Sign Out'));
}
