import 'package:afriktextile/back_end/custModel.dart';
import 'package:afriktextile/back_end/dbhelper.dart';
import 'package:afriktextile/views/function.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:image_picker/image_picker.dart';

var fc = FunctionOp();
var dbHelper = DBHelper();
var ft = dbHelper.getCustomer();
var nameController = TextEditingController();
var phoneController = TextEditingController();
var mailController = TextEditingController();
var passwordController = TextEditingController();
var sound;
bool checked;



int img;

Future<String> getImage() async{
  return ft.then((v){
    for(var i in v){
      var link=i.link;
      return link;
    }
  });
}




class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

// Initially password is obscure
    bool _obscureText = true;

    // Toggles the password show status
    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }
Future file;
String status="";
String base64Image;
String errorMessage="uploading failed";
File tmpFile;
static final String uploadEndPoint="http://afriktextile.com/app/aftxl/requests/customer/upload_image.php";
static final String updateEndPoint="http://afriktextile.com/app/aftxl/requests/update_user.php";

bool _checkBoxState = false;

void checkBoxController(){
  setState((){
    if(_checkBoxState==false){
      _checkBoxState=true;
    }else{
      _checkBoxState=false;
    }
  });
}
selectImage(){
  setState((){
    file = ImagePicker.pickImage(source: ImageSource.gallery);
  });
}
Widget showImage(){
  return FutureBuilder(
    future: file,
    builder: (context, snapshot){
      if(snapshot.connectionState == ConnectionState.done && null != snapshot.data){
        if(snapshot.data is String){}else{
          tmpFile = snapshot.data;
          base64Image= base64Encode(snapshot.data.readAsBytesSync());
        }
        return CircleAvatar(
          backgroundColor: Colors.green[300],
          backgroundImage: ((snapshot.data is String)? NetworkImage(snapshot.data): FileImage(snapshot.data) ),
          child: IconButton(
            icon: Icon(Icons.add_a_photo, color: Colors.white70,),
            onPressed: ()=> selectImage(),
          )
        );
      }else{
        return CircleAvatar(
          backgroundColor: Colors.green[300],
          //backgroundImage: NetworkImage("https://via.placeholder.com/600/771796"),
          child: IconButton(
            icon: Icon(Icons.add_a_photo, color: Colors.white70,),
            onPressed: ()=> selectImage(),
          )
        );
      }
    }
  );
}

setStatus(String msg){
  setState(() {
    status = msg;
  });
}

startUpload(Customer ctm){
  if(tmpFile is String){
    file.then((d){
      setState(() {
        ctm.link=d;
      });
    });
    updateData(ctm);
  }else{
    setStatus("Loading data....");
    if(null == tmpFile){
      file.then((d){
      setState(() {
        ctm.link=d;
        });
      });
      updateData(ctm);
      return ;
    }else{
      String fileName= tmpFile.path.split('/').last;
      upload(fileName, ctm);
    }
  }
}

upload(String file, Customer ctm){
  http.post(uploadEndPoint, body:{
    'image': base64Image,
    'name' : file,
  }).then((res){
    String url ="http://afriktextile.com/app/aftxl/requests/customer/"+file;
    ctm.link = url;
     res.statusCode==200 ? updateDataWithImage(ctm, url): updateData(ctm);
  }).catchError((error){
     setStatus(error);
  });
}
msg(String msg){
  Fluttertoast.showToast(msg: '$msg.', toastLength: Toast.LENGTH_SHORT,
  backgroundColor: Color(0xFFFFFFFF), textColor: Color(0xFF333333));
}


