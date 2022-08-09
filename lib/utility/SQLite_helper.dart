import 'package:flutter_login/model/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLlite {
  final String nameDatabase = 'Gofood.db';
  final String tableDatabase = 'orderTable';

  int version = 1;

  final String idColumn = 'id';
  final String idShopColumn = 'idShop';
  final String nameShop = 'nameShop';
  final String idFood = 'idFood';
  final String nameFood = 'nameFood';
  final String price = 'price';
  final String amount = 'amount';
  final String sum = 'sum';
  final String distance = 'distance';
  final String transport = 'transport';

  SQLlite() {
    initDatabase();
  }

  Future<Null> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), nameDatabase),
        onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableDatabase ($idColumn INTEGER PRIMARY KEY, $idShopColumn TEXT, $nameShop TEXT, $idFood TEXT, $nameFood TEXT, $price TEXT, $amount TEXT, $sum TEXT, $distance TEXT, $transport TEXT)'),
        version: version);
  }

  Future<Database> connectedDatabase() async {
    return openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<Null> insertDataToSQLite(CartModel cartModel) async {
    Database database = await connectedDatabase();

    try {
      database.insert(
          tableDatabase, 
          cartModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<CartModel>> readAllDataFromSQLite() async{
        Database database = await connectedDatabase();
        List<CartModel> cartModels = List();

        List<Map<String, dynamic>> maps = await database.query(tableDatabase);
        for(var map in maps){
           CartModel cartModel = CartModel.fromJson(map);
           cartModels.add(cartModel);
        }
        return cartModels;
  } 

  Future<Null> deleteDataWhereId(int id) async{
     Database database = await connectedDatabase();
     
     try{
         await database.delete(tableDatabase, where: '$idColumn = $id');

     }catch (e){
       print('delete = ${e.toString()}');
     }
  }

  Future<Null> deleteAllData() async{
    Database database = await connectedDatabase();

    try{
         await database.delete(tableDatabase);

    }catch (e){
         print("${e.toString()}");
    }
  }
}
