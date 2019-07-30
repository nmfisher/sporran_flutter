import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_object_lite/json_object_lite.dart';
import 'package:sporran/sporran_io.dart';
import 'package:sporran_flutter/sporran_flutter.dart';
import 'package:sporran_flutter/sqflite_store.dart';
import 'package:sqflite/sqflite.dart';
import 'sporran_test_config.dart';


void main() async {

  /* Common initialiser */
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
  
  const MethodChannel channel = MethodChannel('sporran_flutter');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });

    deleteDatabase("mydb.db");
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SporranFlutter.platformVersion, '42');
  });

  test('Construct Sporran/SQFlite with correct authentication details', () async {
    var sporran = getSporran(initialiser, Stream.empty());
    var response = await sporran.getAllDocs();
    expect(response["totalRows"], 0);
  });

  test('Construct Sporran/SQFlite with incorrect authentication details does not throw exception (i.e. creates local storage only)', () async {
    initialiser.password = 'wrong';
    var sporran = getSporran(initialiser, Stream.empty());
    sporran.put("some_doc", JsonObjectLite());

    initialiser.password = userPassword;

    var response = await sporran.getAllDocs();
    expect(response["totalRows"], 1);

    var doc = await sporran.get("some_doc");
    print(doc);
    expect(doc, isNotNull);
  });

}
