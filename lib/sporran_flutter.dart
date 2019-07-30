import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:sporran/sporran_io.dart';
import 'package:sporran_flutter/sqflite_store.dart';

class SporranFlutter {
  static const MethodChannel _channel =
      const MethodChannel('sporran_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void initialize(SporranInitialiser initialiser) async {
    final SqfliteStore store = await SqfliteStore.open("${initialiser.dbName}.db");
    var online = Connectivity().onConnectivityChanged.map((x) => x != ConnectivityResult.none);
    initialiser.store = store;
    // Create the client
    final Sporran sporran = getSporran(initialiser, online);
    sporran.autoSync = false;
    await sporran.onReady.first;
  }
}
