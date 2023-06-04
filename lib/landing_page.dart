import 'package:capstone/home_page.dart';
import 'package:capstone/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class landing_page extends StatefulWidget {
  const landing_page({super.key});

  @override
  State<landing_page> createState() => _landing_pageState();
}

class _landing_pageState extends State<landing_page> {
  late FirebaseAuth auth;

  User? _user;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return login_page();
    } else {
      return home_page(currentUser: _user!);
    }
  }

  Future<void> _checkUser() async {
    _user = await auth.currentUser;
    setState(() {});
  }
}
