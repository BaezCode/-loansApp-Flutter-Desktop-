import 'package:my_app/models/prestamos_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DBPrestamo {
  static Database? _database;

  static final DBPrestamo db = DBPrestamo._();
  DBPrestamo._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database?> initDB() async {
    sqfliteFfiInit();

    String documentsDirectory = await databaseFactoryFfi.getDatabasesPath();

    final path = join(documentsDirectory, 'prestamoDB.db');

    // Crear base de datos
    return await databaseFactoryFfi.openDatabase(path,
        options: OpenDatabaseOptions(
            version: 6,
            onCreate: (Database db, int version) async {
              await db.execute('''
         CREATE TABLE prestamo(
           id INTEGER PRIMARY KEY,
           monto INTEGER,
           interes REAL,
           interesMoratorio REAL,
           interesPunitorio REAL,
           cuotas INTEGER,
           data TEXT,
           nombre TEXT,
           obs TEXT,
           idCliente TEXT,
           fecha TEXT,
           fechaPago TEXT,
           fechaMili INTEGER,
           totalAPagar REAL,
           totalInteres REAL
         )
        ''');
            }));
  }

  Future<int> nuevoFolder(PrestamosModel prestamosModel) async {
    final db = await database;

    final res = db!.insert('prestamo', prestamosModel.toJson());
    return res;
  }

  Future<List<PrestamosModel>> getPrestamoPorFecha(
      int primeraFecha, int segundaFecha) async {
    final db = await database;
    final res = await db!.rawQuery('''
      SELECT * FROM prestamo WHERE fechaMili BETWEEN $primeraFecha AND $segundaFecha    
    ''');

    return res.isNotEmpty
        ? res.map((s) => PrestamosModel.fromJson(s)).toList()
        : [];
  }

  Future<List<PrestamosModel>> getScansPorID(String id) async {
    final db = await database;
    final res = await db!.rawQuery('''
      SELECT * FROM prestamo WHERE idCliente = '$id'    
    ''');

    return res.isNotEmpty
        ? res.map((s) => PrestamosModel.fromJson(s)).toList()
        : [];
  }

  Future<int> deletePrestamo(int id) async {
    final db = await database;
    final res = await db!.delete('prestamo', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> updatePrestamo(PrestamosModel nuevoPrestamo) async {
    final db = await database;
    final res = await db!.update('prestamo', nuevoPrestamo.toJson(),
        where: 'id = ?', whereArgs: [nuevoPrestamo.id]);
    return res;
  }
}
