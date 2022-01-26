import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudanzas_acarreos/agenda/controllers/AgendaController.dart';
import 'package:intl/intl.dart';

class Offer extends StatelessWidget{

  AgendaController agendaController = Get.find();


  formatedNumber(number) {
    var formatCurrency;
    formatCurrency = new NumberFormat.currency(
        customPattern: "\u00A4#,##0.00\u00A0",
        symbol: "",
        decimalDigits: 0,
        locale: "es");

    return formatCurrency.format(number);

  }

  returnTotal(){
    return 5-agendaController.currentSeconds.value;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:Container(
        padding: EdgeInsets.all(10),
        child:  RaisedButton(
          padding: EdgeInsets.only(top: 10,bottom: 10),

          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),

          onPressed: (){
            agendaController.openwhatsapp(context);

          },
          child: Obx(()=>returnTotal() == 0 ? Text("Buscando un Moover",style: TextStyle(color: Colors.white,fontSize: 20),): Text("Buscando un Moover ${returnTotal()}",style: TextStyle(color: Colors.white,fontSize: 20),)),

          color: Colors.blueAccent,
        ),
      ),

      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Valor aproximado",style: TextStyle(fontSize: 20),),
              Text("\$ ${formatedNumber(agendaController.priceKm.value.toInt())}",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text("Distancia mudanza ${agendaController.totalKm.value} km",style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
              ),

            ],
          ),
        ),
      ),
      appBar: AppBar(

        iconTheme: IconThemeData(
          color: Colors.blueAccent, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text("Calcula tu mudanza",style: TextStyle(color: Colors.blueAccent),),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
  
}