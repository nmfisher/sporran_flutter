import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:sporran/sporran_io.dart';
import 'package:sporran_flutter/sqflite_store.dart';

class SporranFlutter {

  final String host;
  final String port;
  final String username;
  final String password;
  final String databaseName;

  Sporran sporran;
  SporranInitialiser initialiser;
  
  SporranFlutter(this.host, this.port, this.username, this.password, this.databaseName) {
    initialiser = new SporranInitialiser();
    initialiser.dbName = databaseName;
    initialiser.hostname = host;
    initialiser.manualNotificationControl = true;
    initialiser.port = port;
    initialiser.scheme = "http://";
    initialiser.username = username;
    initialiser.password = password;
    initialiser.preserveLocal = true;
  }
  
  void initialize() async {
    final SqfliteStore store = await SqfliteStore.open("${initialiser.dbName}.db");
    var online = Connectivity().onConnectivityChanged.map((x) => x != ConnectivityResult.none);
    initialiser.store = store;
    sporran = await getSporran(initialiser, online);
    sporran.autoSync = false;
  }

}
