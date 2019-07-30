
import 'package:sporran/lawndart.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteStore extends Store {

  Database db;
  static String _table = "data";
  static String _key = "key";
  static String _document = "document";
  static String _createDb = "CREATE TABLE IF NOT EXISTS $_table ($_key TEXT PRIMARY KEY, $_document TEXT)";
  static String _dropDb = 'DROP TABLE $_table';

  SqfliteStore._(this.db);

  static Future<SqfliteStore> open(String dbName) async {
    var db = await openDatabase(dbName);
    db.execute(_createDb); 
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
  Future batch(Map<String, String> objectsByKey) async {
    return db.insert(_table, objectsByKey);
  }

  @override
  Future<bool> exists(String key) async {
    var documents = await db.query(_table, columns:[_key], where: 'key = ?', whereArgs: [key]);
    return documents.length > 0;
  }

  @override
  Future<String> getByKey(String key) {
    return db.query(_table, columns:[_document], where: '$_key = ?', whereArgs: [key]).then((x) {
      return x.length > 0 ? x.first[_document] : null;
    });
  }

  @override
  Stream<String> getByKeys(Iterable<String> keys) async* {
    if(keys.length == 0)
      return;

    var params = List.filled(keys.length, "?").join(",");
    var results = await db.query(_table, columns:[_document], where: '$_key in ($params)', whereArgs: keys.toList());
    for (var result in results) {
      print(result);
      yield result[_document];
    }
  }

  @override
  Stream<String> keys() async * {
    var results = await db.query(_table, columns:[_key]);
    for (var result in results) {
      yield result[_key];
    }
  }

  @override
  Future nuke() async {
    await db.transaction((txn) async {
      await txn.execute(_dropDb);
      await txn.execute(_createDb);
    });
  }

  @override
  Future removeByKey(String key) {
    return db.delete(_table, where:"$_key = ?", whereArgs:[key]);
  }

  @override
  Future removeByKeys(Iterable<String> keys) {
    return db.delete(_table, where:"$_key in ?", whereArgs:[keys]);
  }

  @override
  Future<String> save(String obj, String key) async {
    await db.insert(_table, {_key:key, _document:obj});
    return key;
  }
}
