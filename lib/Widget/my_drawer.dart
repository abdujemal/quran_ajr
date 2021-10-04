import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:quran_ajr/main.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  var suras = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJSON();

  }
  getJSON() async{
    String data = await DefaultAssetBundle.of(context).loadString("assets/chapters.en.json");
    suras = jsonDecode(data); //latest Dart
    print(jsonDecode(data));
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Suras"),),
      body: Container(
          child: suras["chapters"] != null ? ListView.builder(
              itemCount: suras["chapters"].length,
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(suras["chapters"][index]["name_simple"]),
                  subtitle: Text(suras["chapters"][index]["revelation_place"]),
                  leading: Icon(Icons.book),
                  trailing: Card(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text("${suras["chapters"][index]["verses_count"]} Verses",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  onTap: (){
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(builder: (BuildContext context) => QuranPage([suras["chapters"][index]["chapter_number"],suras["chapters"][index]["name_simple"]])),
                      ModalRoute.withName('/'),
                    );

                    print(suras["chapters"][index]["chapter_number"]);
                  },
                );
              }):SizedBox()
      ),
    );
  }
}
