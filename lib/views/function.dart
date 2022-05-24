import 'package:fluttertoast/fluttertoast.dart';

class FunctionOp{

  int toInt(var str){
    var myInt = int.parse(str);
    assert(myInt is int);
    return myInt;
  }
  double toDouble(String str){
    var myDouble = double.parse(str);
    assert(myDouble is double);
    return myDouble;
  }

  DateTime currentBackPressTime;
  var exitWwarning="Appuyez encore pour quitter";
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: exitWwarning);
      return Future.value(false);
    }
    return Future.value(true);
  }

}

void saveImageInCache(String url, idProd, idImg){

}