import 'package:capstone/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class device_page extends StatefulWidget {
  final User currentUser;
  const device_page({super.key, required this.currentUser});

  @override
  State<device_page> createState() => _device_pageState();
}

class _device_pageState extends State<device_page> {
  String _device_id = '';
  String _device_password = '';
  String db_Psw = '';
  bool _isPasswordVisible = false;

  final _formkey = GlobalKey<FormState>();

  late FirebaseAuth auth;
  late FirebaseDatabase db;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    db = FirebaseDatabase.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Page'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Device Id',
                    hintText: 'Device Id',
                    prefixIcon: Icon(Icons.device_hub),
                  ),
                  onSaved: (deger) {
                    _device_id = deger!;
                  },
                  validator: (deger) {
                    if (deger!.length != 5) {
                      return ' Id must have 5 characters.';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 50),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Device Password',
                    hintText: 'Device Password',
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
                    _device_password = deger!;
                  },
                  validator: (deger) {
                    if (deger!.length != 4) {
                      return 'Password must have 4 characters.';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 50),
                CupertinoButton(
                    child: Text('GO'),
                    color: Color.fromARGB(255, 9, 43, 103),
                    minSize: 50,
                    onPressed: () {
                      bool _validate = _formkey.currentState!.validate();
                      if (_validate) {
                        _formkey.currentState!.save();
                        getDbPsw();
                        _formkey.currentState!.reset();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Id or password is wrong.'),
                          ),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void gotoDevice() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connected to the device $_device_id'),
      ),
    );
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => home_page.withDeviceId(
            currentUser: widget.currentUser,
            deviceId: _device_id,
          ),
        ),
        (route) => false);
  }

  void checkDevice() {
    if (db.ref().child('devices').child(_device_id) != null) {
      if (_device_password == db_Psw) {
        gotoDevice();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Id or password is wrong.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Id or password is wrong.'),
        ),
      );
    }
  }

  Future<void> getDbPsw() async {
    DatabaseReference dbPsw =
        await db.ref('devices/$_device_id/devicePassword');
    dbPsw.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      db_Psw = data.toString();
      checkDevice();
    });
  }
}
