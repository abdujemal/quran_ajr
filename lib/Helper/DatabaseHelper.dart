import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  var db;
  String path = "";
  List<Map> list = [];
  SaveOnThePhone() async {
    // Create a new file within your document directory (Probably want to check whether it already exists first...)

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    path = documentsDirectory.path+"quran-uthmani.db";

    ByteData data = await rootBundle.load("assets/quran-uthmani.db");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);

  }

  getDB() async {
    db = await openDatabase(path,version: 1, onConfigure: (Database db){ print(db.path);});
    // Get the records
    list = await db.rawQuery('SELECT * FROM quran');

  }

  printIT() {
    print(list);
  }
}
