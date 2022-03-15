import 'dart:io';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

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
          AppStrings.manageDatabase,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextButton(
                child: const Text(AppStrings.exportDatabase),
                onPressed: exportDb,
              ),
              TextButton(
                child: const Text(AppStrings.importDatabase),
                onPressed: importDb,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> exportDb() async {
    String path = (await getExternalStorageDirectory())!.path;
    FlutterShare.shareFile(
      title: AppStrings.exportingDatabaseDialogTitle,
      filePath: '$path/${AppStrings.databaseDirectory}',
    );
  }

  Future<void> importDb() async {
    _showWarningDialog();
  }

  void _showWarningDialog() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.selectTheFileToBeImported),
        content: _dialogContent(),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _getImportedFile().then(
                (selectedFile) async {
                  await _getDatabaseFile().then((currentDatabase) =>
                      _updateDatabaseFile(
                          '${selectedFile.path}', currentDatabase));
                  return selectedFile;
                },
              );
            },
            child: const Text(AppStrings.ok),
          ),
        ],
      ),
    );
  }

  Future<FilePickerCross> _getImportedFile() async {
    return await FilePickerCross.importFromStorage(
      type: FileTypeCross.any,
    ).then(
      (selectedFile) async {
        if (selectedFile.fileName!.endsWith(AppStrings.databaseExtension)) {
          return selectedFile;
        }
        return _getImportedFile();
      },
    );
  }

  Future<File> _getDatabaseFile() async {
    return await getApplicationDocumentsDirectory().then(
      (currentAppDirectory) async {
        final currentDatabaseDirectory = Directory(
            '${currentAppDirectory.path}/${AppStrings.databaseDirectory}/${AppStrings.databaseFullFileName}');

        final dbFile = File(currentDatabaseDirectory.path);

        return dbFile;
      },
    );
  }

  Future<void> _updateDatabaseFile(
      String importedFilePath, File database) async {
    await rootBundle.load(importedFilePath).then(
      (data) {
        database.writeAsBytes(data.buffer.asUint8List());
        SnackBarInfoTemplate(
            context: context,
            message: AppStrings.databaseWasSuccessfullyImported);
        return data;
      },
    );
  }

  Widget _dialogContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Text(AppStrings.chosenFileNeedToHaveSpecificExtension),
        Center(
          child: Text(
            AppStrings.databaseExtension,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          AppStrings.otherwiseTheDbWillNotBeImpoertedCorrectly,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        Text(
          AppStrings.messageAfterCorrectlyImportDb,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
