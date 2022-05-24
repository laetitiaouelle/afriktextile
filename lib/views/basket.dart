import 'package:afriktextile/back_end/playsound.dart';
import 'package:afriktextile/views/buying.dart';
import 'package:afriktextile/views/home.dart';
import 'package:afriktextile/views/payementDetail.dart';
import 'package:afriktextile/back_end/custModel.dart';
import 'package:afriktextile/back_end/dbhelper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:afriktextile/views/function.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

var a=Audio();
var fc = FunctionOp(); 
var dbHelper = DBHelper();

var idCommand="${randomAlphaNumeric(10)}AFRIKTEXTILE${randomBetween(100, 20000)}";

class Basket extends StatefulWidget{

@override
BasketState createState() => BasketState();

}

class BasketState extends State<Basket>{
//////////////////////////////////////////////////////////////////////////////////////////////////////////////



Future<List<Commande>> getProductFromDB(int id) async{   
    var dbHelper = DBHelper();
    Future <List<Commande>> products= dbHelper.getProducts('Commandes',id);
    return products;
  }
var ft = dbHelper.getCustomer();
int nb=0; int tprice=0;
var items=0; int prices=0;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@override
  void initState() {
    super.initState();
    idCommand="${randomAlphaNumeric(10)}AFRIKTEXTILE${randomBetween(100, 20000)}";
    print("current CID: $idCommand");
    ft.then((data){ 
     getProductFromDB(data[0].id).then((val){
       for(var i in val){
         prices += (i.quantity*i.price);
       }
       setState((){
         items=val.length;
         tprice=prices;
       });
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
                 Navigator.pushAndRemoveUntil(
                   context, 
                   MaterialPageRoute(builder: (context)=>Home()),
                   ModalRoute.withName('/'),
                 );
               },
              ), 
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Text("Mon panier", style: TextStyle(color: Colors.green[300]),),
      ),
      body: WillPopScope(
        child:Container(
              width: MediaQuery.of(context).size.width,
              height : MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height:100,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap:(){a.play("click.m4a"); Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context)=> Buying()),
                              ); 
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width/4,
                              height:50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green[100], width:2, style:BorderStyle.solid),
                                borderRadius: BorderRadius.circular(50),
                                /*boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(.1),
                                    offset: Offset(6.0, 7.0),
                                  ),
                                ],*/
                              ),
                              alignment: AlignmentDirectional.center,
                              child: Text("Mes achats", style: TextStyle(color: Colors.green[300],)),
                            )
                          ),

                          Container(
                            width: (MediaQuery.of(context).size.width/4)*2.5,
                            height:100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.purple[100], width:2, style:BorderStyle.solid), 
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green[300],
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(.1),
                                    offset: Offset(6.0, 7.0),
                                  ),
                                ],
                            ),
                            
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "$items article(s)",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300
                                  ),
                                ),
                                Text(
                                  "Total: $tprice Fcfa",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300
                                  ),
                                )
                              ],
                            ),
                          ),
                        ]
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height : MediaQuery.of(context).size.height-230,
                    child: Container(
                      child: FutureBuilder<List<Commande>>(
                        future:  ft.then((data){ 
                          return getProductFromDB(data[0].id); 
                          }
                          ,onError: (e) {print(e);}),
                        builder: (context, snapshot){
                          if(snapshot.data != null){
                            if(snapshot.hasData){
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context,index){
                                  nb=snapshot.data.length;
                                  tprice=0;
                                  for (var item in snapshot.data) {
                                        tprice+=(item.price*item.quantity); 
                                  }
                                  return Container(
                                    child:Column(
                                          children : <Widget>[
                                              Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height : MediaQuery.of(context).size.height/4,
                                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(context).size.width/3,
                                                        //height : MediaQuery.of(context).size.height-180,
                                                      child : CachedNetworkImage(
                                                          imageUrl: "http://afriktextile.com/app/aftxl/requests/getImage.php?id_prod=${snapshot.data[index].prodId}&id_im=${snapshot.data[index].image}",
                                                          placeholder:(context, url)=>Container( child:Center(child:new CircularProgressIndicator(backgroundColor: Colors.green[200],))),
                                                          errorWidget:(context, url,error)=>Container( child:Center(child:new Icon(Icons.error))),
                                                          fadeInCurve: Curves.easeIn,
                                                          fadeInDuration: Duration(milliseconds: 1000),
                                                          imageBuilder: (context, imageProvider)=>Center( child:Image(image: imageProvider,)),
                                                        ),
                                                      ),
                                                    Container(
                                                        width: (MediaQuery.of(context).size.width/3)*2,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children : <Widget>[
                                                                  Container(
                                                                    alignment: AlignmentDirectional.center,
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    child:Text(
                                                                      "${snapshot.data[index].name}",
                                                                       maxLines: 2,
                                                                       style: TextStyle(
                                                                         fontWeight: FontWeight.w300,
                                                                       ),
                                                                      ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: (){
                                                                    var dbHelper = DBHelper();
                                                                    dbHelper.deleteCommand(snapshot.data[index].id,'Commandes');
                                                                    Fluttertoast.showToast(msg: 'Supprimer du panier', toastLength: Toast.LENGTH_SHORT, backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                                                                      ft.then((data) async{ 
                                                                        await Future.delayed(Duration(milliseconds: 100));
                                                                        getProductFromDB(data[0].id).then((val){
                                                                          prices=0;
                                                                          for(var i in val){
                                                                            prices += (i.quantity*i.price);
                                                                          }
                                                                          setState((){
                                                                            items=val.length;
                                                                            tprice=prices;
                                                                          });
                                                                        }); 
                                                                        }
                                                                        ,onError: (e) {print(e);});
                                                                    },
                                                                    child: Icon(Icons.close, color: Colors.red[200]),
                                                                  )
                                                                ]
                                                              ),
                                                            ),
                                                            
                                                            Container(
                                                              //width: (MediaQuery.of(context).size.width/3)+47,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(color: Colors.green[100], width:2, style:BorderStyle.solid),
                                                                borderRadius: BorderRadius.circular(50),
                                                                color: Colors.white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    blurRadius: 3.0,
                                                                    color: Colors.black.withOpacity(.1),
                                                                    offset: Offset(6.0, 7.0),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Row(
                                                                    children: <Widget>[
                                                                      IconButton(icon: Icon(Icons.remove_circle_outline, color: Colors.red[200]), onPressed: (){
                                                                        dbHelper.updateCommandQty('-',snapshot.data[index].id);
                                                                        setState((){
                                                                          ft.then((data){ 
                                                                            return getProductFromDB(data[0].id); 
                                                                            });
                                                                        });
                                                                        ft.then((data) async{ 
                                                                          await Future.delayed(Duration(milliseconds: 100));
                                                                          getProductFromDB(data[0].id).then((val){
                                                                            prices=0;
                                                                            for(var i in val){
                                                                              prices += (i.quantity*i.price);
                                                                            }
                                                                            setState((){
                                                                              items=val.length;
                                                                              tprice=prices;
                                                                            });
                                                                          }); 
                                                                          }
                                                                          ,onError: (e) {print(e);}
                                                                        );

                                                                      }),
                                                                      Text('${snapshot.data[index].quantity}'),
                                                                      IconButton(icon: Icon(Icons.add_circle_outline, color: Colors.green[300]), onPressed: (){
                                                                        dbHelper.updateCommandQty('+',snapshot.data[index].id);
                                                                        setState((){
                                                                          ft.then((data){ 
                                                                            getProductFromDB(data[0].id); 
                                                                            });
                                                                        });
                                                                       ft.then((data) async{ 
                                                                          await Future.delayed(Duration(milliseconds: 100));
                                                                          getProductFromDB(data[0].id).then((val){
                                                                            prices=0;
                                                                            for(var i in val){
                                                                              prices += (i.quantity*i.price);
                                                                            }
                                                                            setState((){
                                                                              items=val.length;
                                                                              tprice=prices;
                                                                            });
                                                                          }); 
                                                                          }
                                                                          ,onError: (e) {print(e);}
                                                                      );
                                                                      })
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(right:10),
                                                                    child: Text(
                                                                      "${snapshot.data[index].price*snapshot.data[index].quantity} Fcfa"
                                                                    )
                                                                  )
                                                                ]
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                    )
                                                  ],
                                                ) ,
                                              )               
                                          ]
                                    )
                                    );
                                },
                              );
                            }else{
                              return Center(
                                child: Text("Votre panier est vide"),
                              );
                            }
                          }else{
                            return new Center( 
                                child: Container(
                                alignment: AlignmentDirectional.center,
                                child: CircularProgressIndicator(),
                              )
                            );
                          }
                        }
                      ),
                    ),
                  ),
                  InkWell(
                    child:Container(
                      width: MediaQuery.of(context).size.width,
                      height:50,
                      color:Colors.green[300],
                      alignment: Alignment.center,
                      child: Text(
                        "PROCEDER AU PAYEMENT",
                        style: TextStyle(
                          fontSize:20,
                          fontWeight : FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                    onTap: (){
                      a.play("click.m4a");
                      ft.then((data){ 
                       var pds=getProductFromDB(data[0].id);
                       pds.then((dt){
                        if(dt.length != 0){
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(builder: (context)=>PayementDetail()),
                            ModalRoute.withName('/'),
                            );
                        }else{
                          Fluttertoast.showToast(msg: 'Opération Impossible car votre panier est vide.',
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Color(0xFFFFFFFF),
                          textColor: Color(0xFF333333));
                        }
                         
                         /*return Alert(
                          context: context,
                          title: "$total Fcfa",
                          desc: "Le montant de vos achats.",
                          //image: Image.asset("assets/success.png"),
                          closeFunction: (){Navigator.pop(context);},
                          buttons: [
                            DialogButton(
                              color: Colors.green[300],
                              child: Text(
                                "PASSER LA COMMANDE",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                //on envoie la commande
                                cm();
                              },
                              
                            ),
                          ],
                        ).show();*/
                       });
                      }
                      ,onError: (e) {print(e);});
                    },
                  )
                ],
              )
         ),
         onWillPop: fc.onWillPop
      )
    );
  }
}
