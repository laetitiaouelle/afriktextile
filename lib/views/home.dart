import 'package:afriktextile/back_end/custModel.dart';
import 'package:afriktextile/back_end/dbhelper.dart';
import 'package:afriktextile/back_end/playsound.dart';
import 'package:afriktextile/main.dart';
import 'package:afriktextile/views/basket.dart';
import 'package:afriktextile/views/buying.dart';
import 'package:afriktextile/views/settings.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:afriktextile/views/waiting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'basket.dart';
import 'package:afriktextile/views/function.dart';

var dbHelper = DBHelper(); 
var fc = FunctionOp();
var db= DBHelper();
var a=Audio();
var rechercheController = TextEditingController();
bool visible = false ;
List<Products> finalDataList=[];

 Future <List<Products>> _fetchPage(http.Client c, int m, String table) async {
      var pr=db.getLocalJson(table);
      return pr.then((v){
        return v;
      });
  }

  void fetchNew(String table, int mod){
      var res = fetchProducts(http.Client(), mod );
      res.then((val) async {
        for (var v in val) {
          await Future.delayed(Duration(milliseconds: 100));
          db.addJsonData(v, table); 
        }
      });
   }

   void fetchNewSpecific(String table, int mod){
      var res = fetchProducts(http.Client(), mod );
      res.then((val) async {
        for (var v in val) {
          await Future.delayed(Duration(milliseconds: 100));
          db.addJsonData(v, table); 
        }
      });
   }

  Future<List<Products>> fetchProducts(http.Client client, int mod ) async {
  final response =
      await client.get('http://afriktextile.com/app/aftxl/requests/get_products.php?id_category=$mod');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseProducts, response.body);
}
Future<List<Commande>> getProductFromDB(int id) async{   
    
    Future <List<Commande>> products= dbHelper.getProducts('Commandes',id);
    return products;
  }
// A function that converts a response body into a List<Photo>.
List<Products> parseProducts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Products>((json) => Products.fromJson(json)).toList();
}

Future<List<Commande>>getWish(int id){
    Future <List<Commande>> wishies= dbHelper.getProducts('Wishlist',id);
    return wishies;
}
wait() async{
  await Future.delayed(Duration(milliseconds: 5000));
}

