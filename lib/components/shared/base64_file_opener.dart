import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class Base64FileOpener extends StatelessWidget {
  final String base64String;
  final String fileName;

  const Base64FileOpener({
    super.key,
    required this.base64String,
    required this.fileName,
  });

  Future<void> _openFile() async {
    Uint8List bytes = base64Decode(base64String);
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$fileName");
    await file.writeAsBytes(bytes);
    OpenFilex.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    print('Base64 string: $base64String');
    return Scaffold(
      appBar: AppBar(title: Text("File Opener")),
      body: Center(
        child: ElevatedButton(onPressed: _openFile, child: Text("Open File")),
      ),
    );
  }
}
