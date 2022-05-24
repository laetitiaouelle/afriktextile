import 'dart:convert';

import 'package:afriktextile/back_end/custModel.dart';
import 'package:afriktextile/back_end/dbhelper.dart';
import 'package:afriktextile/back_end/playsound.dart';
import 'package:afriktextile/views/comsuccess.dart';
import 'package:afriktextile/views/function.dart';
import 'package:afriktextile/views/payementDetail.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;


var dbHelper = DBHelper();
var ft = dbHelper.getCustomer();
var idCommand="${randomAlphaNumeric(10)}AFRIKTEXTILE${randomBetween(100, 20000)}";
var fc = FunctionOp();
var a=Audio();


class NulPlace extends StatefulWidget {
  @override
  _NulPlaceState createState() => _NulPlaceState();
}

class _NulPlaceState extends State<NulPlace> {

var countryController = TextEditingController();
bool visibleState = true;
List<Commande> cmds=[] ;
Commande com = Commande();
var idCustomer;
Future <List<Commande>> cmd;


Future<List<Commande>> getProductFromDB(int id) async{   
  var dbHelper = DBHelper();
  Future <List<Commande>> products= dbHelper.getProducts('Commandes',id);
  return products;
}

sendCommand(String country){
  ft.then((data){ 
    setState((){
      visibleState=true;
    });
    var res= getProductFromDB(data[0].id);
    res.then((d){
      send(d,data[0].name,data[0].phone, country, idCommand);
    });
    
  },onError: (e) {print(e);});
}
Future send(List<Commande> command, String name, String phone, String country, String idCommand) async {
  final http.Response response = await http.post(
    "http://afriktextile.com/app/aftxl/requests/send_com_contry_no_listed.php",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'command': command,
      'name': name,
      'phone': phone,
      'country': country,
      'idCommand': idCommand,
    }),
  );
  
  if (response.statusCode == 200) {
    var msg = json.decode(response.body);
    switch (msg) {
      case "total":
       setState((){ visibleState = false; });
       for(var i in command)  dbHelper.deleteCommand(i.id,"Commandes");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context)=> Resultat()),
        ModalRoute.withName('/'),
        );

        break;
      case "livraisonProb":

        break;
      case "commandProd":

        break;

      default:
    }
  } else {
    setState((){ visibleState = true; });
    Fluttertoast.showToast(msg: "Un problème de connexion est survenu. Veuillez réessayer!.",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF333333));
  }
}
@override
  void initState() {
    super.initState();
    idCommand="${randomAlphaNumeric(10)}AFRIKTEXTILE${randomBetween(100, 20000)}";

     ft.then((v){
     for(var i in v){
       setState((){
        idCustomer = i.id;
        cmd=getProductFromDB(i.id); 
         cmd.then((data){
          for(var a in data){
            setState((){
              cmds.add(a);
            });
          }
        });
       });
     }
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:IconButton(
          icon: Icon(
            Icons.arrow_left,
            color: Colors.green[300],
            size: 40,
          ),
          onPressed: (){ a.play("click.m4a"); Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context)=> PayementDetail()),
            ModalRoute.withName('/'),
            );
            },
        ),
        title: Container(
          child: Text(
            "Pays non listé par AfrikTextile ?",
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ),
        elevation:1,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView ( child: Column(
          children:<Widget>[
            Container(
              alignment: AlignmentDirectional.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3,
              child: Image.asset("assets/images/place.png"),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height:(( MediaQuery.of(context).size.height/3)*2)-80,
              decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:<Widget>[
                  Container(
                    width: (MediaQuery.of(context).size.width/3)*2.5,
                    child: Text(
                      "Si vous n'avez pas trouvé votre pays dans la liste des pays des détails de payement, alors écrivez le nom de votre pays dans le formulaire ci-dessous et l'équipe AfrikTextile vous contactera pour trouver le moyen d'avoir vos pagnes dans votre pays",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    alignment: AlignmentDirectional.center,
                    padding: EdgeInsets.only(left:10),
                    width: (MediaQuery.of(context).size.width/3)*2.5,
                    child: TextFormField(
                      controller: countryController,
                      decoration: InputDecoration(
                        hintText: "Nom du pays",
                        
                        hintStyle: TextStyle(
                          color: Color(0xFF3F3D56),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: Icon(Icons.my_location, color:Color(0xFF3F3D56),),
                        
                      ),
                    ),
                  ),
                  Visibility(
                    visible: visibleState,
                    child: InkWell(
                      child: Container(
                        width: (MediaQuery.of(context).size.width/3)*2.5,
                        height: 50,
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                          color: Color(0xFF3F3D56),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50)
                          ),
                        ),
                        child: Text(
                          "Valider la comande",
                          style: TextStyle(
                            color: Colors.white,

                          )
                        ),
                      ),
                      onTap: (){
                        a.play("click.m4a");
                        countryController.text==""? Fluttertoast.showToast(msg: "Champs vide") : sendCommand(countryController.text); 
                      },
                    ),
                  ),
                  Visibility(
                    visible: !visibleState,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green[300],
                      valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF3F3D56))
                    ),
                  ),
                ]
              )
            )
          ]
        ),
        )
      )
    );
  }
}