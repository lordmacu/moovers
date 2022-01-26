import 'dart:async';
 import 'package:get/get.dart';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mudanzas_acarreos/home/controllers/homeController.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mudanzas_acarreos/location/controllers/locationController.dart';
import 'package:mudanzas_acarreos/search/controllers/searchController.dart';
import 'package:mudanzas_acarreos/search/search.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatelessWidget{

  late GoogleMapController _controller;

  HomeController controllerHome= Get.put(HomeController());
  LocationController controllerLocation= Get.put(LocationController());
  SearchController controllerSearch=Get.put(SearchController());



  Location _location = Location();



  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _goToTheLake() async {
    controllerHome.getSteetAddress();

  }

  getLocationAndAdress() async{
    await controllerLocation.getLocationForce();
    await controllerHome.addMarker();

    controllerHome.getSteetAddress();

  }

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    getLocationAndAdress();
    rootBundle.loadString('assets/customMap.json').then((String mapStyle) {
      _controller.setMapStyle(mapStyle);
    });



  }
  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (controllerHome.markerIcon == null) {
      final ImageConfiguration imageConfiguration =
      createLocalImageConfiguration(context, size: Size.square(48));


      BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/currenticon.png')
          .then(_updateBitmap);
    }
  }
  void _updateBitmap(BitmapDescriptor bitmap) {
    controllerHome.updateBitmap(bitmap);

  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    _createMarkerImageFromAsset(context);
    return WillPopScope(child: Scaffold(

      body: SlidingUpPanel(
        controller: controllerHome.controllerPanel.value,
        margin: EdgeInsets.only(left: 10,right: 10),
        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft:  Radius.circular(20)),
        maxHeight: (height*55)/100,
        minHeight: 0,
        backdropEnabled: true,

        panel: Search(),
        body: Stack(
          children: [
            Obx(()=>GoogleMap(
              mapToolbarEnabled: true,
              markers: Set<Marker>.of(controllerHome.markers.values),
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(controllerHome.latitude.value, controllerHome.longitude.value),
                tilt: 59.440717697143555,

                zoom: 16,
              ),
              onMapCreated: _onMapCreated,
            )),
            Align(child: Container(

              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
              ),
              margin: EdgeInsets.only(left: 5,right: 5),
              padding: EdgeInsets.only(bottom: 40,right: 15,left: 15,top: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTapDown: (tap){
                      controllerHome.isDownInput.value=true;
                    },
                    onTapUp: (tap){
                      controllerHome.isDownInput.value=false;
                    },
                    onTap: (){



                      controllerHome.controllerPanel.value.open();
                      controllerSearch.setFromText();

                    },
                    child: Obx(()=>Container(
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(20),
                          color: controllerHome.isDownInput.value ?  controllerHome.colorDown.value :  controllerHome.colorUp.value

                      ),
                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 20,top: 20),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Icon(Icons.circle,color: Colors.blueAccent,size: 15,),
                          ),
                          Text("¿En donde es la mudanza?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                        ],
                      ),
                    )),
                  )
                ],
              ),
            ),alignment: Alignment.bottomCenter,)
          ],
        ),
      ),
    ),onWillPop: () async => false);
  }

}