bool isLoadFinished=true;

  class Home extends StatefulWidget {
    Home({Key key}) : super(key: key);
  
    @override
    _HomeState createState() => _HomeState();
  }
  
  class _HomeState extends State<Home> {
    var pr, pf, pi, x;
    Future <List<Products>> product;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    
    logOut(){
    dbHelper.deleteConnectedUser("Customer");
    Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp()));
    }
    var items=0;
    @override
    void initState() {
      super.initState();
      var ct = dbHelper.getCustomer();
      ct.then((data) {
          getProductFromDB(data[0].id).then((i){
            setState((){items=i.length;});         
          }); 
        }, onError: (e) {
            print(e);
          });
    }
  
    @override
    Widget build(BuildContext context) {
      return DefaultTabController(
        length: 13,
        child:Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black87,
            elevation: 0,
            title: Container(
              height: 33 ,
              decoration: new BoxDecoration(
                //color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                   image: AssetImage("assets/images/launcher_icon.png"),
                  ),
                  Container(
                    margin: EdgeInsets.only(left:15),
                    child: Text(
                      "Afriktextile.com",
                      style: TextStyle(
                        fontSize:13,
                        color: Colors.green[300]
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
             InkWell(
                child: Container(
                  width:26,
                 height: 26,
                  child: Image(
                    image: AssetImage("assets/images/shopping.png"),
                  ),
                ),
                onTap: () {
                  a.play("click.m4a");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> Buying()),
                  );
                },
              ),
              SizedBox(width: 20),
              InkWell(
                child: Container(
                  width:26,
                  height: 26,
                  child: Image(
                    image: AssetImage("assets/images/user.png"),
                  ),
                ),
                onTap: () {
                  a.play("click.m4a");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Settings()));
                }
              ),
              SizedBox(width: 20),
              
              InkWell(
                child: Icon(Icons.power_settings_new, color: Colors.red[200]),
                onTap: () {
                  a.play("click.m4a");
                  Alert(
                    context: context,
                    title: "Attention !",
                    desc: "Appuyer sur Déconnexion pour fermer votre session!",
                    //image: Image.asset("assets/success.png"),
                    closeFunction: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));},
                    buttons: [
                      DialogButton(
                        color: Colors.red[200],
                        child: Text(
                          "Déconnexion",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          //on envoie la commande
                          logOut();
                        },
                        
                      ),
                    ],
                  ).show();
                },
              ),
              SizedBox(width: 20)
            ],
            bottom: PreferredSize(
                  child: TabBar(
                      onTap: (val){finalDataList=[];},
                      isScrollable: true,
                      unselectedLabelColor: Colors.white.withOpacity(0.5),
                      indicatorColor: Colors.green[300],
                      tabs: [
                        Tab(text: 'Hollandais'),
                        Tab(text: 'Uniwax Block', ),
                        Tab(text: 'Pagne 8mars', ),
                        Tab(text: 'Fête des mères', ),
                        Tab(text: 'Chiganvy 2tons'),
                        Tab(text: 'Woodin'),
                        Tab(text: 'Uniwax Print'),
                        Tab(text: 'Hollantex'),
                        Tab(text: 'Chiganvy Uni'),
                        Tab(text: 'Hitarget'),
                        Tab(text: 'Hitarget 2 tons'),
                        Tab(text: 'Wax Super'),
                        Tab(text: 'ABC'),
                            ]),
                  preferredSize: Size.fromHeight(50.0)),
          ),
          body: WillPopScope(
            child:TabBarView(
              physics: NeverScrollableScrollPhysics(),
                  children: [
                    pagewiseGridView(context,98,"hollandais"),
                    pagewiseGridView(context,198,"uniwaxblock"),
                    pagewiseGridView(context,200,"p8mars"),
                    pagewiseGridView(context,229,"fdm"), 
                    pagewiseGridView(context,97,"ch2tons"),
                    pagewiseGridView(context,77,"woodin"),
                    pagewiseGridView(context,78,"uniwaxprint"),
                    pagewiseGridView(context,218,"Hollantex"),
                    pagewiseGridView(context,181,"chuni"),
                    pagewiseGridView(context,84,"hitarget"),
                    pagewiseGridView(context,230,"hitarget2tons"),
                    pagewiseGridView(context,197,"waxsuper"),
                    pagewiseGridView(context,228,"ABC"),

                  ],
              ),
              onWillPop: fc.onWillPop
            )
          )
        
      );
    }
