

import 'package:my_app/models/archives_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';




class DBProvider {

    static Database? _database;

  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

    Future<Database?> initDB() async {
    sqfliteFfiInit();

   String  documentsDirectory = await databaseFactoryFfi.getDatabasesPath();

    final path = join(documentsDirectory, 'UsersDB.db');

    // Crear base de datos
    return await databaseFactoryFfi.openDatabase(path, 
      options: OpenDatabaseOptions(
        version: 3,
          onCreate: (Database db, int version) async {
      await db.execute('''
         CREATE TABLE Users(
           id INTEGER PRIMARY KEY,
           cedula INTEGER,
           cuotas INTEGER, 
           interes INTEGER,
           monto INTEGER,
           nombre TEXT,
           telefono TEXT,
           trabaja TEXT,
           obs TEXT,
           idCliente TEXT,
           fecha TEXT,
           direccion TEXT,
           referencia TEXT
         )
        ''');
    }
      )
    );
  }
  
  Future<List<ArchivesModel>> getScansPorID(int id) async {
    final db = await database;
    final res = await db!.rawQuery('''
      SELECT * FROM Users WHERE id = '$id'    
    ''');

    return res.isNotEmpty
        ? res.map((s) => ArchivesModel.fromJson(s)).toList()
        : [];
  }

   Future<int> nuevoFolder(ArchivesModel archivesModel) async {
    final db = await database;

    final res = db!.insert('Users', archivesModel.toJson());
    return res;
  }

  Future<List<ArchivesModel>> getTodosLosScans() async {
    final db = await database;
    final res = await db!.query('Users');

    return res.isNotEmpty
        ? res.map((s) => ArchivesModel.fromJson(s)).toList()
        : [];
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db!.delete('Users', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> updateScan(ArchivesModel nuevoScan) async {
    final db = await database;
    final res = await db!.update('Users', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }



  
}
