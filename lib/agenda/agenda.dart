import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
  import 'package:mudanzas_acarreos/agenda/controllers/AgendaController.dart';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:mudanzas_acarreos/agenda/offer.dart';
import 'package:mudanzas_acarreos/home/controllers/homeController.dart';
import 'package:mudanzas_acarreos/search/controllers/searchController.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Agenda  extends StatelessWidget{

  AgendaController controllerAgenda= Get.put(AgendaController());
  SearchController controllerSearch= Get.find();
  HomeController controllerHome= Get.find();
  var panelController= PanelController().obs;


  final _formKey = GlobalKey<FormState>();

  var loadingHud;

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

  openwhatsapp(context) async{


    controllerSearch.tabOnTo.value=false;

    final link = WhatsAppUnilink(
      phoneNumber: '+573154645370',
      text: "hola soy ${controllerAgenda.controllerName.value.text} mi celular es ${controllerAgenda.controllerPhone.value.text} y me gustaría una mudanza de ${controllerAgenda.contollerFrom.value.text}  a ${controllerAgenda.contollerTo.value.text} el dia ${controllerAgenda.controllerDate.value}",
    );
    await launch('$link');
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Obx(()=>BlurryModalProgressHUD(

        inAsyncCall: controllerAgenda.isLoading.value, child: Scaffold(
      bottomNavigationBar:Container(
        padding: EdgeInsets.all(10),
        child:  RaisedButton(
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),

          onPressed: (){

            if (_formKey.currentState!.validate()) {

            ///  controllerAgenda.isLoading.value=true;

              Fluttertoast.showToast(
                  msg: "Estamos buscando la mejor oferta..",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blueAccent,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

              if(controllerSearch.latitudeTo.value==0.0){
                Future.delayed(const Duration(milliseconds: 2000), () {
                  openwhatsapp(context);
                  controllerAgenda.isLoading.value=false;

                });
              }else{


               var distanceTotal= distance(controllerHome.latitude.value, controllerHome.longitude.value, controllerSearch.latitudeTo.value, controllerSearch.longitudeTo.value,"K");

               controllerAgenda.totalKm.value=double.parse(distanceTotal);
               var totalKmPrice=(controllerAgenda.totalKm.value*5000)+30000;

               if(totalKmPrice<130000){

                 controllerAgenda.priceKm.value=130000;
               }else{
                 controllerAgenda.priceKm.value=totalKmPrice;
               }
               //controllerAgenda.priceKm.value=controllerAgenda.totalKm.value*5000;
                controllerAgenda.findingDriver(context);

                Get.to(() => Offer());
              }





            }


          },
          child: Text("Calcular mudanza",style: TextStyle(color: Colors.white,fontSize: 20),),
          padding: EdgeInsets.only(top: 10,bottom: 10),

          color: Colors.blueAccent,
        ),
      ),

      appBar: AppBar(

        iconTheme: IconThemeData(
          color: Colors.blueAccent, //change your color here
        ),
        title: Text("Confirma tu mudanza",style: TextStyle(color: Colors.blueAccent),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(()=>SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,

            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15,top: 10),
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
                        controller: controllerAgenda.contollerFrom.value,
                        onTap: (){

                        },
                        onChanged: (input){


                        },

                        onFieldSubmitted: (input){

                        },
                        decoration: InputDecoration(
                            label: Text("Desde"),

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
                            return 'Por favor ingresa una direción para la mudanza';
                          }
                          return null;
                        },
                      )),

                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 10),
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
                        controller: controllerAgenda.contollerTo.value,

                        onChanged: (value){

                        },



                        onFieldSubmitted: (input){


                        },


                        decoration: InputDecoration(
                            label: Text("Hasta"),

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
                            return 'Por favor ingresa una direción para la mudanza';
                          }
                          return null;
                        },
                      )),

                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,bottom: 40),
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
                      Expanded(child:  DateTimePicker(
                        type: DateTimePickerType.dateTime,
                        dateMask: 'd MMMM, yyyy - hh:mm a',
                        // controller: controllerAgenda.controllerDate.value,
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        //icon: Icon(Icons.event),
                        dateLabelText: 'Fecha de la mudanza',
                        use24HourFormat: false,
                        locale: Locale('es', 'ES'),
                        onChanged: (val) {
                          controllerAgenda.controllerDate.value=val;

                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Por favor ingresa una fecha';
                          }
                        },
                        onSaved: (val)   {
                          if(val!=null){
                            controllerAgenda.controllerDate.value=val;
                          }
                        },
                      )),

                    ],
                  ),
                ),
                Divider(

                  height: 2,
                  color: Colors.blueAccent,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20,bottom: 10),

                  child: Text("Tus datos:",style: TextStyle(color: Colors.blueAccent,fontSize: 20),),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15,bottom: 10),
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
                        controller: controllerAgenda.controllerName.value,

                        onChanged: (value){

                        },



                        onFieldSubmitted: (input){


                        },


                        decoration: InputDecoration(
                            label: Text("Nombre"),

                            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                            hintText: "Ingresa tú nombre",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.all(0)),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu nombre';
                          }
                          return null;
                        },
                      )),

                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15,bottom: 10),
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
                        controller: controllerAgenda.controllerPhone.value,

                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            label: Text("Celular"),

                            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                            hintText: "Ingresa tú celular",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.all(0)),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu celular';
                          }
                          return null;
                        },
                      )),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ))
      ,
    )));
  }

}