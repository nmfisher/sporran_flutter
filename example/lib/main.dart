import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sporran_flutter/sporran_flutter.dart';
import 'package:sporran/sporran_io.dart';
import 'package:sporran_flutter/sporran_flutter.dart';
import 'package:json_object_lite/json_object_lite.dart';
import 'package:sporran_flutter/sqflite_store.dart';
import 'package:sqflite/sqflite.dart';

/* Global configuration, please edit */

/* CouchDB server */
final String hostName = "10.0.2.2";
final String port = "5984";
final String scheme = "http://";

/* Database to use for testing */
final String databaseName = 'sporrantest';

/// Authentication, set as you wish, note leaving userName and password null
/// implies no authentication, i.e admin party, if set Basic authentication is
/// used.
final String userName = 'wenwenadmin';
final String userPassword = 'somesupersecretpassword';



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SporranFlutter.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    final SporranInitialiser initialiser = new SporranInitialiser();
  initialiser.store = await SqfliteStore.open("mydb");
  initialiser.dbName = databaseName;
  initialiser.hostname = hostName;
  initialiser.manualNotificationControl = true;
  initialiser.port = port;
  initialiser.scheme = scheme;
  initialiser.username = userName;
  initialiser.password = userPassword;
  initialiser.preserveLocal = false;
  

    var sporran = getSporran(initialiser, Stream.fromIterable([true]));
    sporran.put("some_doc", JsonObjectLite());

    var response = await sporran.getAllDocs();

    var doc = await sporran.get("some_doc");
    print(sporran.online);
    sporran.sync();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
