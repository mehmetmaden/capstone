import 'package:capstone/login_page.dart';
import 'package:capstone/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class account_page extends StatefulWidget {
  final User currentUser;
  const account_page({super.key, required this.currentUser});

  @override
  State<account_page> createState() => _account_pageState();
}

class _account_pageState extends State<account_page> {
  String _email = '', _password = '';
  final _formkey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  late FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    User? user = widget.currentUser;
    _email = user.email!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text('E-Mail : $_email'),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    onSaved: (deger) {
                      _password = deger!;
                    },
                    validator: (deger) {
                      if (deger!.length < 6) {
                        return 'Password must contain at least 6 characters.';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                CupertinoButton(
                    child: Text('Update Password'),
                    color: Color.fromARGB(255, 9, 43, 103),
                    minSize: 50,
                    onPressed: () {
                      bool _validate = _formkey.currentState!.validate();
                      if (_validate) {
                        _formkey.currentState!.save();
                        user.updatePassword(_password);
                        auth.signOut();
                        _formkey.currentState!.reset();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Your password is updated.'),
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => login_page(),
                        ),
                      );
                    }),
                SizedBox(
                  height: 100,
                ),
                CupertinoButton(
                    child: Text('Delete Account'),
                    color: Color.fromARGB(255, 9, 43, 103),
                    minSize: 50,
                    onPressed: () {
                      user.delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Your account is deleted.'),
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => main_page(),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
