import 'package:capstone/main_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class register_page extends StatefulWidget {
  const register_page({super.key});

  @override
  State<register_page> createState() => _register_pageState();
}

class _register_pageState extends State<register_page> {
  late FirebaseAuth auth;

  String _email = '', _password = '';
  final _formkey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                    initialValue: 'mmmaden.19@gmail.com',
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
                    initialValue: '123456',
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
                  child: Text('Register'),
                  color: Color.fromARGB(255, 9, 43, 103),
                  minSize: 50,
                  onPressed: () {
                    bool _validate = _formkey.currentState!.validate();
                    if (_validate) {
                      _formkey.currentState!.save();
                      createUserEmailAndPassword(_email, _password);

                      String result = 'E-Mail : $_email\nPassword: $_password';

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => main_page(),
                        ),
                      );
                      _formkey.currentState!.reset();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('E-Mail or Password is wrong!'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createUserEmailAndPassword(String emailDeger, passwordDeger) async {
    var _userCredential = await auth.createUserWithEmailAndPassword(
        email: emailDeger, password: passwordDeger);
  }
}
