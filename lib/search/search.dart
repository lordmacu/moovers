import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudanzas_acarreos/agenda/agenda.dart';
import 'package:mudanzas_acarreos/agenda/controllers/AgendaController.dart';
import 'package:mudanzas_acarreos/home/controllers/homeController.dart';
import 'package:mudanzas_acarreos/home/home.dart';
import 'package:mudanzas_acarreos/location/controllers/locationController.dart';
import 'package:mudanzas_acarreos/search/controllers/searchController.dart';

class Search extends StatelessWidget {
  SearchController controllerSearch = Get.put(SearchController());
  HomeController controllerHome = Get.put(HomeController());
  AgendaController controllerAgenda = Get.put(AgendaController());

  String distance(
      double lat1, double lon1, double lat2, double lon2, String unit) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    if (unit == 'K') {
      dist = dist * 1.609344;
    } else if (unit == 'N') {
      dist = dist * 0.8684;
    }
    return dist.toStringAsFixed(2);
  }

  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),

                  child: Icon(Icons.circle,color: Colors.blueAccent,size: 12),
                ),
                Expanded(child: TextFormField(
                  onTap: (){
                    controllerSearch.isWritingFrom.value=true;
                  },
                  onChanged: (input){
                    controllerSearch.isFrom.value=true;
                    controllerSearch.isWritingFrom.value=true;
                    controllerSearch.fromText.value=input;

                  },
                  controller: controllerSearch.contollerFrom.value,
                  onFieldSubmitted: (input){
                    controllerSearch.isFrom.value=true;

                    controllerSearch.getSteetByAddress(controllerSearch.contollerFrom.value.text);
                  },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                      hintText: "Ingresar el punto de partida",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(0)),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                )),
                Obx(()=>controllerSearch.isWritingFrom.value ?  InkWell(
                  onTap: (){
                    controllerSearch.isFrom.value=true;

                    controllerSearch.getSteetByAddress(controllerSearch.contollerFrom.value.text);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.search,color: Colors.blueAccent,size: 30),
                  ),
                ): Container()),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                Container(

                  child: Icon(Icons.flag,color: Colors.blueAccent,size: 17,),
                  margin: EdgeInsets.only(right: 10),
                ),
                Expanded(child: TextFormField(
                  onChanged: (value){
                    controllerSearch.isFrom.value=false;
                    controllerSearch.isWritingTo.value=true;
                    controllerSearch.toText.value=value;
                  },
                  onTap: (){
                    controllerSearch.isFrom.value=false;
                  },
                  controller: controllerSearch.contollerTo.value,


                  onFieldSubmitted: (input){

                    controllerSearch.isFrom.value=false;
                    controllerSearch.getSteetByAddress(controllerSearch.contollerTo.value.text);
                  },
                  focusNode: controllerSearch.focusTo.value,


                  decoration: InputDecoration(

                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                      hintText: "¿A donde es la mudanza?",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(0)),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                )),
                Obx(()=>controllerSearch.toText.value.length>0 ?  InkWell(
                  onTap: (){
                    controllerSearch.isFrom.value=false;

                    controllerSearch.getSteetByAddress(controllerSearch.contollerTo.value.text);

                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.search,color: Colors.blueAccent,size: 30),
                  ),
                ): Container()),
              ],
            ),
          ),
          Expanded(child: Obx(()=>ListView.builder(

              itemCount: controllerHome.addreses.value.length,
              itemBuilder: (BuildContext context, int index) {


                if(controllerHome.addreses[index]["addressText"].trim().length>0){
                  return ListTile(
                    onTap: (){
                      print("aquiii haciendo click manito  ${controllerHome.addreses[index]}");



                      if(controllerSearch.isFrom.value){
                        controllerSearch.fromText.value=controllerHome.addreses[index]["addressText"].trim();

                        controllerSearch.contollerFrom.value.text=controllerHome.addreses[index]["addressText"].trim();

                        controllerHome.latitude.value=double.parse("${controllerHome.addreses[index]["latitude"]}");;
                        controllerHome.longitude.value=double.parse("${controllerHome.addreses[index]["longitude"]}");;

                      }else{
                        controllerSearch.toText.value=controllerHome.addreses[index]["addressText"].trim();
                        controllerSearch.contollerTo.value.text=controllerHome.addreses[index]["addressText"].trim();

                        controllerSearch.latitudeTo.value=double.parse("${controllerHome.addreses[index]["latitude"]}");
                        controllerSearch.longitudeTo.value=double.parse("${controllerHome.addreses[index]["longitude"]}");

                        controllerSearch.tabOnTo.value=true;

                      }
                    },
                      leading: Icon(Icons.pin_drop_sharp),

                      title: Text("${controllerHome.addreses[index]["addressText"].trim()}"));
                }else{
                  return Container();
                }

              }))),
          Obx(()=>controllerSearch.tabOnTo.value ?   RaisedButton(
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),

            onPressed: (){

              controllerAgenda.contollerFrom.value.text=controllerSearch.contollerFrom.value.text;
              controllerAgenda.contollerTo.value.text=controllerSearch.contollerTo.value.text;

             Get.to(Agenda());
            },
            child: Text("Calcular mudanza",style: TextStyle(color: Colors.white,fontSize: 15),),

            color: Colors.blueAccent,
          ) : Container())
        ],
      ),
    );
  }
}
