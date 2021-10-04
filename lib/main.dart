import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_ajr/Helper/DatabaseHelper.dart';
import 'package:quran_ajr/Widget/dialogue.dart';
import 'package:quran_ajr/Widget/my_drawer.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: QuranPage([1,"Alfatiha"])
    );
  }
}
class QuranPage extends StatefulWidget {
  var sura;
  QuranPage(this.sura);

  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  List<Map> ayat = [{"text":"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"}];
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    initilize();

  }
  initilize() async{
    // Create a new file within your document directory (Probably want to check whether it already exists first...)

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path+"quran-uthmani.db";

    ByteData data = await rootBundle.load("assets/quran-uthmani.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);

    //getting the databse from the path

    Database db = await openDatabase(path,version: 1, onConfigure: (Database db){ print(db.path);});
    if(widget.sura[0]==1){
      ayat = await db.rawQuery("SELECT * FROM 'quran' WHERE sura='${widget.sura[0]}'");
    }else{
      ayat.addAll(await db.rawQuery("SELECT * FROM 'quran' WHERE sura='${widget.sura[0]}'"));
    }

    print(ayat);
    setState(() {

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Drawer(child: MyDrawer()),
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.list),onPressed: (){
        _key.currentState!.openDrawer();
      },), title: Text(widget.sura[1]),),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
            itemCount: ayat.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onLongPress: ayat[index]["text"] != "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ" ? (){

                  showDialog(context: context, builder: (context)=>CheckDialog(aya: ayat[index]));
                }:(){},
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: ayat[index]["text"] != "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ" ? BoxDecoration(border:Border(bottom: BorderSide(color: Colors.blueGrey, width: 1))) : null,
                        child: Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Text(ayat[index]["text"], textAlign: ayat[index]["text"] != "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ" ? TextAlign.start : TextAlign.center, textDirection: TextDirection.rtl,style: ayat[index]["text"] != "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ" ? TextStyle(fontSize: 40) : TextStyle(fontSize: 30),),
                    ),),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}

