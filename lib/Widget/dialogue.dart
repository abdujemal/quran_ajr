import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
class CheckDialog extends StatefulWidget {
  var aya;
  CheckDialog({this.aya});

  @override
  _CheckDialogState createState() => _CheckDialogState();
}

class _CheckDialogState extends State<CheckDialog> {
  bool isStartFrom = true;
  int numberOfAjr = 0;
  bool isYesPressed = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPref();

  }
  checkPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int startedFrom = (prefs.getInt('startedFrom') ?? 0);
    if(startedFrom==0) {
      setState(() {
        isStartFrom = true;
      });
    }else{
      setState((){
        isStartFrom = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(

      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
          decoration:numberOfAjr != 0 ? BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(image: AssetImage("assets/congrats.gif",),fit: BoxFit.fill)
          ): null,
          height: numberOfAjr == 0 ? 130 : 200,
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: numberOfAjr == 0 ? Column(
              children: [
                Text(isStartFrom ?
                "Are you sure you want to start counting your ajir from Surah: "+widget.aya["sura_name"]+" Aya:"+widget.aya["aya"]+"?" :
                "Are you sure you want to counting your ajir up to Surah: "+widget.aya["sura_name"]+" Aya:"+widget.aya["aya"]+"?",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,),
                Spacer(),

                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      }, child: Text("No"),),
                    Spacer(),
                    !isStartFrom ?
                    ElevatedButton(
                      child: Text("Restart"),
                      onPressed: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setInt('startedFrom', 0);
                        setState((){
                          isStartFrom = true;
                        });
                      },) : SizedBox(),
                    Spacer(),
                    isYesPressed ?
                    CircularProgressIndicator():
                    ElevatedButton(
                      onPressed: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        int startedFrom = (prefs.getInt('startedFrom') ?? 0);
                        if(startedFrom==0){
                          await prefs.setInt('startedFrom', int.parse(widget.aya["index"]));
                          Navigator.pop(context);
                        }else{
                          int upto = int.parse(widget.aya["index"]);
                          calculate(startedFrom,upto,context);
                          await prefs.setInt('startedFrom', 0);
                          setState((){
                            isYesPressed = true;
                          });

                        }
                      },
                      child: Text("Yes"),)
                  ],
                )
              ],
            ):
            Column(

              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Congratulations, You will get $numberOfAjr Ajr Inshallah. Keep on reciting...",style: TextStyle(fontSize: 18,color: Colors.green, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                // Image.asset("assets/congrats.gif", height: 100,)


              ],
            ),
          )
      ),
    );
  }

  void calculate(int startedFrom, int upto,BuildContext context) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path+"quran-uthmani.db";

    String countableChars = "أ,ب,ت,ث,ج,ح,خ,د,ذ,ر,ز,س,ش,ص,ض,ط,ظ,ع,غ,ف,ق,ك,ل,م,ن,هـ,و,ي";

    Database db = await openDatabase(path,version: 1, onConfigure: (Database db){ print(db.path);});
    List<Map> ayat = await db.rawQuery("SELECT * FROM 'quran'");
    List<String> selectedAyat = [];
    for(var i = startedFrom;i<=upto;i++){
      selectedAyat.add(ayat[i]["text"]);
    }
    int numOfAjr = 0;
    for(var s in selectedAyat){
      for(var j=0;j<s.length;j++){
        if(countableChars.contains(s.substring(j,j+1))) {
          numOfAjr++;
        }
      }
    }
    print(numOfAjr);
    setState((){
      numberOfAjr = numOfAjr*10;
    });
    ayat = [];
    selectedAyat = [];
    db.close();

  }
}