Widget _checkBox(BuildContext context, Products item, int cat ) {
    
      if(item.reduction == null || item.reduction ==""){

      }else{
      }
    return Container(
              height: (MediaQuery.of(context).size.height/2)-20,
              width:((MediaQuery.of(context).size.width)-30)/2,
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
                    height: ((MediaQuery.of(context).size.height/2)-20)/2,
                    width:((MediaQuery.of(context).size.width)-30)/2,
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(214,214,214,0.25),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10) , topRight:  Radius.circular(10)) ,
                    ),
                    child: Stack(
                      children: <Widget>[
                        //
                        CachedNetworkImage(
                            imageUrl: "http://afriktextile.com/app/aftxl/requests/getImage.php?id_prod=${item.id}&id_im=${item.image}",
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
                        if(item.reduction !="0")
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                width: 70,
                                height: 25,
                                decoration : new BoxDecoration(
                                  color: (item.quantity=="0"?Color.fromRGBO(249, 154, 11, 0.73): Colors.green[300]),
                                  borderRadius : BorderRadius.circular(7),
                                ),
                                child: Center(
                                  child: Text(
                                    '${- ((double.parse(item.reduction)*100)/double.parse(item.price)).round()} %',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: (item.quantity=="0"?9:10)
                                    ),
                                ) ,
                                )
                                ),
                            )
                        

                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom:3),
                        width:((MediaQuery.of(context).size.width)-40)/2,
                        child:
                          Center(
                          child:  Text(
                          '${item.name}',
                          
                          maxLines:3,
                          style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'Bellota'
                                ),
                        ),
                        ),
                      ),
                      Container(
                      margin: EdgeInsets.only(bottom:3),
                      width:((MediaQuery.of(context).size.width)-40)/2,
                      child: Text(
                        '${double.parse(item.price).round() - double.parse(item.reduction).round()} fcfa',
                        style: TextStyle(
                                color: Color.fromRGBO(232, 135, 25, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                      ) ,
                    ),
                    if(item.reduction != "0") 
                      Container(
                        //margin: EdgeInsets.only(bottom:10),
                        width:((MediaQuery.of(context).size.width)-40)/2,
                        child: Text(
                          "${double.parse(item.price).round()} Fcfa",
                          style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough
                                  //fontFamily: 
                                ),
                        ) ,
                      ),
                      
                    Container(
                      width:((MediaQuery.of(context).size.width)-40)/2,
                      child: Text(
                        "${(cat!=98 && cat!=198)? ((item.quantity=="0")?'Commande Impossible' :'Commande Possible') :'Commande Possible'}",
                        style: TextStyle(
                                color: ((cat!=98 && cat!=198)? ((item.quantity=="0")?Colors.red[300]:Colors.green[300] ) : Colors.green[300]),
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                              ),
                      ) ,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            //height: 20,
                            child: Text(
                              "${(item.quantity==null || item.quantity=="0") ? 'Stock épuisé' : 'En stock'}",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                        ),
                        Container(
                          height: 20,
                          child: IconButton(
                            onPressed: (){
                              a.play("click.m4a");
                              var dbHelper = DBHelper();
                              var ct = dbHelper.getCustomer();
                              ct.then((data) {
                                //item.price
                                item.price="${double.parse(item.price) - double.parse(item.reduction)}";
                                dbHelper.addNewCommand(item,'Commandes', data[0].id);
                                Fluttertoast.showToast(msg: 'Ajouté au panier !', toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                              }, onError: (e) {
                                  
                                });
                              ct.then((data) async{
                                await Future.delayed(Duration(milliseconds: 500));
                                    getProductFromDB(data[0].id).then((i){
                                      setState((){
                                      items=i.length;
                                      
                                      });
                                    }); 
                                  }, onError: (e) {
                                      print(e);
                              });
                            },
                            icon: Icon(Icons.add_shopping_cart, color: Color.fromRGBO(232, 135, 25, 1),),
                          ),
                        )
                      ]
                    )

                      ],
                    ),
                  ),
  
],
),
);
}
Widget _checkBoxError(BuildContext context) {
    return Container(
  height: (MediaQuery.of(context).size.height/1.5)-20,
  width:((MediaQuery.of(context).size.width)-30)/2,
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
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: <Widget>[
  
  Container(
    height: ((MediaQuery.of(context).size.height/2)-20)/2,
    width:((MediaQuery.of(context).size.width)-30)/2,
    padding: EdgeInsets.all(10),
    decoration: new BoxDecoration(
      color: Color.fromRGBO(214,214,214,0.25),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10) , topRight:  Radius.circular(10)) ,
    ),
    child: Stack(
      children: <Widget>[
          Center(
            child:Icon(Icons.error_outline, color: Colors.green[300])
          ),
          ],
    ),
  ),
  
],
),
);
}

Widget _checkBoxNull(BuildContext context) {
        return Container(
  height: (MediaQuery.of(context).size.height/2)-20,
  width:((MediaQuery.of(context).size.width)-30)/2,
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
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      
      Container(
        height: ((MediaQuery.of(context).size.height/2)-20)/2,
        width:((MediaQuery.of(context).size.width)-30)/2,
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(
          color: Color.fromRGBO(214,214,214,0.25),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10) , topRight:  Radius.circular(10)) ,
        ),
        child: Stack(
          children: <Widget>[
              Center(child:CircularProgressIndicator(
                backgroundColor: Colors.green[300],
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[50])
              
              ))
             ],
        ),
      ),
      
    ],
  ),
);
}


