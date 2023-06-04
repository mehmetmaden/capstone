import 'package:capstone/login_page.dart';
import 'package:capstone/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class main_page extends StatefulWidget {
  main_page({super.key});

  @override
  State<main_page> createState() => _main_pageState();
}

class _main_pageState extends State<main_page> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Door Lock'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(height: 50),
            Container(
              child: Icon(
                Icons.lock,
                color: Colors.brown,
                size: 300,
              ),
            ),
            SizedBox(height: 50),
            CupertinoButton(
              child: Text('Login'),
              color: Color.fromARGB(255, 9, 43, 103),
              minSize: 50,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => login_page(),
                  ),
                );
              },
              alignment: Alignment(0, 1),
            ),
            SizedBox(height: 50),
            CupertinoButton(
              child: Text('Register'),
              color: Color.fromARGB(255, 9, 43, 103),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => register_page()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
