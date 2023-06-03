import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MyController extends GetxController {
  var isSearching = true.obs;
  var data = [].obs;

  

  Future<void> initilizeData() async {
    // Create a new file within your document directory (Probably want to check whether it already exists first...)

    isSearching = true as RxBool;

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "quran-uthmani.db";

    ByteData data = await rootBundle.load("assets/quran-uthmani.db");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(path).writeAsBytes(bytes);

    //getting the databse from the path

    Database db =
        await openDatabase(path, version: 1, onConfigure: (Database db) {
      print(db.path);
    });

    data = (await db.rawQuery("SELECT * FROM 'quran'")) as ByteData;
    print(data);

    isSearching = false as RxBool;
  }
}
