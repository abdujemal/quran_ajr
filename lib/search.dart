import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_ajr/controller.dart';

class SearchPage extends StatelessWidget {
  var myController = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: 
      myController.isSearching.value ?
      const Center(
        child:  CircularProgressIndicator(),
      ):
       ListView.builder(
         itemCount: myController.data.length,
         // ignore: prefer_const_constructors
         itemBuilder: (context, index) => Padding(
           padding: const EdgeInsets.only(top:8.0),
           child: Card(
             child:Padding(
               padding: EdgeInsets.all(4),
               child: Text(myController.data[index]["text"]),
               ),
           ),
         ),

      ),
    );
  }
}
