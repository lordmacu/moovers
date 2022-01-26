import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudanzas_acarreos/home/controllers/homeController.dart';
import 'package:mudanzas_acarreos/home/home.dart';
import 'package:mudanzas_acarreos/location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Redirector extends StatefulWidget{
  @override
  _RedirectorState createState() => _RedirectorState();

}

class _RedirectorState extends State<Redirector>{
  HomeController controllerHome= Get.put(HomeController());

  checkState() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getDouble("latitude") == null) {

      Get.to(() => LocationUser());

    }else{

      controllerHome.latitude.value= prefs.getDouble("latitude")!;
      controllerHome.longitude.value=prefs.getDouble("longitude")!;
      Get.to(() => Home());

    }
  }

  @override
  void initState() {
    super.initState();
    checkState();

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Container(),
   );
  }
  
}