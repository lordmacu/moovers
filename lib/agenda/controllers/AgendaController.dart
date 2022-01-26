import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:mudanzas_acarreos/home/controllers/homeController.dart';
import 'package:mudanzas_acarreos/home/home.dart';
import 'package:mudanzas_acarreos/search/controllers/searchController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class AgendaController extends GetxController {

 // AgendaController controllerAgenda= AgendaController();

  var contollerFrom= TextEditingController().obs;
  var contollerTo= TextEditingController().obs;
  var controllerDate= "".obs;
  var controllerName=  TextEditingController().obs;
  var controllerPhone=  TextEditingController().obs;
  var isLoading=false.obs;
  var totalKm=0.0.obs;
  var priceKm=0.0.obs;
  var counter=5;
  var timerMaxSeconds=5;
  final interval = const Duration(seconds: 1);
  var currentSeconds=0.obs;

  SearchController controllerSearch= Get.find();

  @override
  void onInit() {
    var outputFormat = DateFormat('d MMMM, yyyy - hh:mm a');
    var outputDate = outputFormat.format(DateTime.now());
    controllerDate.value=outputDate.toString();

  }
  openwhatsapp(context) async{



    final link = WhatsAppUnilink(
      phoneNumber: '+573154645370',
      text: "hola soy ${controllerName.value.text} mi celular es ${controllerPhone.value.text} y me gustaría una mudanza de ${contollerFrom.value.text}  a ${contollerTo.value.text} el dia ${controllerDate.value} distancia ${totalKm.value} precio ${priceKm.value}",
    );
    await launch('$link');

    totalKm.value=0.0;
    priceKm.value=0.0;
    controllerSearch.tabOnTo.value=false;

    controllerSearch.latitudeTo.value=0.0;
    controllerSearch.longitudeTo.value=0.0;
  }



  findingDriver(context){
        Timer.periodic(interval, (timer)  async{

      print("aquiii estoy  ${timer.tick}");

      if(timer.tick==5){
      await openwhatsapp(context);
      }

        currentSeconds.value = timer.tick;
        if (timer.tick >= timerMaxSeconds)  timer.cancel();



    });
  }

}
