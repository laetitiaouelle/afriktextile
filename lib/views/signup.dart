import 'package:afriktextile/views/function.dart';
import 'package:afriktextile/back_end/dbhelper.dart';
import 'package:afriktextile/views/signin.dart';
import 'package:afriktextile/views/telverify.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
 
 var fc= FunctionOp();
 var _selected;
 var selectedDialingCode;

class Signup extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Scaffold(
      body: Container(
        child: SubscribeUser()
        )
    );
}
}

 class Post {
  final int rtrn;
  Post({this.rtrn,});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      rtrn: json['message'], 
    );
  }
}

class SubscribeUser extends StatefulWidget {
 
SubscribeUserState createState() => SubscribeUserState();
 
}
 
class SubscribeUserState extends State {
 
// Initially password is obscure
    bool _obscureText = true;

    // Toggles the password show status
    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

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
 
  // Getting value from TextField widget.
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
 
Future userSignup() async{
 
  // Showing CircularProgressIndicator.
  setState(() {
  visible = true ; 
  });

  // Getting value from Controller
  String name = nameController.text;
  String phone = phoneController.text;
  String password = passwordController.text;
  var aftxlID="${randomAlphaNumeric(10)}AFTXLUSER${randomBetween(100, 20000)}";
  var phoneComp = selectedDialingCode+phone;
  print(phoneComp);
  
  // SERVER LOGIN API URL
  String url = "http://afriktextile.com/app/aftxl/requests/user_registration.php?aftxlID=$aftxlID&name=$name&phone=$phoneComp&password=$password";
  // Starting Web API Call.
  var response = await http.get(url);
 
  if (response.statusCode == 200) {
    // If the server returns an OK response, parse the JSON.
    setState(() {
      visible = false; 
      });
      var message = jsonDecode(response.body);
      if(message == 'exist'){
         Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Singin()),
          ModalRoute.withName('/'),
        );
        Fluttertoast.showToast(msg: 'Vous avez déjà un compte !', toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
      }else if(message == 'valide'){
        var dbHelper = DBHelper();
        dbHelper.addNewCustomer(aftxlID,name, phone,password,1,"https://via.placeholder.com/600/771796");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => TelVerify(phone: phone)),
          ModalRoute.withName('/'),
        );
      }else if(message == 'invalide'){
        Fluttertoast.showToast(msg: 'Veuillez réessayer !', toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
      }
  } else {
    setState(() {
      visible = false; 
      });
    Fluttertoast.showToast(msg: 'Veuillez réessayer !', toastLength: Toast.LENGTH_SHORT,
    backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
  }
  
 
}
 
@override
Widget build(BuildContext context) {
return Scaffold(
    body: WillPopScope(
      child:SingleChildScrollView(
      child: Container(
      width: MediaQuery.of(context).size.width,
          height:  MediaQuery.of(context).size.height,
          decoration: 
              new BoxDecoration(
                  image: new DecorationImage(
                  image: AssetImage("assets/images/bg1.jpg"),
                  fit: BoxFit.cover
                ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height:  MediaQuery.of(context).size.height,
            decoration: 
              new BoxDecoration(
                  color: Colors.black38,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 66,
                left: 0,
                right: 0,
                child: Container(
                  //color: Colors.green,
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Text("Inscription",style: TextStyle(fontSize: 40,  color: Colors.white)
                  )
                  ),
                )
              ),
              
              Positioned(
                top: MediaQuery.of(context).size.height/3.3,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20) ,
                  // width: MediaQuery.of(context).size.width/1.6,
                    height: MediaQuery.of(context).size.height/2,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                                boxShadow: [
                                    BoxShadow(
                                      blurRadius: 3.0,
                                      color: Colors.black.withOpacity(.1),
                                      offset: Offset(6.0, 7.0),
                                    ),
                                  ],
                                borderRadius: new BorderRadius.only(
                                    topLeft:  const  Radius.circular(30.0), 
                                    topRight: const  Radius.circular(30.0),
                                    bottomLeft:  const  Radius.circular(30.0),
                                    bottomRight: const  Radius.circular(30.0),
                              ),
                      ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only( left:50, right: 50,),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                            labelText: 'Nom et Prénoms',
                            //errorText: ''
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: CountryPicker(
                                  dense: false,
                                  showFlag: true,  //displays flag, true by default
                                  showDialingCode: true, //displays dialing code, false by default
                                  showName: false, //displays country name, true by default
                                  showCurrency: false, //eg. 'British pound'
                                  showCurrencyISO: false, //eg. 'GBP'
                                  onChanged: (Country country) {
                                    setState(() {
                                      _selected = country;
                                      selectedDialingCode = country.dialingCode;
                                    });
                                  },
                                  selectedCountry: _selected,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                  labelText: '  Numéro',
                                  //errorText: ''
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              suffixIcon: InkWell(
                                child: Icon(_obscureText==true ? Icons.visibility :  Icons.visibility_off),
                                onTap: _toggle,
                              ),
                            ),
                          ),  
                          InkWell(
                            onTap: (){
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => Singin() ),
                                  ModalRoute.withName('/'),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top:20.0),
                              child: Text("Déjà membre? Connectez-vous..",
                                style: TextStyle(color: Colors.red[300]),
                              ) ,
                           ),
                          )                     
                        ],
                      ),
                    ),
                  ],
                ),
                ),
              ),
              Positioned(
              top: MediaQuery.of(context).size.height/2.6,
              left: MediaQuery.of(context).size.width/1.4,
              child: InkWell(
                  child: Container(
                    width: 63,
                    height: 63,
                    decoration: new BoxDecoration(
                      color: Colors.red[200],
                      borderRadius: new BorderRadius.circular(50),
                    ),
                      child: Icon(Icons.send, color: Colors.white,),
                  ),
                onTap: () {
                          if(nameController.text =='' || phoneController.text=='' || passwordController.text==''){
                            Fluttertoast.showToast(msg: "Remplissez toutes les cases", toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                          }else{
                            if(selectedDialingCode== null){
                              Fluttertoast.showToast(msg: "Aucun pays sélectionné", toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                            }else{
                              userSignup();
                            }
                          }
                    
                    },
              ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height/2.47,
                left: MediaQuery.of(context).size.width/1.34 ,
                child: Container(
                  child:Visibility(
                    visible: visible, 
                    child: Container(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                      )
                    ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height/3.5,
                right: MediaQuery.of(context).size.width/1.4,
                child: Container(
                  width: 63,
                  height: 63,
                  decoration: new BoxDecoration(
                    //color: Colors.red[200],
                    borderRadius: new BorderRadius.circular(50),
                    image: new DecorationImage(
                      image: AssetImage("assets/images/launcher_icon.png"),
                      fit: BoxFit.cover
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    )
    ),
    onWillPop: fc.onWillPop
  )
);
}
}
 
