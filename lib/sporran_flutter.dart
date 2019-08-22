import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:sporran/sporran_io.dart';
import 'package:sporran/lawndart.dart';
import 'package:sporran_flutter/sqflite_store.dart';

class SporranFlutter {

  final String host;
  final String port;
  final String username;
  final String password;
  final String databaseName;
  Stream<bool> connectivity;

  Sporran sporran;
  SporranInitialiser initialiser;
  
  SporranFlutter(this.host, this.port, this.username, this.password, this.databaseName, this.connectivity, [ Store store ]) {
    initialiser = new SporranInitialiser();
    initialiser.dbName = databaseName;
    initialiser.hostname = host;
    initialiser.manualNotificationControl = true;
    initialiser.port = port;
    initialiser.scheme = "http://";
    initialiser.username = username;
    initialiser.password = password;
    initialiser.preserveLocal = true;
    initialiser.store = store;
  }
  
  void initialize() async {
    if(initialiser.store == null) {
      initialiser.store = await SqfliteStore.open("${initialiser.dbName}.db");
    }

    if(connectivity == null) 
      connectivity = Connectivity().onConnectivityChanged.map((x) => x != ConnectivityResult.none);
    
    sporran = await getSporran(initialiser, connectivity);
    sporran.autoSync = false;
  }

}
