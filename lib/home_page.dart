import 'dart:async';

import 'package:capstone/account_page.dart';
import 'package:capstone/device_page.dart';
import 'package:capstone/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class home_page extends StatefulWidget {
  final User currentUser;
  final String? deviceId;
  const home_page({super.key, required this.currentUser, this.deviceId});
  const home_page.withDeviceId(
      {super.key, required this.currentUser, required this.deviceId});

  @override
  State<home_page> createState() => _home_pageState();
}

String _status = '';
String _battery = '';
String lock = '';

class _home_pageState extends State<home_page> {
  late FirebaseAuth auth;
  late FirebaseDatabase db;
  late bool c = false;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    db = FirebaseDatabase.instance;
    getLockStatus();
    getBatteryStatus();
  }

  @override
  Widget build(BuildContext context) {
    User? user = widget.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Door Lock'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                child: Text('Battery: %$_battery'),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: Text('Lock Status: $_status'),
              ),
              SizedBox(
                height: 100,
              ),
              CupertinoButton(
                child: Text('Open The Door'),
                color: Color.fromARGB(255, 9, 43, 103),
                onPressed: () {
                  openDoor();
                },
              ),
              SizedBox(
                height: 50,
              ),
              CupertinoButton(
                child: Text('Lock The Door'),
                color: Color.fromARGB(255, 9, 43, 103),
                onPressed: () {
                  lockDoor();
                },
              ),
              SizedBox(height: 50),
              CupertinoButton(
                child: Text('Open The Latch'),
                color: Color.fromARGB(255, 9, 43, 103),
                onPressed: () {
                  openLatch();
                },
              ),
              SizedBox(
                height: 260,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CupertinoButton(
                      child: Icon(Icons.account_box),
                      color: Color.fromARGB(255, 9, 43, 103),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                account_page(currentUser: user),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CupertinoButton(
                      child: Icon(Icons.devices),
                      color: Color.fromARGB(255, 9, 43, 103),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                device_page(currentUser: user),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CupertinoButton(
                      child: Icon(Icons.logout),
                      color: Color.fromARGB(255, 9, 43, 103),
                      onPressed: () {
                        logOut();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void lockDoor() async {
    setState(() async {
      if (lock != '1') {
        await db
            .ref()
            .child('devices')
            .child(widget.deviceId!)
            .child('lock')
            .set('1');
        await getLockStatus();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Door is already locked.'),
            action: SnackBarAction(
              label: 'X',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
  }

  void openDoor() async {
    setState(
      () async {
        if (lock != '0') {
          await db
              .ref()
              .child('devices')
              .child(widget.deviceId!)
              .child('lock')
              .set('0');
          await getLockStatus();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Door is already open.'),
              action: SnackBarAction(
                label: 'X',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
    );
  }

  void openLatch() async {
    await db
        .ref()
        .child('devices')
        .child(widget.deviceId!)
        .child('lock')
        .set('2');

    await Future.delayed(Duration(seconds: 1));

    await db
        .ref()
        .child('devices')
        .child(widget.deviceId!)
        .child('lock')
        .set('0');
    await getLockStatus();
  }

  void setStatus() async {
    setState(() {
      if (lock == '1') {
        _status = 'Door is locked';
        c = false;
      } else if (lock == '0') {
        _status = 'Door is open';
        c = false;
      } else if (lock == '2') {
        if (!c) {
          c = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Door is opened.'),
              action: SnackBarAction(
                label: 'X',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
        _status = 'Door is open';
      }
    });
  }

  Future<void> getLockStatus() async {
    String device_Id = widget.deviceId!;
    DatabaseReference dbLock = await db.ref('devices/$device_Id/lock');
    dbLock.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      lock = data.toString();
      setStatus();
    });
  }

  Future<void> getBatteryStatus() async {
    String device_Id = widget.deviceId!;
    DatabaseReference dbBattery = await db.ref('devices/$device_Id/battery');
    dbBattery.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      _battery = data.toString();
    });
  }

  void logOut() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => main_page(),
        ),
      );
      auth.signOut();
    });
  }
}
