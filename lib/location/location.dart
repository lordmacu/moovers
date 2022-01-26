import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudanzas_acarreos/home/home.dart';
import 'package:mudanzas_acarreos/location/controllers/locationController.dart';

class LocationUser  extends StatelessWidget{

  LocationController controllerLocation= Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           Container(
             width: 150,
             child: Image.asset("assets/icon.png"),
           ),
           Container(
             margin: EdgeInsets.only(bottom: 50),
             child: Text("Moovers",style: TextStyle(color: Colors.blueAccent,fontSize: 40),),
           ),
           RaisedButton(
             color: Colors.blueAccent,
             shape:  RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(30.0),
             ),
             onPressed: () async{
               await controllerLocation.getLocation();
             },
             child: Text("Dar permiso Localización",style: TextStyle(color: Colors.white),),
           )
         ],
       ),
     ),
   );
  }

}