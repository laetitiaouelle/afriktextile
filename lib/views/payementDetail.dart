import 'dart:convert';
import 'package:afriktextile/back_end/custModel.dart';
import 'package:afriktextile/back_end/dbhelper.dart';
import 'package:afriktextile/back_end/playsound.dart';
import 'package:afriktextile/views/basket.dart';
import 'package:afriktextile/views/comsuccess.dart';
import 'package:afriktextile/views/function.dart';
import 'package:afriktextile/views/nul_place.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

var idCommand="${randomAlphaNumeric(10)}AFRIKTEXTILE${randomBetween(100, 20000)}";
var fc = FunctionOp();
var dbHelper = DBHelper();

var a=Audio();




class PayementDetail extends StatefulWidget {
  @override
  _PayementDetailState createState() => _PayementDetailState();
}

class _PayementDetailState extends State<PayementDetail> {

var dropdownValue = "--------------------------------------------";
var frais;
var fraisPrix=0;
var paymentMethod;
var livraisonPlace;
var livraisonPlaceController = TextEditingController();
var totalBrut=0;
var items =0; 
var idCustomer;
var total=0;
var tfrais=0;
bool visibleState = false;


List<Commande> cmds=[] ;
Commande com = Commande();

Future<List<Commande>> getProductFromDB(int id) async{   
  var dbHelper = DBHelper();
  Future <List<Commande>> products= dbHelper.getProducts('Commandes',id);
  return products;
}

Future sendCommand(List<Commande> command, String name, String phone, String dropdownValue, var frais, var paymentMethod, var livraisonPlace, var idCommand) async{
   final http.Response response = await http.post(
    "https://afriktextile.com/app/aftxl/requests/send_command.php",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'command': command,
      'name': name,
      'phone': phone,
      'country': dropdownValue,
      'frais': frais,
      'paymentMethod': paymentMethod,
      'livraisonPlace': livraisonPlace,
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
    setState((){ visibleState = false; });
    Fluttertoast.showToast(msg: "Un problème de connexion est survenu. Veuillez réessayer!.",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Color(0xFFFFFFFF),
      textColor: Color(0xFF333333));

  }

}

Future <List<Commande>> cmd;

