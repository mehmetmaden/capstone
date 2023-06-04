import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class forget_password extends StatefulWidget {
  const forget_password({super.key});

  @override
  State<forget_password> createState() => _forget_passwordState();
}

class _forget_passwordState extends State<forget_password> {
  String _email = '';
  final _formkey = GlobalKey<FormState>();

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
        title: Text('Forget Password'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            alignment: Alignment.center,
            child: Column(children: [
              SizedBox(
                height: 100,
              ),
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-Mail',
                    hintText: 'E-Mail',
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                  onSaved: (deger) {
                    _email = deger!;
                  },
                  validator: (deger) {
                    if (!EmailValidator.validate(deger!)) {
                      return 'Mail adresi geçerli değil.';
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
                  child: Text('Reset Password'),
                  color: Color.fromARGB(255, 9, 43, 103),
                  minSize: 50,
                  onPressed: () {
                    bool _validate = _formkey.currentState!.validate();
                    if (_validate) {
                      _formkey.currentState!.save();
                      forgetPassword();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reset password link has been sent your $_email e-mail address.'),
                        ),
                      );
                      _formkey.currentState!.reset();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('E-Mail wrong!'),
                        ),
                      );
                    }
                  })
            ]),
          ),
        ),
      ),
    );
  }

  void forgetPassword() {
    auth.sendPasswordResetEmail(email: _email);
  }
}
