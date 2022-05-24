import 'dart:convert';
import 'package:afriktextile/back_end/dbhelper.dart';
import 'package:afriktextile/back_end/playsound.dart';
import 'package:afriktextile/views/function.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:afriktextile/back_end/custModel.dart';
import 'package:http/http.dart' as http;
var a=Audio();
var fc = FunctionOp(); 
var dbHelper = DBHelper();

  
  Future<List<BuyingsDetails>> fetchCom(var params) async {
    final response = await http.get('http://afriktextile.com/app/aftxl/requests/getAchat.php?idcom=$params');

    if (response.statusCode == 200) {
      return compute(parseBuyings, response.body);
    } else {
      
      throw Exception('Failed to load Buyings');
    }
  }

  List<BuyingsDetails> parseBuyings(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<BuyingsDetails>((json) => BuyingsDetails.fromJson(json)).toList();
}


class BuyDetails extends StatefulWidget {
  final idCommand;
  BuyDetails({Key key, @required this.idCommand}) : super(key: key);
  @override
  _BuyDetailsState createState() => _BuyDetailsState(idCommand: idCommand);
}

class _BuyDetailsState extends State<BuyDetails> {
  final idCommand;
  _BuyDetailsState({Key key, @required this.idCommand});

  Future<List<BuyingsDetails>> futureBuyingsDetails;

  @override
  void initState() { 
    super.initState();
    futureBuyingsDetails=fetchCom(idCommand);
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
          "Détail commande",
          style: TextStyle(color: Colors.green[300])
        ) ,
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height:  MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: EdgeInsets.only(top:10, left:10, right:10),
        child: FutureBuilder<List<BuyingsDetails>>(
          future: futureBuyingsDetails,
          builder: (context, snapshot){
            if(snapshot.data != null){
              if(snapshot.hasData){
                if(snapshot.data.length==0){
                  return Center(
                    child:Text("Aucune données"),
                  );
                }else{
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return _checkBox(context, snapshot.data[index] );
                    }
                  );
                }
              }else if(snapshot.hasError){
                return Center(
                  child:Text("Error"),
                );
              }
            }else{
              return Center(
                child:CircularProgressIndicator(
                  backgroundColor: Colors.green[300],
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[50])
                ),
              );
            }
          }
        ),
      ),
    );
  }
}

Widget _checkBox(BuildContext context, BuyingsDetails dt) {
  return Container(
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    height: (MediaQuery.of(context).size.height/2)-20,
    width:MediaQuery.of(context).size.width-20,
    decoration: new BoxDecoration( 
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          blurRadius: 3.0,
          color: Colors.black26
        )
      ],
    ),
    child: Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width:(MediaQuery.of(context).size.width-40)/2,
                height: (MediaQuery.of(context).size.height/2)-85,
                margin: EdgeInsets.only(bottom: 5.0),
                decoration: new BoxDecoration( 
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Colors.black26
                      )
                    ],
                  ),
                child:  Container(
                  child: CachedNetworkImage(
                    imageUrl: "http://afriktextile.com/app/aftxl/requests/getImage.php?id_prod=${dt.idProd}&id_im=${dt.idImage}",
                    placeholder:(context, url)=>Container( child:Center(child:new CircularProgressIndicator(
                      backgroundColor: Colors.green[300],
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[50])
                    ))),
                    errorWidget:(context, url,error)=>Container( child:Center(
                      child:new Icon(Icons.error, color: Colors.green[300])
                      )),
                    fadeInCurve: Curves.easeIn,
                    fadeInDuration: Duration(milliseconds: 1000),
                    imageBuilder: (context, imageProvider)=>Center( child:Image(image: imageProvider,)),
                  ),
                ),
              ),
              Container(
                width:(MediaQuery.of(context).size.width-80)/2,
                height: (MediaQuery.of(context).size.height/2)-80,
                padding: EdgeInsets.only(left: 15),
                //alignment: AlignmentDirectional.center,
                //color: Colors.pink,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Quantité: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                            color: Colors.green[300]
                          ),
                        ),
                        Text(
                          "${dt.productQty}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 21,
                            color: Colors.purple
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Prix: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                            color: Colors.green[300]
                          ),
                        ),
                        Text( 
                          "${double.parse(dt.productQty).round() * double.parse(dt.productPrice).round()} Fr",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                            color: Colors.purple
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Calcul: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${dt.productQty} X ${dt.productPrice} Fr"
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width:MediaQuery.of(context).size.width-20,
          alignment: AlignmentDirectional.center,
          child: Text(
            "${dt.productName}",
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    )
  );
}