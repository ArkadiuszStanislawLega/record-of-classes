import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';

class ManageDatabasePage extends StatefulWidget {
  const ManageDatabasePage({Key? key}) : super(key: key);

  @override
  _ManageDatabasePageState createState() => _ManageDatabasePageState();
}

class _ManageDatabasePageState extends State<ManageDatabasePage> {
  String _path = '', _length = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.MANAGE_DATABASE,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(_path),
              Text(_length),
              TextButton(
                child: const Text(AppStrings.EXPORT_DATABASE),
                onPressed: exportDb,
              ),
              TextButton(
                child: const Text(AppStrings.IMPORT_DATABASE),
                onPressed: importDb,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> exportDb() async {
    await getApplicationDocumentsDirectory().then(
      (dir) {
        FlutterShare.shareFile(
          title: AppStrings.EXPORTING_DATABASE_TITLE,
          filePath: '${dir.path}/${AppStrings.DATABASE_NAME}',
        );
      },
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('path ${path}');
    return File('$path/${AppStrings.DATABASE_NAME}/data.mdb');
  }

  Future<int> deleteFile() async {
    try {
      final file = await _localFile;
      print('usuwam: $file');
      await file.delete();
    } catch (e) {
      return 0;
    }
    return 0;
  }

  Future<void> importDb() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final objectBoxDirectory = Directory(
        documentsDirectory.path + '/${AppStrings.DATABASE_NAME}/data.mdb');

    FilePickerCross myFile = await FilePickerCross.importFromStorage(
      type: FileTypeCross.any,
    );


    final dbFile = File(objectBoxDirectory.path);

    ByteData data = await rootBundle.load("${myFile.path}");

    dbFile.writeAsBytes(data.buffer.asUint8List());

    setState(
      () {
        _length = myFile.length.toString();
        _path = myFile.path!;
      },
    );
  }
}
