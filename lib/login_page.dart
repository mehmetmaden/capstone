import 'package:capstone/forget_password.dart';
import 'package:capstone/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                  height: 100,
                ),
                Container(
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-Mail',
                      hintText: 'E-mail',
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                    ),
                    onSaved: (deger) {
                      _email = deger!;
                    },
                    validator: (deger) {
                      if (!EmailValidator.validate(deger!)) {
                        return 'Mail adress is not valid!';
                      } else
                        return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 75,
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
                  height: 75,
                ),
                CupertinoButton(
                  child: Text('Login'),
                  color: Color.fromARGB(255, 9, 43, 103),
                  minSize: 50,
                  onPressed: () {
                    bool _validate = _formkey.currentState!.validate();
                    if (_validate) {
                      _formkey.currentState!.save();
                      loginUsersEmailAndPassword();

                      _formkey.currentState!.reset();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('E-Mail or Password wrong!'),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 75,
                ),
                CupertinoButton(
                  child: Text('Forget Password'),
                  color: Color.fromARGB(255, 9, 43, 103),
                  minSize: 50,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => forget_password(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginUsersEmailAndPassword() async {
    try {
      var _userCredential = await auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login with "$_email" adresses. '),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => landing_page(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('E-Mail or Password is wrong!'),
        ),
      );
    }
  }
}
