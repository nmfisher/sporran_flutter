
import 'package:sporran/lawndart.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteStore extends Store {

  Database db;
  static String _table = "data";
  static String _key = "key";
  static String _document = "document";

  SqfliteStore._(this.db);

  static Future<SqfliteStore> open(String dbName) async {
    var db = await openDatabase(dbName);
    await db.execute(
      "CREATE TABLE $_table ($_key TEXT PRIMARY KEY, $_document TEXT)"); 
    final store = new SqfliteStore._(db);
    return store;
  }

  @override
  Stream<String> all() async* {
    var documents = await db.query("data");
    for(var doc in documents ) {
      yield doc["document"];
    }
  }

  @override
  Future batch(Map<String, String> objectsByKey) {
    // TODO: implement batch
    return null;
  }

  @override
  Future<bool> exists(String key) async {
    var documents = await db.query(_table, columns:[_key], where: 'key = ?', whereArgs: [key]);
    return documents.length > 0;
  }

  @override
  Future<String> getByKey(String key) {
    return db.query(_table, columns:[_key], where: '$_key = ?', whereArgs: [key]).then((x) {
      return x.length > 0 ? x.first[_document] : null;
    });
  }

  @override
  Stream<String> getByKeys(Iterable<String> keys) {
    // TODO: implement getByKeys
    return null;
  }

  @override
  Stream<String> keys() {
    // TODO: implement keys
    return null;
  }

  @override
  Future nuke() {
    // TODO: implement nuke
    return null;
  }

  @override
  Future removeByKey(String key) {
    // TODO: implement removeByKey
    return null;
  }

  @override
  Future removeByKeys(Iterable<String> keys) {
    // TODO: implement removeByKeys
    return null;
  }

  @override
  Future<String> save(String obj, String key) {
    return 
  }
}
