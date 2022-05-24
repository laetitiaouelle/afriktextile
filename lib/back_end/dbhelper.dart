import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'custModel.dart';
import 'package:afriktextile/views/function.dart';
import 'package:collection/collection.dart';

var fc = FunctionOp();
List l=["p8mars","ch2tons","fdm","woodin","hollandais","uniwaxblock","uniwaxprint","ABC","chuni","hollantex","hitarget","hitarget2tons","waxsuper","waxbrode"];
class DBHelper{
  static Database dbInstance;
  Future<Database> get db async{
    if(dbInstance==null)
      dbInstance = await initDB();
    return dbInstance;
  }
  initDB() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,"aftxl.db");
    var db= await openDatabase(path, version: 1, onCreate: onFunc);
    return db;
  }

  void onFunc(Database db, int version) async{

    for (var i in l) {
      await db.execute("CREATE TABLE $i ("
            "id INTEGER PRIMARY KEY,"
            "name TEXT,"
            "qty TEXT,"
            "price TEXT,"
            "active TEXT,"
            "prodId INTEGER,"
            "image TEXT,"
            "description TEXT,"
            "descriptionshort TEXT,"
            "reduction TEXT,"
            "wish INTEGER"
            ")");
    }
    await db.execute("CREATE TABLE Customer ("
          "id INTEGER PRIMARY KEY,"
          "aftxlID TEXT,"
          "last_name TEXT,"
          "number TEXT,"
          "password TEXT,"
          "email TEXT,"
          "con INTEGER,"
          "son INTEGER,"
          "img INTEGER,"
          "link TEXT,"
          "liv TEXT"
          ")");
  await db.execute("CREATE TABLE Commandes ("
            "id INTEGER PRIMARY KEY,"
            "userId INTEGER,"
            "name TEXT,"
            "qty INTEGER,"
            "price INTEGER,"
            "prodId INTEGER,"
            "image TEXT,"
            "description TEXT,"
            "descriptionshort TEXT"
            ")");
    await db.execute("CREATE TABLE Wishlist ("
            "id INTEGER PRIMARY KEY,"
            "userId INTEGER,"
            "name TEXT,"
            "qty INTEGER,"
            "price INTEGER,"
            "prodId INTEGER,"
            "image TEXT,"
            "description TEXT,"
            "descriptionshort TEXT"
            ")"); 
  }

  //CRUD OPERATION For Products

    //Get Command/wish

    Future<List<Commande>> getProducts(String table, int id) async{
      var dbConnexion = await db;
      List<Map> list = await dbConnexion.rawQuery('SELECT * FROM $table WHERE userId=?',[id]);
      List<Commande> products = new List();

      for (var i = 0; i < list.length; i++) {
        Commande product = new Commande();
        product.id = list[i]['id'];
        product.name = list[i]['name'];
        product.quantity = list[i]['qty'];
        product.price = list[i]['price'];
        product.prodId= list[i]['prodId'];
        product.image = list[i]['image'];
        product.description = list[i]['description'];
        product.descriptionShort = list[i]['descriptionShort'];
        //product.r
        products.add(product);
      }
      return products;
    }
    //get article number

    Future<int> getArNb(String table, int id)async{
      var dbConnexion = await db;
      List<Map> list = await dbConnexion.rawQuery('SELECT * FROM $table WHERE userId=?',[id]);
      return list.length;
    }
    //Add new Command/wish

    void addNewCommand(Products product, String table, int id) async{
      var dbConnexion = await db;
      List<Map> list = await dbConnexion.rawQuery('SELECT * FROM $table WHERE prodId=?',[product.id]);
      if(list.length==0){
          String query = 'INSERT INTO $table(userId ,name, qty, price, prodId, image, description, descriptionshort) VALUES(?,?,?,?,?,?,?,?)';
          await dbConnexion.transaction((transaction) async{
            return transaction.rawInsert(query,[id, product.name, 1, product.price, product.id, product.image, product.description, product.descriptionShort]);
          }
        );
      }else{}
    }
    
    //Add json to db
    void addJsonData(Products product, String table) async{
      var dbConnexion = await db;
      List<Map> list = await dbConnexion.rawQuery('SELECT * FROM $table WHERE prodId=?',[product.id]);
      List<Products> datas = new List();
      Products data = new Products();
      for (var i = 0; i < list.length; i++) {
          data.index=list[i]['index'];
          data.id=list[i]['prodId'];
          data.image=list[i]['image'];
          data.quantity=list[i]['qty'];
          data.price=list[i]['price'];
          data.active=list[i]['active'];
          data.name=list[i]['name'];
          data.description=list[i]['description'];
          data.descriptionShort=list[i]['descriptionshort'];
          data.reduction = list[i]['reduction'];
          datas.add(data);
      }
      if(list.length==0){
          String query = 'INSERT INTO $table(name, qty, price, active, prodId, image,description,descriptionshort, reduction) VALUES(?,?,?,?,?,?,?,?,?)';
          await dbConnexion.transaction((transaction) async{
            return transaction.rawInsert(query,[product.name, product.quantity, product.price,product.active, product.id, product.image, product.description, product.descriptionShort, product.reduction]);
          }
        );
      }else{
        if(product.quantity != "1"){
          deleteCommand(product.id, table);
        }else{
          var arrayForLastData = [
            data.name, data.quantity, data.price, data.active,
            data.id, data.image, data.description, data.descriptionShort, data.reduction
          ];
          var arrayForNewData = [
            product.name, product.quantity, product.price,product.active,
            product.id, product.image, product.description, product.descriptionShort, product.reduction
          ];
          Function eq = const ListEquality().equals;
          if(eq(arrayForLastData, arrayForNewData)==true){
            //noting to do
          }else{
            //we are going to update this product with new data
            String query = "UPDATE $table SET name=?, qty=?, price=?, image=?, description=?, descriptionshort=?, reduction=? WHERE prodId=?";
            await dbConnexion.transaction((transaction) async{
              return transaction.rawQuery(query,[product.name, product.quantity, product.price, product.image, product.description, product.descriptionShort, product.reduction, product.id]);
            }
            );
          }
        }
      }
    }
   
   //get data json from sqlite
     Future<List<Products>> getLocalJson(String table) async{
      var dbConnexion = await db;
      List<Map> list = await dbConnexion.rawQuery('SELECT * FROM $table ORDER BY prodId DESC');
      List<Products> datas = new List();
      for (var i = 0; i < list.length; i++) {
        Products data = new Products();
          data.index=list[i]['index'];
          data.id=list[i]['prodId'];
          data.image=list[i]['image'];
          data.quantity=list[i]['qty'];
          data.price=list[i]['price'];
          data.active=list[i]['active'];
          data.name=list[i]['name'];
          data.description=list[i]['description'];
          data.descriptionShort=list[i]['descriptionshort'];
          data.reduction = list[i]['reduction'];
          datas.add(data);
      }
      return datas;
    }
    
    
    //Update Command/wish

    void updateContact(Products product, String table) async{
      var dbConnexion = await db;
      String query = "UPDATE $table SET qty=? WHERE id=?";
      await dbConnexion.transaction((transaction) async{
        return transaction.rawQuery(query,[product.quantity, product.id]);
      }
      );
    }

    //Delete Command/wish

    void deleteCommand(int id, String table) async{
      var dbConnexion = await db;
      String query = "DELETE FROM $table WHERE id=?";
      await dbConnexion.transaction((transaction) async{
        return transaction.rawQuery(query,[id]);
      }
      );
    }

    //Delete Command/wish

    void deleteConnectedUser(String table) async{
      var dbConnexion = await db;
      String query = "DELETE FROM $table WHERE con=?";
      await dbConnexion.transaction((transaction) async{
        return transaction.rawQuery(query, [1]);
      }
      );
    }

    //Save customer offline

    //Add customer

    void addNewCustomer(String aftxlID, String name, String number, String password, int con, String link) async{
      var dbConnexion = await db;
      List<Map> list = await dbConnexion.rawQuery('SELECT * FROM Customer WHERE number=?',[number]);
      if(list.length==0){
          String query = 'INSERT INTO Customer(aftxlID, last_name, number, password,con, son, link) VALUES(?,?,?,?,?,?,?)';
          await dbConnexion.transaction((transaction) async{
            return transaction.rawInsert(query,[aftxlID, name, number, password, con, 1, link]);
          }
          );
      }
     
    }

    //Get Customer

    Future<List<Customer>> getCustomer() async{
      var dbConnexion = await db;
      List<Map> list = await dbConnexion.rawQuery('SELECT * FROM Customer WHERE con=1');
      List<Customer> customers = new List();

      for (var i = 0; i < list.length; i++) {
        Customer customer = new Customer();
        customer.id = list[i]['id'];
        customer.name = list[i]['last_name'];
        customer.phone = list[i]['number'];
        customer.password = list[i]['password'];
        customer.email = list[i]['email'];
        customer.img = list[i]['img'];
        customer.link = list[i]['link'];
        customer.son = list[i]['son'];
        customer.aftxlID = list[i]['aftxlID'];
        customer.liv = list[i]['liv'];
        customers.add(customer);
      }
      return customers;
    }

    //Get Customer

    Future<List<Customer>> getAllCustomer() async{
      var dbConnexion = await db;
      List<Map> list = await dbConnexion.rawQuery('SELECT * FROM Customer');
      List<Customer> customers = new List();

      for (var i = 0; i < list.length; i++) {
        Customer customer = new Customer();
        customer.id = list[i]['id'];
        customer.name = list[i]['last_name'];
        customer.phone = list[i]['number'];
        customers.add(customer);
      }
      return customers;
    }

    Future<bool> existCustomer() async{
      var dbConnexion = await db;
      List<Map> list = await dbConnexion.rawQuery('SELECT * FROM Customer WHERE con=1');
      if(list.length != 0){
        return true;
      }else{
        return false;
      }
    }

    //Update Customer con

    void updateCon(String phone, int con) async{
      var dbConnexion = await db;
      String query = "UPDATE Customer SET con=? WHERE number=?";
      await dbConnexion.transaction((transaction) async{
        return transaction.rawQuery(query,[con, phone]);
      }
      );
    }

