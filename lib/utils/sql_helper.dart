import 'dart:async';
import 'dart:io';
import 'package:fit_tarifler/model/K%C3%BCtle.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String _kutleTablo="kutle";
  String _columnID="id";
  String _columnKilo="kilo";
  String _columnBoy="boy";
  String _columnSonuc="sonuc";
 factory DatabaseHelper(){
   if(_databaseHelper==null){
     _databaseHelper=DatabaseHelper.internal();
     return _databaseHelper;
   }else
     return _databaseHelper;
 }

  DatabaseHelper.internal();
 Future<Database>_getDatabase()async{
   if(_database==null){
     _database=await _initializeDatabase();
     return _database;
   }else{
     return _database;
   }
 }

  _initializeDatabase() async{
  Directory klasor=await getApplicationDocumentsDirectory();
  String dbPath=join(klasor.path,"kutle.db");
  var kutleDB=openDatabase(dbPath,version: 1,onCreate: _createDb);
  print(dbPath);
  return kutleDB;
  }

  FutureOr<void> _createDb(Database db, int version) async{
  await db.execute("CREATE TABLE $_kutleTablo($_columnID INTEGER PRIMARY KEY AUTOINCREMENT ,$_columnKilo TEXT ,$_columnBoy TEXT ,$_columnSonuc TEXT )");
  }

  Future<int>kutleEkle(Kutle kutle)async{
   var db=await _getDatabase();
  var sonuc=await db.insert(_kutleTablo, kutle.toMap(),nullColumnHack: "$_columnID");
  print("ekleme yapıldı"+sonuc.toString());
   return sonuc;
  }
 Future<List<Map<String,dynamic>>>tumVeriler()async{
    var db=await _getDatabase();
    var sonuc=await db.query(_kutleTablo,orderBy: "$_columnID DESC");
    return sonuc;
  }
  Future<int>kutleSil()async{
    var db=await _getDatabase();
    await db.delete(_kutleTablo);
  }
}