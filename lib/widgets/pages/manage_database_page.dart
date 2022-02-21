import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_of_classes/constants/app_strings.dart';

class ManageDatabasePage extends StatefulWidget {
  const ManageDatabasePage({Key? key}) : super(key: key);

  @override
  _ManageDatabasePageState createState() => _ManageDatabasePageState();
}

class _ManageDatabasePageState extends State<ManageDatabasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.MANAGE_DATABASE,
          style: Theme
              .of(context)
              .textTheme
              .headline1,
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
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
          text: AppStrings.EXPORTING_DATABASE_TEXT,
          filePath: '${dir.path}/${AppStrings.DATABASE_NAME}',
        );
      },
    );
  }

  Future<void> importDb() async {
    await getApplicationDocumentsDirectory().then(
          (dir) async {
            FilePickerCross myFile = await FilePickerCross.importFromStorage(
              type: FileTypeCross.any,
            );
            myFile.saveToPath(path: '${dir.path}/${AppStrings.DATABASE_NAME}');
      },
    );
  }


// String? outputFile = await FilePicker.platform.saveFile(
//   dialogTitle: 'Please select an output file:',
//   fileName: AppStrings.DATABASE_NAME,
// );

// FilePickerResult? result = await FilePicker.platform.pickFiles(
//     allowMultiple: true);
//
// if (result != null) {
//   List<File> files = result.paths.map((path) => File(path!)).toList();
// } else {
//   // User canceled the picker
// }
}