//update user info

void updateUserInfo(Customer ctm) async{

  var dbConnexion = await db;
    String query = "UPDATE Customer SET last_name=?, number=?, password=?, email=?, son=?, link=? WHERE id=?";
    await dbConnexion.transaction((transaction) async{
      return transaction.rawQuery(query,[ctm.name, ctm.phone, ctm.password, ctm.email, ctm.son, ctm.link, ctm.id]);
    }
  );

}

//update LivraisonPlaceInfo

void updateLivraisonPlaceInfo(String liv, int id) async{
  var dbConnexion = await db;
    String query = "UPDATE Customer SET liv=? WHERE id=?";
    await dbConnexion.transaction((transaction) async{
      return transaction.rawQuery(query,[liv, id]);
    }
  );

}
     Future<int>getCustomerId() async{
      int id;
      var dbConnexion = await db;
      var list = await dbConnexion.rawQuery('SELECT id FROM Customer WHERE con=1');

      for (var i = 0; i < list.length; i++) {
        id = list[i]['id'];
      }
      return id;
    }

    //Update Command quantity

    void updateCommandQty(String ac, int id) async{
      var dbConnexion = await db;
      var list = await dbConnexion.rawQuery('SELECT qty FROM Commandes WHERE id=?',[id]);
      for (var i = 0; i < list.length; i++) {
        int nb=list[i]['qty'];
        if(ac=='+'){           
             String query = "UPDATE Commandes SET qty=? WHERE id=?";
              await dbConnexion.transaction((transaction) async{
                return transaction.rawQuery(query,[nb+1, id]);
              }
            );
        }else if(ac=="-"){
           if(nb==1 || nb==0){
             
           }else{
              String query = "UPDATE Commandes SET qty=? WHERE id=?";
              await dbConnexion.transaction((transaction) async{
                return transaction.rawQuery(query,[nb-1, id]);
              }
            );
           }
        }
      }
      
    }
    //Future close()=>dbInstance.close();
}