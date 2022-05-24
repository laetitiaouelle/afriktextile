import 'dart:async';
import 'package:afriktextile/views/home.dart';
import 'package:afriktextile/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'back_end/dbhelper.dart';

const myTask = "syncWithTheBackEnd";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager.registerPeriodicTask(
    "1",
    myTask, //This is the value that will be returned in the callbackDispatcher
    constraints:Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
        requiresCharging: true,
        requiresDeviceIdle: true,
        requiresStorageNotLow: true
    ),
    backoffPolicy: BackoffPolicy.exponential, 
    backoffPolicyDelay: Duration(seconds: 10)
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MyApp());
  });
}
var backgroundTask ="bj";
void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    getDataOnBG(); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

List l=["p8mars","ch2tons","woodin","hollandais","uniwaxblock","uniwaxprint","ABC","chuni","hitarget","hitarget2tons","waxsuper","waxbrode"];
List t=[200,97,77,98,198,78,228,181,84,230,197,80];

 void getDataOnBG(){
   for(var i=0; i < l.length; i++){
      fetchNew(l[i],t[i]);
    }
 }


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Afrik Textile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green[300],
        fontFamily: 'PlayfairDisplay' ,
        //canvasColor: Colors.transparent,
      ),
      //theme: ThemeData(fontFamily: 'Raleway'),
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void getData(){
   for(var i=0; i < l.length; i++){
      fetchNew(l[i],t[i]);
    }
    var db = DBHelper();
    var res = db.existCustomer();
    res.then((data) async{
    await Future.delayed(Duration(milliseconds: 6000));

    if(data){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Home()),
        ModalRoute.withName('/main.dart'),
    );
    }else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Singin()),
        ModalRoute.withName('/main.dart'),
    );
    }

      }, onError: (e) {
          print(e);
        });
  }



  @override
  void initState() {
    super.initState();
    print("on init state");
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
       child: InkWell(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset("assets/images/afriktextile-logo.jpg", width: 200,),
            CircularProgressIndicator(
              backgroundColor: Colors.green[300],
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black12)
            )
          ],
        ), 
        onTap:  () {},
       ),
      ),
    );
  }
}