Widget pagewiseGridView(BuildContext context, int cat, String table) {
 
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-133,
                //margin: EdgeInsets.only(top:13, bottom:20),
                          child: FutureBuilder <List<Products>>(
                                future: _fetchPage(http.Client(),cat,table),
                                builder: (context, snapshot) {
                                   print(cat);
                                  if(snapshot != null){
                                    if (snapshot.hasData) {
                                     print(snapshot.data.length);
                                      var initiaDatalList = snapshot.data;
                                      void loadNextData() {
                                        final initialIndex = finalDataList.length;
                                        final finalIndex = finalDataList.length + 4;
                                        print('load data from ${finalDataList.length}');

                                        Future.delayed(Duration(seconds: 3), () {
                                          for (var i = initialIndex; i < finalIndex; ++i) {
                                            finalDataList.add(initiaDatalList[i]);
                                          }
                                          
                                          setState(() {
                                            print('${finalDataList.length} data now ---');
                                          });
                                        });
                                      }
                                        if(snapshot.data.length==0){
                                          fetchNewSpecific(table, cat);
                                          return Container(
                                             color: Colors.white,
                                             child: Center(
                                               child: Column(
                                                 mainAxisAlignment: MainAxisAlignment.start,
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
                                                 InkWell(
                                                   onTap: (){
                                                    Navigator.pushAndRemoveUntil(
                                                      context, 
                                                      MaterialPageRoute(builder: (context)=> Waiting()),
                                                      ModalRoute.withName('/'),
                                                    );
                                                   },
                                                   child: Container(
                                                     width: 170,
                                                     height: 58,
                                                     decoration: new BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30),
                                                      color: Colors.green[300],
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 3.0,
                                                            color: Colors.black.withOpacity(.1),
                                                            offset: Offset(6.0, 7.0),
                                                          ),
                                                        ],
                                                      ),
                                                     child: Row(
                                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                       children: <Widget>[
                                                       Container(
                                                          child: Text(
                                                           "Recharge Manuelle",
                                                           style: TextStyle(
                                                             color: Colors.white,
                                                             fontWeight: FontWeight.w300,
                                                             fontSize: 15,
                                                           ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Icon(
                                                            Icons.refresh,
                                                            color: Colors.white
                                                          ),
                                                        ),
                                                     ],)
                                                   )
                                                 )
                                               ],)
                                             ),
                                            ); 
                                        
                                        }else{
                                          return Container(
                                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                                  child: InfiniteGridView(
                                                          loadingWidget: Container(
                                                            width: MediaQuery.of(context).size.width,
                                                            alignment: Alignment.center,
                                                            child: CircularProgressIndicator(
                                                                backgroundColor: Colors.green[300],
                                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[50])
                                                              ),
                                                          ) ,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: 2,
                                                                childAspectRatio: 0.6 ,
                                                                mainAxisSpacing: 10.1,
                                                                crossAxisSpacing: 10.1,
                                                              ),
                                                          itemBuilder: (context, index) {
                                                            if(finalDataList[index].quantity=="0"){
                                                              if(cat!=198 && cat!=98){
                                                                return _checkBox(context,finalDataList[index],cat);
                                                              }else{
                                                                return InkWell(
                                                                      child:_checkBox(context,finalDataList[index], cat),
                                                                      onTap:(){
                                                                         showBottomSheet(
                                                                          context: context,
                                                                          builder: (builder){
                                                                            return Scaffold(
                                                                              key: _scaffoldKey,
                                                                              drawer: Drawer(
                                                                                elevation: 2.2,
                                                                                child: Container(
                                                                                  width: MediaQuery.of(context).size.width-50,
                                                                                  padding: EdgeInsets.all(15),
                                                                                  child: Column(
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        "${finalDataList[index].name} \n"
                                                                                      ),
                                                                                      Text(
                                                                                        "${finalDataList[index].descriptionShort} \n \n"
                                                                                      ),
                                                                                      Text(
                                                                                        "NB:\nCe produit n'est plus en stock mais peut être commandé car le stock sera bientôt ravitaillé. \n",
                                                                                        style: TextStyle(
                                                                                          color: Colors.red[200]
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              body: new Container(
                                                                                height: MediaQuery.of(context).size.height,
                                                                                width: MediaQuery.of(context).size.width,
                                                                                color: Colors.black87, //could change this to Color(0xFF737373), 
                                                                                          //so you don't have to change MaterialApp canvasColor
                                                                                child: new Container(
                                                                                    decoration: new BoxDecoration(
                                                                                        color: Colors.white,
                                                                                        borderRadius: new BorderRadius.only(
                                                                                            topLeft: const Radius.circular(40.0),
                                                                                            topRight: const Radius.circular(40.0))),
                                                                                    child: new Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: <Widget>[
                                                                                        Container(
                                                                                          height: MediaQuery.of(context).size.height/2,
                                                                                          width: MediaQuery.of(context).size.width,
                                                                                          child: Stack(
                                                                                            children: <Widget>[
                                                                                              CachedNetworkImage(
                                                                                              imageUrl: "http://afriktextile.com/app/aftxl/requests/getImage.php?id_prod=${finalDataList[index].id}&id_im=${finalDataList[index].image}",
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
                                                                                            Positioned(
                                                                                              left: 20,
                                                                                              top: 10,
                                                                                              child: InkWell(
                                                                                                child: Container(
                                                                                                  height:40,
                                                                                                  width: 40,
                                                                                                  decoration: new BoxDecoration(
                                                                                                    color: Colors.green[100],
                                                                                                    borderRadius: new BorderRadius.all(Radius.circular(40.0))
                                                                                                  ),
                                                                                                  child: Icon(
                                                                                                    Icons.close,
                                                                                                    color: Colors.red[300]
                                                                                                  ),
                                                                                                ),
                                                                                                onTap: ()=> Navigator.pop(context),
                                                                                              ),
                                                                                            )
                                                                                            ] 
                                                                                          ),
                                                                                        ),
                                                                                        Container(
                                                                                          height: 50,
                                                                                          padding: EdgeInsets.only(left:10, right:10),
                                                                                          width: MediaQuery.of(context).size.width,
                                                                                          child: Row(
                                                                                            children:<Widget>[
                                                                                              Container(
                                                                                                width: (MediaQuery.of(context).size.width/2)-10,
                                                                                                child: Text(
                                                                                                  "${double.parse(finalDataList[index].price).round() - double.parse(finalDataList[index].reduction).round()} Fcfa",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 23,
                                                                                                    color: Colors.green[300]
                                                                                                  ),
                                                                                                )
                                                                                              ),
                                                                                              InkWell(
                                                                                                child: Container(
                                                                                                  width: (MediaQuery.of(context).size.width/2)-10,
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                    children: <Widget>[
                                                                                                      Text("Détails"),
                                                                                                      Icon(
                                                                                                        Icons.arrow_forward,
                                                                                                        color: Colors.black54
                                                                                                      )
                                                                                                    ]
                                                                                                  ),
                                                                                                ),
                                                                                                onTap: () => _scaffoldKey.currentState.openDrawer(),
                                                                                              ),
                                                                                            ]
                                                                                          ),
                                                                                      ),
                                                                                      InkWell(
                                                                                        onTap: (){
                                                                                          a.play("click.m4a");
                                                                                          var dbHelper = DBHelper();
                                                                                          var ct = dbHelper.getCustomer();
                                                                                          ct.then((data) {
                                                                                            finalDataList[index].price="${double.parse(finalDataList[index].price) - double.parse(finalDataList[index].reduction)}";
                                                                                            dbHelper.addNewCommand(finalDataList[index],'Commandes', data[0].id);
                                                                                            Fluttertoast.showToast(msg: 'Ajouté au panier !', toastLength: Toast.LENGTH_SHORT,
                                                                                              backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                                                                                          }, onError: (e) {
                                                                                              print(e);
                                                                                          });
                                                                                          ct.then((data) async{
                                                                                            await Future.delayed(Duration(milliseconds: 500));
                                                                                                getProductFromDB(data[0].id).then((i){
                                                                                                  setState((){
                                                                                                  items=i.length;
                                                                                                  });
                                                                                                }); 
                                                                                              }, onError: (e) {
                                                                                                  print(e);
                                                                                          });

                                                                                          Future.delayed(Duration(seconds: 1), () {
                                                                                            Navigator.pop(context);
                                                                                          });
                                                                                        },
                                                                                        child:Container(
                                                                                          width: MediaQuery.of(context).size.width,
                                                                                          height:50,
                                                                                          color:Colors.green[300],
                                                                                          alignment: Alignment.center,
                                                                                          child: Text(
                                                                                            "Ajouter Au Panier",
                                                                                            style: TextStyle(
                                                                                              fontSize:20,
                                                                                              fontWeight : FontWeight.bold,
                                                                                              color: Colors.white
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    
                                                                                          
                                                                                        
                                                                                      ],
                                                                                    )
                                                                                  ),
                                                                              ),
                                                                            );
                                                                          }
                                                                        );
                                                                    
                                                                      },
                                                                      onLongPress: (){
                                                                        a.play("click.m4a");
                                                                        var dbHelper = DBHelper();
                                                                        var ct = dbHelper.getCustomer();
                                                                        ct.then((data) {
                                                                          //item.price
                                                                          finalDataList[index].price="${double.parse(finalDataList[index].price) - double.parse(finalDataList[index].reduction)}";
                                                                          dbHelper.addNewCommand(finalDataList[index],'Commandes', data[0].id);
                                                                          Fluttertoast.showToast(msg: 'Ajouté au panier !', toastLength: Toast.LENGTH_SHORT,
                                                                          backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                                                                        }, onError: (e) {
                                                                            
                                                                          });
                                                                        ct.then((data) async{
                                                                          await Future.delayed(Duration(milliseconds: 500));
                                                                              getProductFromDB(data[0].id).then((i){
                                                                                setState((){
                                                                                items=i.length;
                                                                                
                                                                                });
                                                                              }); 
                                                                            }, onError: (e) {
                                                                                print(e);
                                                                        });
                                                                      },
                                                                );
                                                              }
                                                            }else{
                                                              return InkWell(
                                                                  child:_checkBox(context, finalDataList[index], cat),
                                                                  onTap:(){
                                                                    showBottomSheet(
                                                                      context: context,
                                                                      builder: (builder){
                                                                        return Scaffold(
                                                                          key: _scaffoldKey,
                                                                          drawer: Drawer(
                                                                            elevation: 2.2,
                                                                            child: Container(
                                                                              width: MediaQuery.of(context).size.width-50,
                                                                              padding: EdgeInsets.all(15),
                                                                              child: Column(
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "${finalDataList[index].name} \n"
                                                                                  ),
                                                                                  Text(
                                                                                    "${finalDataList[index].descriptionShort}"
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          body: new Container(
                                                                            height: MediaQuery.of(context).size.height,
                                                                            width: MediaQuery.of(context).size.width,
                                                                            color: Colors.black87, //could change this to Color(0xFF737373), 
                                                                                      //so you don't have to change MaterialApp canvasColor
                                                                            child: new Container(
                                                                                decoration: new BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    borderRadius: new BorderRadius.only(
                                                                                        topLeft: const Radius.circular(40.0),
                                                                                        topRight: const Radius.circular(40.0))),
                                                                                child: new Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      height: MediaQuery.of(context).size.height/2,
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      child: Stack(
                                                                                        children: <Widget>[
                                                                                          CachedNetworkImage(
                                                                                          imageUrl: "http://afriktextile.com/app/aftxl/requests/getImage.php?id_prod=${finalDataList[index].id}&id_im=${finalDataList[index].image}",
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
                                                                                         Positioned(
                                                                                           left: 20,
                                                                                           top: 10,
                                                                                           child: InkWell(
                                                                                             child: Container(
                                                                                               height:40,
                                                                                               width: 40,
                                                                                               decoration: new BoxDecoration(
                                                                                                color: Colors.green[100],
                                                                                                borderRadius: new BorderRadius.all(Radius.circular(40.0))
                                                                                              ),
                                                                                              child: Icon(
                                                                                                Icons.close,
                                                                                                color: Colors.red[300]
                                                                                              ),
                                                                                             ),
                                                                                             onTap: ()=> Navigator.pop(context),
                                                                                           ),
                                                                                        )
                                                                                        ] 
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      height: 50,
                                                                                      padding: EdgeInsets.only(left:10, right:10),
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      child: Row(
                                                                                        children:<Widget>[
                                                                                          Container(
                                                                                            width: (MediaQuery.of(context).size.width/2)-10,
                                                                                            child: Text(
                                                                                              "${double.parse(finalDataList[index].price).round() - double.parse(finalDataList[index].reduction).round()} Fcfa",
                                                                                              style: TextStyle(
                                                                                                fontSize: 23,
                                                                                                color: Colors.green[300]
                                                                                              ),
                                                                                            )
                                                                                          ),
                                                                                          InkWell(
                                                                                            child: Container(
                                                                                              width: (MediaQuery.of(context).size.width/2)-10,
                                                                                              child: Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: <Widget>[
                                                                                                  Text("Détails"),
                                                                                                  Icon(
                                                                                                    Icons.arrow_forward,
                                                                                                    color: Colors.black54
                                                                                                  )
                                                                                                ]
                                                                                              ),
                                                                                            ),
                                                                                            onTap: () => _scaffoldKey.currentState.openDrawer(),
                                                                                          ),
                                                                                        ]
                                                                                      ),
                                                                                   ),
                                                                                  InkWell(
                                                                                    onTap: (){
                                                                                      a.play("click.m4a");
                                                                                      var dbHelper = DBHelper();
                                                                                      var ct = dbHelper.getCustomer();
                                                                                      ct.then((data) {
                                                                                        finalDataList[index].price="${double.parse(finalDataList[index].price) - double.parse(finalDataList[index].reduction)}";
                                                                                        dbHelper.addNewCommand(finalDataList[index],'Commandes', data[0].id);
                                                                                        Fluttertoast.showToast(msg: 'Ajouté au panier !', toastLength: Toast.LENGTH_SHORT,
                                                                                          backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                                                                                      }, onError: (e) {
                                                                                          print(e);
                                                                                      });
                                                                                      ct.then((data) async{
                                                                                        await Future.delayed(Duration(milliseconds: 500));
                                                                                            getProductFromDB(data[0].id).then((i){
                                                                                              setState((){
                                                                                              items=i.length;
                                                                                              });
                                                                                            }); 
                                                                                          }, onError: (e) {
                                                                                              print(e);
                                                                                      });

                                                                                      Future.delayed(Duration(seconds: 1), () {
                                                                                        Navigator.pop(context);
                                                                                      });
                                                                                    },
                                                                                    child:Container(
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      height:50,
                                                                                      color:Colors.green[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Text(
                                                                                        "Ajouter Au Panier",
                                                                                        style: TextStyle(
                                                                                          fontSize:20,
                                                                                          fontWeight : FontWeight.bold,
                                                                                          color: Colors.white
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                
                                                                                      
                                                                                    
                                                                                  ],
                                                                                )
                                                                              ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      );
                                                                    
                                                                    },
                                                                  onLongPress: (){
                                                                    a.play("click.m4a");
                                                                    var dbHelper = DBHelper();
                                                                    var ct = dbHelper.getCustomer();
                                                                    ct.then((data) {
                                                                      finalDataList[index].price="${double.parse(finalDataList[index].price) - double.parse(finalDataList[index].reduction)}";
                                                                      dbHelper.addNewCommand(finalDataList[index],'Commandes', data[0].id);
                                                                      Fluttertoast.showToast(msg: 'Ajouté au panier !', toastLength: Toast.LENGTH_SHORT,
                                                                        backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                                                                    }, onError: (e) {
                                                                        print(e);
                                                                    });
                                                                    ct.then((data) async{
                                                                        await Future.delayed(Duration(milliseconds: 500));
                                                                            getProductFromDB(data[0].id).then((i){
                                                                              setState((){
                                                                              items=i.length;
                                                                              });
                                                                            }); 
                                                                          }, onError: (e) {
                                                                              print(e);
                                                                      });
                                                                  },
                                                                );
                                                            }  
                                                          },
                                                          itemCount: finalDataList.length,
                                                          hasNext: finalDataList.length < initiaDatalList.length,
                                                          nextData: loadNextData,
                                                        ),
                                                );

                                          /////////////////////////////
                                        }
                                    } else if (snapshot.hasError) {
                                      //if  snapshot get erros then fetch on the internet the specific product
                                      fetchNewSpecific(table, cat);
                                      return 
                                          _checkBoxError(context);
                                    }
                                    // By default, show a loading spinner.
                                    isLoadFinished=false;
                                    return _checkBoxNull(context);
                                  }
                              },
                            ),
                        ),
               ),
              
              Positioned(
                left: (MediaQuery.of(context).size.width/2)-(63/2),
                top: (MediaQuery.of(context).size.height)-210,
                child: Container(
                  height: 63,
                  width: 63,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green[300],
                      boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(.5),
                            offset: Offset(0.0, 8.0),
                          ),
                        ],
                  ),
                  child: InkWell(
                    onTap: ()=>{
                      // Navigate to Profile Screen & Sending Email to Next Screen.
                      finalDataList=[],
                      a.play("click.m4a"),
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) =>   Basket()),
                        ModalRoute.withName('/'),
                      )
                    },
                    child: Icon(Icons.shopping_cart, color: Colors.white,),
                  ),
                ),
              ),
              Positioned(
                  left: (MediaQuery.of(context).size.width/2)-9,
                  top: (MediaQuery.of(context).size.height)-210,
                  child: Container(
                    alignment:AlignmentDirectional.center,
                    width: 20,
                    height: 20,
                    child:Text(
                      "$items",
                      style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Bellota'
                        ),
                      ),
                  )
                  ),
          
          ],
        ),
      ),
    );
  }
}
