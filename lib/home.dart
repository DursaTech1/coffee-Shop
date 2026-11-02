import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffe Card'),
        backgroundColor: Colors.brown[700],
        centerTitle: true,
             ),
      body: Column(
        children: [
          Container(
            color: Colors.brown[200],
            padding: EdgeInsets.all(20),
            child: const Text('How I like mu coffee....'),
          ),
          Container(
            color: Colors.brown[100],
            padding: EdgeInsets.all(20),
            child: const Text('Coffee preferences.'),
          ),

        ],),
      );
    
  }
}