Future updateData(Customer ctm) async {
  final http.Response response = await http.post(
    updateEndPoint,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': ctm.name,
      'email': ctm.email,
      'phone': ctm.phone,
      'password': ctm.password,
      'aftxlID': ctm.aftxlID
    }),
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response, then parse the JSON.
    dbHelper.updateUserInfo(ctm);
    msg("Mise à jour");
  } else {
    // If the server did not return a 201 CREATED response, then throw an exception.
     msg("Mise à jour impossible");
    //throw Exception('Failed to load album');
  }
}
Future updateDataWithImage(Customer ctm ,String url) async {
  final http.Response response = await http.post(
    updateEndPoint,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': ctm.name,
      'email': ctm.email,
      'phone': ctm.phone,
      'password': ctm.password,
      'aftxlID': ctm.aftxlID
    }),
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response, then parse the JSON.
    dbHelper.updateUserInfo(ctm);
    setState(() {
     file=getImage();
   });

   ft.then((res){
     for(var item in res){
       setState((){
         item.son == 1 ? _checkBoxState=true: _checkBoxState=false;
       });
     }
   });

      msg("Mise à jour");
  } else {
    // If the server did not return a 201 CREATED response, then throw an exception.
      msg("Mise à  impossible");
    //throw Exception('Failed to load album');
  }
}


  @override
  void initState() {
    super.initState();
   setState(() {
     file=getImage();
   });
   ft.then((v){
     for(var i in v){
       setState((){
         i.son==1 ? _checkBoxState=true: _checkBoxState=false;
       });
     }
   });
 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height/3)+50,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top:0,
                      left:0,
                      right:0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.elliptical(150,70),
                            bottomLeft: Radius.elliptical(150,70),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.green[50], Colors.green[300]])
                        ),
                      )
                    ),
                    Positioned(
                      top:20,
                      left:5,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white, size:35),
                        onPressed: (){
                          Navigator.pop(context);
                        }
                      ),
                    ),
                    Positioned(
                      top:MediaQuery.of(context).size.height/4.1,
                      left: (MediaQuery.of(context).size.width/2)-50,
                      child: Container(
                        width: 100,
                        height:100,
                        child: showImage(),
                      ),
                    ),
                  
                  ],
                )
              ),
              
              Container(
                width: MediaQuery.of(context).size.width,
                height:((MediaQuery.of(context).size.height/3)*2)-50,
                child: SingleChildScrollView(
                  child: FutureBuilder<List<Customer>>(
                  future: ft,
                  builder: (context, snapshot){
                    if(snapshot.data !=null){
                        if(snapshot.hasData){
                          for(var i in snapshot.data) {
                            //i.son == 1 ? _checkBoxState=true : _checkBoxState=false;
                            return inputs(context, i);}
                        }else if(snapshot.hasError){
                          return CircularProgressIndicator(
                            backgroundColor: Colors.green[300],
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[50])
                          );
                        }
                    }else{
                      return CircularProgressIndicator(
                        backgroundColor: Colors.green[300],
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue[50])
                      );
                    }
                  }
                )
              
                )
              ),
             
            
            ]
          )
        
          )
        ),
         onWillPop: fc.onWillPop
      ),
    );
  }

  Widget inputs(BuildContext context , Customer customer){
    return Container(
        padding: EdgeInsets.only(top:10),
        child: Column(
          children:<Widget>[
            Container(
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  focusColor: Colors.green[300],
                  hintText: "${customer.name}",
                  prefixIcon: Icon(Icons.person)
                ),
              )
            ),
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "${customer.phone}",
                  prefixIcon: Icon(Icons.phone_android)
                ),
              )
            ),
            Container(
              child: TextFormField(
                controller : mailController,
                decoration: InputDecoration(
                  hintText: "${(customer.email==null) ?'vide':customer.email}",
                  prefixIcon: Icon(Icons.email)
                ),
              )
            ),
            Container(
              child: TextFormField(
                controller: passwordController,
                obscureText:  _obscureText,
                decoration: InputDecoration(
                  hintText: "${_obscureText==true? '...........' : customer.password}",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: InkWell(
                    child: Icon(_obscureText==true ? Icons.visibility :  Icons.visibility_off),
                    onTap: _toggle,
                  ),
                ),
              )
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height:50,
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      value: _checkBoxState,
                      onChanged: (bool v){
                        checkBoxController();
                      },
                      activeColor: Colors.green[300],
                    ),
                    Text("Désactiver le son"),
                    //Text("${customer.aftxlID}")
                  ],
                )
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height:50,
                margin: EdgeInsets.only(top:20),
                alignment: AlignmentDirectional.center,
                child: InkWell(
                  child: Container(
                    height:50,
                    width: MediaQuery.of(context).size.width/2,
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.green[300]
                    ),
                    child: Text("Mettre à jour", style: TextStyle(color: Colors.white), textAlign: TextAlign.center)
                  ),
                  onTap:(){
                      Customer ctm = new Customer();
                      ctm.id = customer.id;
                      ctm.name = nameController.text != "" ? nameController.text: customer.name;
                      ctm.phone = phoneController.text != "" ? phoneController.text: customer.phone;
                      ctm.email = mailController.text != "" ? mailController.text: customer.email;
                      ctm.password = passwordController.text != "" ? passwordController.text: customer.password;
                      ctm.son = _checkBoxState ==true ? 1 : 0;
                      ctm.aftxlID = customer.aftxlID;
                      startUpload(ctm);
                  }
                )
            ),
          ]
        ),
      );
    
  }
}