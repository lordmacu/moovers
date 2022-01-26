import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:mudanzas_acarreos/home/controllers/homeController.dart';
import 'package:mudanzas_acarreos/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchController extends GetxController {
  var contollerFrom= TextEditingController().obs;
  var contollerTo= TextEditingController().obs;

  HomeController controllerHome= Get.find();

  var focusTo= FocusNode().obs;
  var isFrom=true.obs;
  var addreses=[].obs;

  var isWritingFrom=false.obs;
  var isWritingTo=false.obs;
  var latitudeTo=0.0.obs;
  var longitudeTo=0.0.obs;
  var fromText="".obs;
  var toText="".obs;
  var tabOnTo=false.obs;

  getSteetByAddress(address) async{

    if(address.length>0){
      latitudeTo.value=0.0;
      contollerTo.value.text="";
    var url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyDeGlf97ZWeAvpSAEUM1fhMK4G6qXt4zck&address=${Uri.encodeComponent(address)}&sensor=false');
    var response = await http.get(url);
    print("sdafasdf  ${url}");


    var json= jsonDecode(response.body.toString());

    if(json.length > 0){
      var addresesLocal=[];
      for(var o =0 ; o < json["results"].length ;  o  ++){

        if( json["results"].length<4){
          var lat=json["results"][o]["geometry"]["location"]["lat"];
          var lng=json["results"][o]["geometry"]["location"]["lng"];

          if(isFrom.value){
            controllerHome.latitude.value=double.parse("${lat}");
            controllerHome.longitude.value=double.parse("${lng}");
          }

          await getSteetAddress(lat,lng);
        }

      }
      controllerHome.addreses.insert((json["results"].length/2).toInt()+1, {"addressText":"${address}","latitude":0, "longitude":0,"neightborhood":"none"});
    }
  }
  }

  returnAddress(data){
    var route="";
    var street_number="";
    var neighBoorHood="";
    for(var i =0; i <data["address_components"].length ; i ++ ){
      var addressComponent=data["address_components"][i];

      if(addressComponent["types"][0]=="route"){
        route= "${addressComponent["long_name"]}";
      }
      if(addressComponent["types"][0]=="street_number"){
        street_number= "${addressComponent["long_name"]}";
      }

      if(addressComponent["types"][0]=="neighborhood"){
        neighBoorHood= "${addressComponent["long_name"]}";
      }

      if(neighBoorHood.length==0){
        neighBoorHood= "${addressComponent["long_name"]}";
      }
    }

    var locationPoint=data["geometry"]["location"];
    return {"addressText":"${route} ${street_number}","latitude":locationPoint["lat"], "longitude":locationPoint["lng"],"neightborhood":neighBoorHood};
  }

  getSteetAddress(lat,lng) async{
    controllerHome.addreses.clear();

    print("aquii esta");

    var url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=AIzaSyDeGlf97ZWeAvpSAEUM1fhMK4G6qXt4zck');
    var response = await http.get(url);
    print("sdafasdf  ${url}");

    var json= jsonDecode(response.body.toString());


    if(json.length > 0){
      var addresesLocal=[];
      for(var o =0 ; o < json["results"].length ;  o  ++){
        var returnAddressValue=returnAddress(json["results"][o]);
        addresesLocal.add(returnAddressValue);
      }
      controllerHome.addreses.assignAll(addresesLocal);
    }


    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

  }



  setFromText(){
    if(controllerHome.addreses.length>0){
      contollerFrom.value.text=controllerHome.addreses[0]["addressText"];
      focusTo.value.requestFocus();
      isFrom.value=false;
    }
  }

  @override
  void onInit() {





  }
}
