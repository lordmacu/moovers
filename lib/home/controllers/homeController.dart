
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:mudanzas_acarreos/search/controllers/searchController.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeController extends GetxController{


  var controllerPanel= PanelController().obs;


  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  var markers = <MarkerId, Marker>{}.obs;
  late Rx<MarkerId?> selectedMarker;
  late Rx<LatLng?> markerPosition;
  var markerIcon;
  var completeAddress="".obs;
  var addressCompleteSelected={}.obs;

  var colorUp= Colors.grey.withOpacity(0.2).obs;
  var colorDown= Colors.grey.withOpacity(0.4).obs;
  var isDownInput=false.obs;
  var addreses=[].obs;
  void updateBitmap(BitmapDescriptor bitmap) {
    markerIcon = bitmap;

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



  getSteetAddress() async{
    addreses.clear();

    print("aquii esta");

    var url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitude.value},${longitude.value}&key=apikey');
    var response = await http.get(url);
    print("sdafasdf  ${url}");

    var json= jsonDecode(response.body.toString());


    if(json.length > 0){
      var addresesLocal=[];
      for(var o =0 ; o < json["results"].length ;  o  ++){
        var returnAddressValue=returnAddress(json["results"][o]);
        addresesLocal.add(returnAddressValue);

        if(o==0){

          completeAddress.value="${returnAddressValue["addressText"]}";
          addressCompleteSelected.value=returnAddressValue;
        }
      }

      addreses.assignAll(addresesLocal);
    }


    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

  }


  void _changePosition(MarkerId markerId) {
    final Marker marker = markers[markerId]!;
    final LatLng current = marker.position;


      markers[markerId] = marker.copyWith(
        positionParam: LatLng(
          latitude.value,
          longitude.value,
        ),
      );
  }

  addMarker(){
    final MarkerId markerId = MarkerId("currentUser");

    final Marker marker = Marker(
      markerId: markerId,
      icon: markerIcon,
      position: LatLng(
        latitude.value,
        longitude.value,
      ),
      infoWindow: InfoWindow(title: "currentUser", snippet: '*'),


    );

    markers[markerId]=marker;
    markers.refresh();
  }

  @override
  void onInit() {

  }



}