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
          style: Theme.of(context).textTheme.headline1,
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
    shareFile();
  }

  Future<void> importDb() async {}

  Future<void> shareFile() async {
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
}
