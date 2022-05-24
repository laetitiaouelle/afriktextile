import 'package:afriktextile/views/function.dart';
import 'package:afriktextile/views/home.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

var fc = FunctionOp();

class TelVerify extends StatelessWidget {
  final String phone;
  // Receiving Email using Constructor.
  TelVerify({Key key, @required this.phone}) : super(key: key);
@override
Widget build(BuildContext context) {
  return Scaffold(
      body: WillPopScope(child: 
      Container(
        child: Verification(phone: phone)
        ),
        onWillPop: fc.onWillPop
      )
    );
}
}
class Verification extends StatefulWidget {
  final String phone;
 Verification({Key key, @required this.phone}) : super(key: key);
VerificationState createState() => VerificationState(phone: phone);
 
}
class VerificationState extends State {
  final String phone;
  final codeController = TextEditingController();
  VerificationState({Key key, @required this.phone});



  void msg(String msg){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(msg),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // For CircularProgressIndicator.
  bool visible = false ;

Future checkCode() async{
  // Showing CircularProgressIndicator.
  setState(() {
  visible = true ; 
  });
  // Getting value from Controller
  String code = codeController.text;
  // SERVER LOGIN API URL
  String url = "http://afriktextile.com/app/aftxl/requests/verify_code.php?code=$code";
  // Starting Web API Call.
  var response = await http.get(url);
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    setState(() {
      visible = false; 
      });
      var message = jsonDecode(response.body);
      if(message == 'exist'){
        msg('Vous avez déjà un compte actif, connectez-vous');
      }else if(message == 'valide'){
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Home()),
          ModalRoute.withName('/'),
        );
      }else if(message == 'invalide'){
         msg('Code invalide. Veuillez réessayer.');
      }
  } else {
    // If that response was not OK, throw an error.
    //throw Exception('Failed to load post');
    // Showing Alert Dialog with Response JSON Message.
    setState(() {
      visible = false; 
      });
    msg('Failed to load response');
  }
}








  @override
  Widget build(BuildContext context) {
    
    // Creating String Var to Hold sent Email.  
   
    return Scaffold(
      body:SingleChildScrollView(
        child: Container(
        
         child: Container(
           width: MediaQuery.of(context).size.width,
           height:  MediaQuery.of(context).size.height,
           decoration: 
            new BoxDecoration(
                 //color: Colors.black87,
         ),
         child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            width: MediaQuery.of(context).size.width ,
            child: Text("Nous avons envoyé un code de vérification par SMS sur $phone\nEntrer le numéro pour valider votre inscription",
            style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ),
          new Container(
                 margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20) ,
                 // width: MediaQuery.of(context).size.width/1.6,
                  child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Container(
                     padding: EdgeInsets.only( left:50, right: 50,),
                     child: Column(
                       children: <Widget>[
                         TextFormField(
                          controller: codeController,
                          decoration: InputDecoration(
                          labelText: 'Entrer le code ici',
                          labelStyle: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.normal),
                          //hintText: 'Entrer le code ici',
                          //hintStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
                          enabledBorder: UnderlineInputBorder(      
                            borderSide: BorderSide(color: Colors.green),   
                            ),  
                          focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green[300]),
                          ),
                          
                          ),
                         ),
                         
                         InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: 50),
                            width: 200,
                            height: 40,
                            decoration: new BoxDecoration(
                              color: Colors.green[200],
                              borderRadius: new BorderRadius.circular(5),
                            ),
                              child: Icon(Icons.send, color: Colors.white,),
                          ),
                        onTap: () {
                              if(codeController.text == ''){

                              }else{
                                checkCode();
                              }
                              
                            },
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30 ),
                        child:Visibility(
                          visible: visible, 
                          child: Container(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black26),
                            )
                            )
                          ),
                       ),
                       ],
                     ),
                   ),
                 ],
               ),
               ),
        ],
      ),
         ),
      ),
      )
     );
  }
}
