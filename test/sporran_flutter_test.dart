import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:sporran/sporran_io.dart';
import 'package:sporran_flutter/sqflite_store.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wilt/wilt.dart';
import 'sporran_test_config.dart';
import 'package:test/test.dart';

void main() async {

  Sqflite.devSetDebugModeOn(true);

  /* Create a Wilt instance for when we want to interface with CouchDb directly 
  * (e.g. dropping the database or updating directly to test that change notifications are correctly picked up).
  */

  final Wilt wilt = new WiltServerClient2(hostName, port, scheme);

  /* Login if we are using authentication */
  if (userName != null) {
    wilt.login(userName, userPassword);
  }

  /* Common initialiser */
  final SporranInitialiser initialiser = new SporranInitialiser();
  initialiser.store = await SqfliteStore.open("mydb");
  initialiser.dbName = databaseName;
  initialiser.hostname = hostName;
  initialiser.port = port;
  initialiser.scheme = scheme;
  initialiser.username = userName;
  initialiser.password = userPassword;
  initialiser.preserveLocal = false;
  
  var sporranFactory = (SporranInitialiser initialiser) {
    return getSporran(initialiser, Stream.empty());
  };
  // run(wilt, initialiser, sporranFactory);
  runScenario1(wilt, initialiser, sporranFactory);
  runScenario2(wilt, initialiser, sporranFactory);
  runScenario3(wilt, initialiser, sporranFactory);
}
