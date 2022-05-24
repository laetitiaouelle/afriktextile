import 'package:afriktextile/back_end/playsound.dart';
import 'package:afriktextile/views/function.dart';
import 'package:afriktextile/views/home.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

var fc = FunctionOp();
var a=Audio();
class Resultat extends StatefulWidget {


  @override
  _ResultatState createState() {
    return _ResultatState();
  }
}

class _ResultatState extends State<Resultat> {
 List<String> sucMsg=[
   "Super votre commande a été enregistrée avec succès!. Nous vous contacterons bientôt.",
   "Génial, vous avez passé une commande avec brio! Nous allons nous empresser de vous contacter sous peu.",
   "Commande validée, Vous avez fait le bon choix en achetant chez AfrikTexile, nous vous contacterons dans un bref délai.",
   "Votre commande sur AfrikTextile a été enregistrée, nous vous tiendrons informé(e) des démarches jusqu'à la livraison",

 ];
 var randomMSG;
 var randomIMG;
@override
  void initState() {
    super.initState();
    setState((){
      randomMSG = randomBetween(1, 4);
      randomIMG = randomBetween(1, 11);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.green[300]
          ),
          onPressed: (){ a.play("click.m4a"); Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context)=>Home()),
            ModalRoute.withName('/'),
            );
          },
        ),
      ),
      body: WillPopScope(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/3,
                    child: Image.asset("assets/images/top$randomIMG.png"),
                  ),
                  Container(
                    width: ( MediaQuery.of(context).size.width/3)*2,
                    height: MediaQuery.of(context).size.height/3,
                    child: Text(
                      "${sucMsg[randomMSG]}"
                    ),
                  ),
                  InkWell(
                    child: Container(
                      width:( MediaQuery.of(context).size.width/3)*2,
                      height: 50,
                      alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                          color: Color(0xFF3F3D56),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50)
                          ),
                        ),
                      child: Text(
                        "Continuer mes achats",
                        style: TextStyle(
                          color: Colors.white,
                        )
                      ),
                    ),
                    onTap: (){ a.play("click.m4a"); Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context)=>Home()),
                      ModalRoute.withName('/'),
                      );
                    }
                  )
                  ],
                ),
                ),
                onWillPop: fc.onWillPop,
      ),
    );
  }
}