  @override
  void initState() {
    super.initState();
    var ft = dbHelper.getCustomer();
    idCommand="${randomAlphaNumeric(10)}AFRIKTEXTILE${randomBetween(100, 20000)}";
     ft.then((v){
     for(var i in v){
       setState((){
        idCustomer = i.id;
        livraisonPlace = i.liv;
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



//Déclaration importante




void selectController(String value){
  setState((){
    switch (value) {
      case "--------------------------------------------" :
          tfrais=0;
          items=0;
          frais=null;
          fraisPrix=0;
          paymentMethod=null;
          totalBrut=0;
          total=0;
        break;

      case "CIV / Abidjan" :
        tfrais=0;
        items=0;
        frais="1000 Fcfa/Commande";
        fraisPrix=1000;
        paymentMethod="Payez cash à la livraison.";
        totalBrut=0;
        for(var cm in cmds){
          totalBrut += (cm.price*cm.quantity);
          items+=cm.quantity;
        }
        total = totalBrut+1000;
        tfrais=1000;

        break;
      case "CIV / Autre":
        tfrais=0;
        items=0;
        totalBrut=0;
        frais="1000 Fcfa/Article";
        fraisPrix=1000;
        paymentMethod="Payement par mobile money";
        for(var cm in cmds){
          totalBrut += cm.price*cm.quantity;
          items+=cm.quantity;
        }

        total = totalBrut +(1000*items);
        tfrais=1000*items;
        break;
      case "Niamey(Niger)":
        tfrais=0;
        items=0;
        frais="1000 Fcfa/article";
        totalBrut=0;
        fraisPrix=1000;
        paymentMethod="Payement par mobile money.";
        for(var cm in cmds){
          totalBrut += (cm.price*cm.quantity);
          items+=cm.quantity;
        }

        total = totalBrut +(1000*items);
        tfrais=1000*items;

        break;
      case "Bamako(Mali)":
        tfrais=0;
        items=0;
        frais="1000 Fcfa/article";
        totalBrut=0;
        fraisPrix=1000;
        paymentMethod="Payement par mobile money.";
        for(var cm in cmds){
          totalBrut += (cm.price*cm.quantity);
          items+=cm.quantity;
        }

        total = totalBrut +(1000*items);
        tfrais=1000*items;

        break;
      case "Ouagadougou(Burkina Faso)":
        totalBrut=0;
        tfrais=0;
        items=0;
        frais="2000 Fcfa/article pour moins de 5 article.\n1500 Fcfa pour 5 et plus";
        for(var cm in cmds){
          totalBrut += (cm.price*cm.quantity);
          items+=cm.quantity;
        }
        paymentMethod="Payement par mobile money.";
        fraisPrix= (items>=5) ? 1500 : 2000;
        total = totalBrut +(fraisPrix*items);
        tfrais=fraisPrix*items;

        break;
      case "Dakar(Sénégal)":
        tfrais=0;
        items=0;
        totalBrut=0;
        frais="2800 Fcfa/article";
        fraisPrix=2800;
        paymentMethod="Payement par mobile money.";
        for(var cm in cmds){
          totalBrut += (cm.price*cm.quantity);
          items+=cm.quantity;
        }

        total = totalBrut +(2800*items);
        tfrais=2800*items;

        break;
      case "Brazzaville(Congo)":
        tfrais=0;
        items=0;
        totalBrut=0;
        frais="5000 Fcfa/article";
        fraisPrix=5000;
        paymentMethod="Payement par mobile money.";
        for(var cm in cmds){
          totalBrut += (cm.price*cm.quantity);
          items+=cm.quantity;
        }

        total = totalBrut +(5000*items);
        tfrais=5000*items;
        break;
      case "Paris(France)":
        tfrais=0;
        items=0;
        totalBrut=0;
        frais="5000 Fcfa/article";
        fraisPrix=5000;
        paymentMethod="Payement par mobile money.";
        for(var cm in cmds){
          totalBrut += (cm.price*cm.quantity);
          items+=cm.quantity;
        }

        total = totalBrut +(5000*items);
        tfrais=5000*items;
        break;
      case "Autre Lieu":
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context)=>NulPlace()),
            ModalRoute.withName('/'),
            );
        break;
      default:
    }
  });
}

void cm(){
  ft.then((data){ 
    setState((){
      visibleState=true;
    });
    var res= getProductFromDB(data[0].id);
    res.then((d){
      sendCommand(d,data[0].name,data[0].phone,dropdownValue, frais, paymentMethod,livraisonPlace,idCommand);
    });
    
  },onError: (e) {print(e);});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Detail du payement", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white), 
          onPressed: () {
            a.play("click.m4a");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder:(context)=>Basket()),
              ModalRoute.withName('/'),
            );
          },
        ), 
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:<Widget>[
           
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/7.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:<Widget>[
                  Text(
                    "Lieu de Livraison:",
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.green[300]),
                    underline: Container(
                      height: 2,
                      color: Colors.green[300],
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                          tfrais=0;
                          items=0;
                        dropdownValue = newValue;
                      });
                      selectController(dropdownValue);

                    },
                    items: <String>["--------------------------------------------","CIV / Abidjan","CIV / Autre", "Niamey(Niger)","Bamako(Mali)","Ouagadougou(Burkina Faso)","Dakar(Sénégal)","Brazzaville(Congo)","Paris(France)","Autre Lieu"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ]
              ),
            ),
            Container(width: MediaQuery.of(context).size.width,
              height:1, color: Colors.black12,
              margin: EdgeInsets.only(bottom:5),
            ),

             Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/6,
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Entrez le lieu de livraison",
                    style: TextStyle(
                      fontSize:14,
                      fontWeight: FontWeight.w400,
                      color: Colors.purple,
                    )
                  ),
                  Container(
                     width: MediaQuery.of(context).size.width,
                     height: 80,
                     padding: EdgeInsets.only(left:10, right: 10),
                     alignment: AlignmentDirectional.center,
                     //color: Colors.green[50],
                     child: TextFormField(
                       controller: livraisonPlaceController ,
                       decoration: InputDecoration(
                          hintText: '${(livraisonPlace==null)? "Entrez le lieu de livraison" : livraisonPlace}',
                          helperText: "Soyez très précis(e) ' ville, commune, quartier, rue'",
                          labelStyle: TextStyle(
                          ),
                        ),
                     ),
                  )
                ],
              ),
            ),
         
            
            Container(width: MediaQuery.of(context).size.width,
              height:1, color: Colors.black12,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/7.8,
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Méthodes de payement",
                    style: TextStyle(
                      fontSize:14,
                      fontWeight: FontWeight.w400,
                      color: Colors.purple,
                    )
                  ),
                  Container(
                     width: (MediaQuery.of(context).size.width/3)*2,
                     height: 40,
                     alignment: AlignmentDirectional.center,
                     color: Colors.green[50],
                     child: Text(
                       "${(paymentMethod== null) ? '' : paymentMethod}"
                     ),
                  )
                ],
              ),
            ),
         
            Container(width: MediaQuery.of(context).size.width,
              height:1, color: Colors.black12,
              margin: EdgeInsets.only(top:5, bottom:5),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/7.8,
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Frais de livraison",
                    style: TextStyle(
                      fontSize:14,
                      fontWeight: FontWeight.w400,
                      color: Colors.purple,
                    )
                  ),
                  Container(
                     width: (MediaQuery.of(context).size.width/3)*2,
                     height: 40,
                     alignment: AlignmentDirectional.center,
                     color: Colors.green[50],
                     child: Text(
                       "${(frais== null) ? '' : frais}",
                       style: TextStyle(
                         fontSize: 13,
                         color: Colors.black87
                       )
                     ),
                  )
                ],
              ),
            ),
         
           
            Container(width: MediaQuery.of(context).size.width,
              height:1, color: Colors.black12,
              margin: EdgeInsets.only(top:5, bottom:5),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: ((MediaQuery.of(context).size.height/7.8)*3)-135,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Total : $totalBrut Fcfa"
                        ),
                        Text(
                          "+"
                        ),
                        Text(
                          "Frais: $tfrais Fr pour $items produits"
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height:30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Total Définitif : $total Fcfa"
                        ),
                       
                      ],
                    ),
                  )
               
                ],
              ),
            ),
            Visibility(
              visible: visibleState,
              child: CircularProgressIndicator(
                backgroundColor: Colors.green[300],
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black12)
              ),
            ),
            Visibility(
                visible: !visibleState,
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top:5),
                    width: MediaQuery.of(context).size.width/2,
                    height: 40,
                    alignment: AlignmentDirectional.center,
                    color: Colors.purple,
                    child: Text(
                      "Valider l' achat",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  onTap: (){
                    a.play("click.m4a");
                    var s = livraisonPlaceController.text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                    if(dropdownValue=="--------------------------------------------"){
                      Fluttertoast.showToast(msg: "Vous n'avez choisi aucun lieu de livraison.",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Color(0xFFFFFFFF),
                        textColor: Color(0xFF333333));
                    }else if(livraisonPlaceController.text==""){
                      if(livraisonPlace==null || livraisonPlace==""){
                        Fluttertoast.showToast(msg: "Le champs lieu de livraison ne peut être vide ou contenir des espaces vides.",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Color(0xFFFFFFFF),
                          textColor: Color(0xFF333333));
                        }else{
                          cm();
                        }
                    }else{
                      setState((){
                        livraisonPlace=livraisonPlaceController.text;
                      });
                      dbHelper.updateLivraisonPlaceInfo(livraisonPlace, idCustomer);
                     cm();
                    }
                  },
              ),
            ),
          ]
        ),
      ),
    );
  }
}