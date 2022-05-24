import 'package:afriktextile/back_end/dbhelper.dart';
import 'package:afriktextile/views/function.dart';
import 'package:afriktextile/views/home.dart';
import 'package:afriktextile/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_country_picker/flutter_country_picker.dart';

var fc = FunctionOp();
var _selected;
var selectedDialingCode;

class Singin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Container(
        child: ConnectUser()
        )
      );
  }
}

class ConnectUser extends StatefulWidget {
  ConnectUserState createState() => ConnectUserState();
}

class ConnectUserState extends State{
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
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();


  Future userSignin() async{
 
  // Showing CircularProgressIndicator.
  setState(() {
  visible = true ; 
  });
 
  // Getting value from Controller
  String phone = phoneController.text;
  String password = passwordController.text;
  var phoneComp = selectedDialingCode+phone;
  print(phoneComp);

  // SERVER LOGIN API URL
  String url = "http://afriktextile.com/app/aftxl/requests/user_connexion.php?phone=$phoneComp&password=$password";
  // Starting Web API Call.
  var response = await http.get(url);
 
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    
      var message = jsonDecode(response.body);
      if(message == 'invalide'){
        setState(() {
          visible = false; 
        });
        Fluttertoast.showToast(msg: 'Vos identifiants ne sont pas valides.', toastLength: Toast.LENGTH_SHORT,
         backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
         
      }else{

        var dbHelper = DBHelper();
        dbHelper.addNewCustomer(message["aftxlID"], message["name"], phone,password,1,"https://via.placeholder.com/600/771796");
        await Future.delayed(Duration(milliseconds: 6000));
        setState(() {
          visible = false; 
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Home() ),
          ModalRoute.withName('/'),
        );
                                      
      }
  } else {
    setState(() {
      visible = false; 
      });
    Fluttertoast.showToast(msg: 'Aucune connexion à internet.', toastLength: Toast.LENGTH_SHORT,
    backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                                      
  }
 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          child:Container(
          decoration: 
              new BoxDecoration(
                  image: new DecorationImage(
                  image: AssetImage("assets/images/bg3.jpg"),
                  fit: BoxFit.cover
                ),
          ),
          child: Container(
            color: Colors.black38,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:Stack(
            
            children: <Widget>[
              Positioned(
                top: 55,
                left: 0,
                right: 0,
                child: Container(
                  //color: Colors.green,
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Text("Connexion",style: TextStyle(fontSize: 35,  color: Colors.white)
                  )
                  ),
                )
              ),
              Positioned(
                top:  MediaQuery.of(context).size.height/3,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20) ,
                  // width: MediaQuery.of(context).size.width/1.6,
                    height: MediaQuery.of(context).size.height/2.5,
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
                      padding: EdgeInsets.only(left:50, right: 50, ),
                      child: Column(
                        children: <Widget>[
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
                                  MaterialPageRoute(builder: (BuildContext context) => Signup()),
                                  ModalRoute.withName('/'),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top:20.0),
                              child: Text("Pas de compte ? Créer en un ici..",
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
              top: MediaQuery.of(context).size.height/2.7,
              left: MediaQuery.of(context).size.width/1.4,
              child: Container(
                width: 60,
                height: 60,
                decoration: new BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: new BorderRadius.circular(50),
                ),
                child: InkWell(
                  child: Icon(Icons.send, color: Colors.white,),
                  onTap: () {
                  
                    if(phoneController.text=='' || passwordController.text==''){
                      Fluttertoast.showToast(msg: "Remplissez toutes les cases", toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                    }else{
                      if(selectedDialingCode== null){
                        Fluttertoast.showToast(msg: "Aucun pays sélectionné", toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
                      }else{
                        userSignin();
                      }
                    }
                  },
                ),
              ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height/2.56,
                left: MediaQuery.of(context).size.width/1.33 ,
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
                top: MediaQuery.of(context).size.height/3.2,
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
          ),
          onWillPop: fc.onWillPop
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
