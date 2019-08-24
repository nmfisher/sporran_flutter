import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:sporran/sporran_io.dart';
import 'package:sporran/lawndart.dart';
import 'package:sporran_flutter/sqflite_store.dart';

class SporranFlutter {
  final String host;
  final String port;
  final String username;
  final String password;
  final String databaseName;
  final bool autoSync;
  final bool localOnly;
  Stream<bool> connectivity;

  Sporran sporran;
  SporranInitialiser initialiser;

  SporranFlutter(this.host, this.port, this.username, this.password,
      this.databaseName, this.connectivity,
      {Store store, this.autoSync, this.localOnly}) {
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
    if (initialiser.store == null) {
      var filename = "${initialiser.dbName}.sql";
      if(await File(filename).exists()) {
        print("Opening existing database file at $filename");
      } else {
        print("Creating new database file at $filename");
      }
      
      initialiser.store = await SqfliteStore.open(filename);
    }

    if (connectivity == null)
      connectivity = Connectivity()
          .onConnectivityChanged
          .map((x) => x != ConnectivityResult.none);

    sporran = await getSporran(initialiser, connectivity, localOnly);
    sporran.autoSync = autoSync;
  }
}
