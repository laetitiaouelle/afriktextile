import 'dart:convert';

import 'package:afriktextile/back_end/custModel.dart';
import 'package:afriktextile/back_end/dbhelper.dart';
import 'package:afriktextile/back_end/playsound.dart';
import 'package:afriktextile/views/buyingDetail.dart';
import 'package:afriktextile/views/function.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


var a=Audio();
var fc = FunctionOp(); 
var dbHelper = DBHelper();
var userPhone;
Future<List<Buyings>> fetchCom(var params) async {
  final response = await http.get('http://afriktextile.com/app/aftxl/requests/getAchat.php?num=$params');

  if (response.statusCode == 200) {
     return compute(parseBuyings, response.body);
  } else {
    
    throw Exception('Failed to load Buyings');
  }
}

List<Buyings> parseBuyings(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Buyings>((json) => Buyings.fromJson(json)).toList();
}


class Buying extends StatefulWidget {
  @override
  _BuyingState createState() => _BuyingState();
}

class _BuyingState extends State<Buying> {
  Future<List<Buyings>> futureBuying;
  var status, msg, color ;

  @override
  void initState() {
    super.initState();
    var ct = dbHelper.getCustomer();
    ct.then((data){
      setState((){
        userPhone = data[0].phone;
        futureBuying = fetchCom(userPhone);
      });
    });
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.green[300]), 
          onPressed: () {
            a.play("click.m4a");
            Navigator.pop(context);
          },
        ), 
        title: Text(
          "Mes Achats",
          style: TextStyle(color: Colors.green[300])
        ) ,
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body:WillPopScope(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          padding: EdgeInsets.only(
            top:10, left: 10, right: 10
          ),
          child: FutureBuilder<List<Buyings>>(
            future: futureBuying,
            builder:(context, snapshot) {
              if(snapshot.data != null){
                if (snapshot.hasData) {
                  
                  if(snapshot.data.length==0){
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                          Image(
                            image: AssetImage("assets/images/timer.png"),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom:15),
                            child: Text(
                              "Vide",
                              style: TextStyle(
                                color: Colors.green[300],
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],)
                      ),
                                          ); 
                                      
                  }else{
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        if(snapshot.data[index].isValidate == "0" && snapshot.data[index].isTerminated=="0"){
                          status = "En cours"; msg="Afrik Textile n'a pas encore vu votre commande"; color= Colors.black;
                        }else if(snapshot.data[index].isValidate == "1" && snapshot.data[index].isTerminated=="0"){
                          status = "En traitement"; msg="Afrik Textile a vu votre commande"; color= Colors.blue[200];
                        }else if(snapshot.data[index].isValidate == "1" && snapshot.data[index].isTerminated=="1"){
                          status="Livrée"; msg="Vous avez reçu votre commande"; color= Colors.green[200];
                        }
                        return Card( //                           <-- Card widget
                          child: ListTile(
                            leading: CircleAvatar(
                              child: CachedNetworkImage(
                                imageUrl: "http://afriktextile.com/app/aftxl/requests/getImage.php?id_prod=${snapshot.data[index].idProd}&id_im=${snapshot.data[index].idImage}",
                                placeholder:(context, url)=>Container( child:Center(child:new CircularProgressIndicator(backgroundColor: Colors.green[200],))),
                                errorWidget:(context, url,error)=>Container( child:Center(child:new Icon(Icons.error))),
                                fadeInCurve: Curves.easeIn,
                                fadeInDuration: Duration(milliseconds: 1000),
                                imageBuilder: (context, imageProvider)=>Center( child:Image(image: imageProvider,)),
                              ),
                            ),
                            title: Text('Quantité: ${snapshot.data[index].qty} Pagne(s)'),
                            subtitle: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[ 
                                        Text('ID: '),
                                        Text(
                                          '${snapshot.data[index].idCommand}',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Statut : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "$status",
                                          style: TextStyle(
                                            color: color,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top:11),
                                    child: Text(
                                      "$msg",
                                      style: TextStyle(
                                        color: color
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=> BuyDetails(idCommand: snapshot.data[index].idCommand)),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                  child:Text("Error"),
                  );
                }
              }else{
                // By default, show a loading spinner.
                return Center(
                  child:CircularProgressIndicator(
                    backgroundColor: Colors.green[300],
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[50])
                  ),
                );
              }
            },
          ),
        ),
        onWillPop: fc.onWillPop,
      ),
    );
  }
}