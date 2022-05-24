import 'package:afriktextile/views/home.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Waiting extends StatefulWidget {
  @override
  _WaitingState createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {

  Timer _timer;
  int _start = 20;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            //timer.cancel();
            print("okk");
             Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context)=>  Home()),
              ModalRoute.withName('/'),
              );
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading : false,
            backgroundColor: Colors.white,
            elevation: 00,
          ),
          body: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:<Widget>[
                Container(
                  child: Image(
                    image: AssetImage("assets/images/timergif.gif"),
                  )
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Nous téléchargeons les données,\n",
                          style: TextStyle(
                            fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Veuillez patienter encore",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "$_start",
                              style: TextStyle(
                                color: Colors.green[300],
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              "seconde(s)",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
              ]
            ),
          ),
      ),
    );
  }
}